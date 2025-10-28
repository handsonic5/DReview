// 主页 - DR学习助手
import router from '@ohos.router'

@Entry
@Component
struct Index {
  build() {
    Column() {
      // 标题
      Text('DR习题助手')
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1E88E5')
        .margin({ top: 60, bottom: 40 })

      // 导航卡片容器
      Column({ space: 20 }) {
        // 单词速记卡片
        this.NavigationCard('单词速记', '#4CAF50', () => {
          router.pushUrl({ url: 'pages/WordList' })
        })

        // 错题速记卡片
        this.NavigationCard('错题速记', '#FF9800', () => {
          router.pushUrl({ url: 'pages/ErrorMain' })
        })

        // API填写卡片
        this.NavigationCard('API填写', '#9C27B0', () => {
          router.pushUrl({ url: 'pages/ApiConfig' })
        })
      }
      .width('90%')
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder NavigationCard(title: string, color: ResourceStr, onClick: () => void) {
    Button() {
      Text(title)
        .fontSize(24)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .height(80)
    .backgroundColor(color)
    .borderRadius(12)
    .onClick(onClick)
  }
}
