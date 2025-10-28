// API配置页面
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import ApiManager from '../utils/ApiManager'

@Entry
@Component
struct ApiConfig {
  @State apiKey: string = ''

  async aboutToAppear() {
    // 确保API管理器已初始化
    await ApiManager.init(getContext(this))
    // 加载已保存的API Key
    this.apiKey = await ApiManager.getApiKey()
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

        Text('API配置')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // 占位，保持标题居中
        Button()
          .backgroundColor(Color.Transparent)
          .width(60)
          .visibility(Visibility.Hidden)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')
      .shadow({ radius: 2, color: '#00000020' })

      // 内容区
      Column() {
        Text('请输入DeepSeek API Key')
          .fontSize(16)
          .fontColor('#666666')
          .margin({ bottom: 10 })

        TextArea({ text: this.apiKey })
          .width('100%')
          .height(120)
          .fontSize(14)
          .borderRadius(8)
          .backgroundColor('#FFFFFF')
          .onChange((value: string) => {
            this.apiKey = value
          })

        Button('保存')
          .width('100%')
          .height(48)
          .backgroundColor('#4CAF50')
          .fontSize(18)
          .margin({ top: 30 })
          .onClick(async () => {
            const success = await ApiManager.saveApiKey(this.apiKey)
            if (success) {
              promptAction.showToast({ message: '保存成功' })
              router.back()
            } else {
              promptAction.showToast({ message: '保存失败' })
            }
          })
      }
      .width('90%')
      .margin({ top: 30 })
      .padding(20)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

