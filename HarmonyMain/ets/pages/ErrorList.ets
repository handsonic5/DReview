// 错题列表页（模板，复用）
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import DataManager from '../utils/DataManager'
import { ErrorQuestion } from '../models/ErrorQuestion'

@Entry
@Component
struct ErrorList {
  @State subject: string = ''
  @State errors: ErrorQuestion[] = []
  @State filteredErrors: ErrorQuestion[] = []
  @State searchText: string = ''
  @State showDeleteDialog: boolean = false
  @State deleteId: string = ''

  async aboutToAppear() {
    // 确保数据管理器已初始化
    await DataManager.init(getContext(this))
    
    const params = router.getParams() as Record<string, Object>
    this.subject = params.subject as string
    await this.loadErrors()
  }

  // 页面显示时刷新数据（从详情页返回时会触发）
  onPageShow() {
    if (this.subject) {
      this.loadErrors()
    }
  }

  async loadErrors() {
    this.errors = await DataManager.getErrorsBySubject(this.subject)
    // 按创建时间降序排序（最新的在最前面）
    this.errors.sort((a, b) => b.createTime - a.createTime)
    this.filterErrors()
    console.info('错题列表已刷新，科目:', this.subject, '当前数量:', this.errors.length)
  }

  filterErrors() {
    if (this.searchText.trim() === '') {
      this.filteredErrors = this.errors
    } else {
      this.filteredErrors = this.errors.filter(e =>
        e.title.toLowerCase().includes(this.searchText.toLowerCase())
      )
    }
  }

  // 格式化日期为"今天"、"昨天"或"MM-DD"
  formatDate(timestamp: number): string {
    const date = new Date(timestamp)
    const today = new Date()
    const yesterday = new Date(today)
    yesterday.setDate(yesterday.getDate() - 1)

    const dateStr = date.toDateString()
    const todayStr = today.toDateString()
    const yesterdayStr = yesterday.toDateString()

    if (dateStr === todayStr) {
      return '今天'
    } else if (dateStr === yesterdayStr) {
      return '昨天'
    } else {
      const month = date.getMonth() + 1
      const day = date.getDate()
      return `${month}月${day}日`
    }
  }

  // 格式化时间为"HH:MM"
  formatTime(timestamp: number): string {
    const date = new Date(timestamp)
    const hours = date.getHours().toString().padStart(2, '0')
    const minutes = date.getMinutes().toString().padStart(2, '0')
    return `${hours}:${minutes}`
  }

  // 获取日期分组
  getDateGroups(): Map<string, ErrorQuestion[]> {
    const groups = new Map<string, ErrorQuestion[]>()
    for (const error of this.filteredErrors) {
      const dateKey = this.formatDate(error.createTime)
      if (!groups.has(dateKey)) {
        groups.set(dateKey, [])
      }
      groups.get(dateKey)!.push(error)
    }
    return groups
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Button('返回')
          .fontSize(16)
          .backgroundColor('#2196F3')
          .onClick(() => {
            router.back()
          })

        Text(this.subject)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button('添加')
          .fontSize(16)
          .backgroundColor('#4CAF50')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/ErrorDetail',
              params: { subject: this.subject, id: '', isNew: true }
            })
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 2, color: '#00000020' })

      // 搜索框
      Row() {
        TextInput({ placeholder: '搜索错题...', text: this.searchText })
          .width('100%')
          .height(40)
          .fontSize(14)
          .backgroundColor('#F0F0F0')
          .borderRadius(20)
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.searchText = value
            this.filterErrors()
          })
      }
      .width('90%')
      .margin({ top: 16, bottom: 16 })

      // 错题列表（按日期分组）
      if (this.filteredErrors.length === 0) {
        Column() {
          Text(this.searchText ? '未找到相关错题' : '暂无错题，点击右上角添加')
            .fontSize(16)
            .fontColor('#999999')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 0 }) {
          ForEach(Array.from(this.getDateGroups().entries()), (group: [string, ErrorQuestion[]]) => {
            ListItemGroup({
              header: this.DateHeader(group[0])
            }) {
              ForEach(group[1], (error: ErrorQuestion) => {
                ListItem() {
                  Row() {
                    Column({ space: 4 }) {
                      Text(error.title)
                        .fontSize(18)
                        .fontColor('#333333')
                        .fontWeight(FontWeight.Medium)
                      
                      Text(this.formatTime(error.createTime))
                        .fontSize(12)
                        .fontColor('#999999')
                    }
                    .alignItems(HorizontalAlign.Start)
                    .layoutWeight(1)
                    .onClick(() => {
                      router.pushUrl({
                        url: 'pages/ErrorDetail',
                        params: { subject: this.subject, id: error.id, isNew: false }
                      })
                    })

                    Button('删除')
                      .fontSize(14)
                      .backgroundColor('#F44336')
                      .height(36)
                      .onClick(() => {
                        this.deleteId = error.id
                        this.showDeleteDialog = true
                      })
                  }
                  .width('100%')
                  .height(70)
                  .padding({ left: 16, right: 16 })
                  .backgroundColor('#FFFFFF')
                }
                .margin({ bottom: 1 })
              }, (error: ErrorQuestion) => error.id)
            }
          }, (group: [string, ErrorQuestion[]]) => group[0])
        }
        .width('90%')
        .layoutWeight(1)
        .backgroundColor('#F5F5F5')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .bindSheet(this.showDeleteDialog, this.DeleteConfirmDialog(), {
      height: 200,
      backgroundColor: Color.White
    })
  }

  @Builder DateHeader(dateText: string) {
    Row() {
      Text(dateText)
        .fontSize(14)
        .fontColor('#666666')
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .height(36)
    .padding({ left: 16 })
    .backgroundColor('#F0F0F0')
  }

  @Builder DeleteConfirmDialog() {
    Column() {
      Text('确认删除')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })

      Text('确定要删除这道错题吗？')
        .fontSize(16)
        .fontColor('#666666')
        .margin({ bottom: 30 })

      Row({ space: 20 }) {
        Button('取消')
          .fontSize(16)
          .backgroundColor('#9E9E9E')
          .layoutWeight(1)
          .onClick(() => {
            this.showDeleteDialog = false
          })

        Button('确定')
          .fontSize(16)
          .backgroundColor('#F44336')
          .layoutWeight(1)
          .onClick(async () => {
            const success = await DataManager.deleteError(this.deleteId)
            this.showDeleteDialog = false
            if (success) {
              promptAction.showToast({ message: '删除成功' })
              await this.loadErrors()
            } else {
              promptAction.showToast({ message: '删除失败' })
            }
          })
      }
      .width('80%')
    }
    .width('100%')
  }
}

