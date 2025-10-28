// 政治分类页
import router from '@ohos.router'

@Entry
@Component
struct PoliticsCategory {
  private subjects: string[] = ['马原', '毛特', '史纲', '新思想']

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

        Text('政治')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

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

      // 科目列表
      Column({ space: 20 }) {
        ForEach(this.subjects, (subject: string) => {
          this.SubjectCard(subject, () => {
            router.pushUrl({
              url: 'pages/ErrorList',
              params: { subject: subject }
            })
          })
        })
      }
      .width('90%')
      .margin({ top: 30 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder SubjectCard(title: string, onClick: () => void) {
    Button() {
      Text(title)
        .fontSize(20)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .height(70)
    .backgroundColor('#F44336')
    .borderRadius(12)
    .onClick(onClick)
  }
}

