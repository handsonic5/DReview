// 错题主页 - 科目分类导航
import router from '@ohos.router'

@Entry
@Component
struct ErrorMain {
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

        Text('错题速记')
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

      // 科目分类卡片
      Column({ space: 20 }) {
        this.CategoryCard('数学', '#E91E63', () => {
          router.pushUrl({ url: 'pages/MathCategory' })
        })

        this.CategoryCard('专业课', '#3F51B5', () => {
          router.pushUrl({ url: 'pages/MajorCategory' })
        })

        this.CategoryCard('政治', '#F44336', () => {
          router.pushUrl({ url: 'pages/PoliticsCategory' })
        })
      }
      .width('90%')
      .margin({ top: 30 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder CategoryCard(title: string, color: string, onClick: () => void) {
    Button() {
      Text(title)
        .fontSize(24)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .height(80)
    .backgroundColor(color)
    .borderRadius(12)
    .onClick(onClick)
  }
}

