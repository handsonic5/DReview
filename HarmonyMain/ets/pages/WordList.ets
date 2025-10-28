// 单词列表页
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import DataManager from '../utils/DataManager'
import { Word } from '../models/Word'

@Entry
@Component
struct WordList {
  @State words: Word[] = []
  @State filteredWords: Word[] = []
  @State searchText: string = ''
  @State showDeleteDialog: boolean = false
  @State deleteId: string = ''

  async aboutToAppear() {
    // 确保数据管理器已初始化
    await DataManager.init(getContext(this))
    await this.loadWords()
  }

  // 页面显示时刷新数据（从详情页返回时会触发）
  onPageShow() {
    this.loadWords()
  }

  async loadWords() {
    this.words = await DataManager.getWords()
    // 按创建时间降序排序（最新的在最前面）
    this.words.sort((a, b) => b.createTime - a.createTime)
    this.filterWords()
    console.info('单词列表已刷新，当前数量:', this.words.length)
  }

  filterWords() {
    if (this.searchText.trim() === '') {
      this.filteredWords = this.words
    } else {
      this.filteredWords = this.words.filter(w =>
        w.title.toLowerCase().includes(this.searchText.toLowerCase())
      )
    }
  }

  // 格式化日期为"今天"、"昨天"或"MM-DD"
  formatDate(timestamp: number): string {
    const date = new Date(timestamp)
    const today = new Date()
    const yesterday = new Date(today)
    yesterday.setDate(yesterday.getDate() - 1)

    // 重置时间为0点，方便比较日期
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
  getDateGroups(): Map<string, Word[]> {
    const groups = new Map<string, Word[]>()
    for (const word of this.filteredWords) {
      const dateKey = this.formatDate(word.createTime)
      if (!groups.has(dateKey)) {
        groups.set(dateKey, [])
      }
      groups.get(dateKey)!.push(word)
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

        Text('单词列表')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button('添加')
          .fontSize(16)
          .backgroundColor('#4CAF50')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/WordDetail',
              params: { id: '', isNew: true }
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
        TextInput({ placeholder: '搜索单词...', text: this.searchText })
          .width('100%')
          .height(40)
          .fontSize(14)
          .backgroundColor('#F0F0F0')
          .borderRadius(20)
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.searchText = value
            this.filterWords()
          })
      }
      .width('90%')
      .margin({ top: 16, bottom: 16 })

      // 单词列表（按日期分组）
      if (this.filteredWords.length === 0) {
        Column() {
          Text(this.searchText ? '未找到相关单词' : '暂无单词，点击右上角添加')
            .fontSize(16)
            .fontColor('#999999')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 0 }) {
          ForEach(Array.from(this.getDateGroups().entries()), (group: [string, Word[]]) => {
            ListItemGroup({
              header: this.DateHeader(group[0])
            }) {
              ForEach(group[1], (word: Word) => {
                ListItem() {
                  Row() {
                    Column({ space: 4 }) {
                      Text(word.title)
                        .fontSize(18)
                        .fontColor('#333333')
                        .fontWeight(FontWeight.Medium)
                      
                      Text(this.formatTime(word.createTime))
                        .fontSize(12)
                        .fontColor('#999999')
                    }
                    .alignItems(HorizontalAlign.Start)
                    .layoutWeight(1)
                    .onClick(() => {
                      router.pushUrl({
                        url: 'pages/WordDetail',
                        params: { id: word.id, isNew: false }
                      })
                    })

                    Button('删除')
                      .fontSize(14)
                      .backgroundColor('#F44336')
                      .height(36)
                      .onClick(() => {
                        this.deleteId = word.id
                        this.showDeleteDialog = true
                      })
                  }
                  .width('100%')
                  .height(70)
                  .padding({ left: 16, right: 16 })
                  .backgroundColor('#FFFFFF')
                }
                .margin({ bottom: 1 })
              }, (word: Word) => word.id)
            }
          }, (group: [string, Word[]]) => group[0])
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

      Text('确定要删除这个单词吗？')
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
            const success = await DataManager.deleteWord(this.deleteId)
            this.showDeleteDialog = false
            if (success) {
              promptAction.showToast({ message: '删除成功' })
              await this.loadWords()
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

