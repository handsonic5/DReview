// 错题详情与编辑页（模板，复用）
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import DataManager from '../utils/DataManager'
import ApiManager from '../utils/ApiManager'
import { ErrorQuestion } from '../models/ErrorQuestion'

@Entry
@Component
struct ErrorDetail {
  @State error: ErrorQuestion = new ErrorQuestion()
  @State subject: string = ''
  @State isNew: boolean = true
  @State showAiDialog: boolean = false
  @State aiQuestion: string = ''
  @State isAiLoading: boolean = false

  async aboutToAppear() {
    // 确保数据管理器已初始化
    await DataManager.init(getContext(this))
    await ApiManager.init(getContext(this))
    
    const params = router.getParams() as Record<string, Object>
    this.subject = params.subject as string
    this.isNew = params.isNew as boolean

    if (!this.isNew) {
      const id = params.id as string
      const error = await DataManager.getErrorById(id)
      if (error) {
        this.error = error
      }
    } else {
      this.error.subject = this.subject
    }
  }

  async saveError() {
    if (!this.error.title.trim()) {
      promptAction.showToast({ message: '请输入错题标题' })
      return
    }

    this.error.subject = this.subject
    const success = await DataManager.saveError(this.error)
    if (success) {
      promptAction.showToast({ message: '保存成功' })
      router.back()
    } else {
      promptAction.showToast({ message: '保存失败' })
    }
  }

  async askAi() {
    if (!this.aiQuestion.trim()) {
      promptAction.showToast({ message: '请输入问题' })
      return
    }

    this.isAiLoading = true
    const response = await ApiManager.callDeepSeek(this.aiQuestion, this.error.content)
    this.isAiLoading = false

    this.error.aiResponse = response
    this.showAiDialog = false
    this.aiQuestion = ''

    // 自动保存AI回复
    await DataManager.saveError(this.error)
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

        Text(this.isNew ? `新建错题 - ${this.subject}` : `编辑错题 - ${this.subject}`)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .maxLines(1)

        Button('保存')
          .fontSize(16)
          .backgroundColor('#4CAF50')
          .onClick(() => {
            this.saveError()
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 2, color: '#00000020' })

      // 内容区
      Scroll() {
        Column({ space: 16 }) {
          // 错题标题
          Column({ space: 8 }) {
            Text('题目标题')
              .fontSize(14)
              .fontColor('#666666')
            TextInput({ text: this.error.title, placeholder: '请输入错题标题' })
              .fontSize(16)
              .backgroundColor('#FFFFFF')
              .borderRadius(8)
              .onChange((value: string) => {
                this.error.title = value
              })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)

          // 详细内容
          Column({ space: 8 }) {
            Text('详细内容')
              .fontSize(14)
              .fontColor('#666666')
            TextArea({ text: this.error.content, placeholder: '请输入题目、解答过程、错误原因等' })
              .width('100%')
              .fontSize(16)
              .backgroundColor('#FFFFFF')
              .borderRadius(8)
              .padding(12)
              .onChange((value: string) => {
                this.error.content = value
              })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)

          // AI输出区
          Column({ space: 8 }) {
            Text('AI助手回复')
              .fontSize(14)
              .fontColor('#666666')
            Text(this.error.aiResponse || '暂无AI回复')
              .width('100%')
              .fontSize(14)
              .fontColor(this.error.aiResponse ? '#333333' : '#999999')
              .padding(12)
              .constraintSize({ minHeight: 100 })
              .backgroundColor('#FFFFFF')
              .borderRadius(8)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)

          // 与AI对话按钮
          Button('与 AI 对话')
            .width('100%')
            .height(48)
            .backgroundColor('#9C27B0')
            .fontSize(18)
            .margin({ top: 10 })
            .onClick(() => {
              this.showAiDialog = true
            })
        }
        .width('90%')
        .padding({ top: 20, bottom: 20 })
      }
      .layoutWeight(1)
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .bindSheet(this.showAiDialog, this.AiDialogContent(), {
      height: 300,
      backgroundColor: Color.White
    })
  }

  @Builder AiDialogContent() {
    Column() {
      Text('向AI提问')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })

      TextArea({ text: this.aiQuestion, placeholder: '请输入你的问题...' })
        .width('90%')
        .height(120)
        .fontSize(14)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .margin({ bottom: 20 })
        .onChange((value: string) => {
          this.aiQuestion = value
        })

      Row({ space: 20 }) {
        Button('取消')
          .fontSize(16)
          .backgroundColor('#9E9E9E')
          .layoutWeight(1)
          .onClick(() => {
            this.showAiDialog = false
            this.aiQuestion = ''
          })

        Button(this.isAiLoading ? '请求中...' : '发送')
          .fontSize(16)
          .backgroundColor('#9C27B0')
          .layoutWeight(1)
          .enabled(!this.isAiLoading)
          .onClick(() => {
            this.askAi()
          })
      }
      .width('80%')
    }
    .width('100%')
  }
}

