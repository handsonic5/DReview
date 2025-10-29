# DeepReview - 考研学习助手（其实讲道理应该是FastReview（

<div align="center">

**一个考研学习笔记工具，支持单词速记、错题速记和 AI 智能问答，个人建议主要当作概念记忆手段**

**使用flutter构建，你可以自己弄到其它平台，譬如Web。HarmonyMain文件夹下有鸿蒙部分源码，因为项目由鸿蒙的小项目改编。**

**如果这个项目对您有帮助，请给它一个 ⭐️！如果没有帮助也给一个⭐！（bushi）**

[![Flutter](https://img.shields.io/badge/Flutter-3.9+-blue.svg)](https://flutter.dev/)
[![Platform](https://img.shields.io/badge/Platform-Windows%20|%20Android%20|%20iOS-green.svg)](#)
[![License](https://img.shields.io/badge/License-MIT-orange.svg)](#)

</div>

> 💡 **Fork 此项目后请注意：** 需要自行配置 DeepSeek API Key，项目代码中不包含任何 API Key。详见 [配置 API Key](#🔑-配置-api-key) 部分。

---

## 📸 应用截图

<div align="center">

| 主页 | 错题分类 | 科目列表 |
|:---:|:---:|:---:|
| <img src="1.jpg" width="250"/> | <img src="2.jpg" width="250"/> | <img src="3.jpg" width="250"/> |

| 错题列表 | 数据管理 |
|:---:|:---:|
| <img src="4.jpg" width="250"/> | <img src="5.jpg" width="250"/> |

</div>

---

## 📱 应用简介

DeepReview 是一款专为考研学生（我自己）打造的学习助手应用，提供以下简单核心功能：

- 📚 **单词速记** - 高效管理考研英语词汇
- ❌ **错题管理** - 按科目分类整理错题（数学、专业课、政治）
- 🤖 **AI 助手** - 集成 DeepSeek API，智能解答学习疑问
- 💾 **本地存储** - 所有数据本地保存，离线可用
- 🔄 **跨设备同步** - 支持数据导入导出，电脑手机轻松同步
- ✨ **Markdown 渲染** - 美观的内容展示，支持 LaTeX 数学公式

---

## 🎯 核心功能

### 1. 单词速记

- ✅ 添加、编辑、删除单词
- ✅ 记录单词释义、音标、例句
- ✅ AI 助手辅助学习
- ✅ 支持添加个人笔记

### 2. 错题管理

**按科目分类：**
- 📐 高等数学
- 🔬 线性代数
- 📊 概率论
- 💻 数据结构
- 🖥️ 计算机组成原理
- 🌐 计算机网络
- 🏛️ 马克思主义原理
- 🇨🇳 近代史纲要
- ⚖️ 思想道德与法治

**功能特性：**
- ✅ 记录题目、解答过程、错误原因
- ✅ AI 深度解析错题
- ✅ 快速搜索和过滤
- ✅ 按科目统计分析

### 3. AI 智能助手

- 🤖 集成 DeepSeek AI API
- 💬 智能问答，深度理解
- 📝 Markdown 格式回复
- 🔢 完美支持 LaTeX 数学公式
- 📋 一键复制回复内容

### 4. 数据同步

- 💾 导出数据到本地（时间戳命名）
- 📤 分享数据到其他应用
- 📥 从 JSON 文件导入数据
- 🔄 支持电脑↔手机数据传输

---

## 🚀 快速开始

### 环境要求

- Flutter SDK 3.9.2 或更高版本
- Dart SDK 3.0+
- Android Studio / VS Code
- Windows / macOS / Linux 开发环境

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/your-username/deepreview.git
cd deepreview
```

2. **安装依赖**
```bash
flutter pub get
```

3. **运行项目**

**Windows:**
```bash
flutter run -d windows
```

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

### 构建发布版本

**Windows:**
```bash
flutter build windows
```

**Android APK:**
```bash
flutter build apk
```

**iOS:**
```bash
flutter build ios
```

---

## 🔑 配置 API Key

1. 获取 DeepSeek API Key：访问 [DeepSeek 官网](https://www.deepseek.com/)
2. 打开应用，点击主页的 **"API填写"**
3. 输入您的 API Key
4. 保存后即可使用 AI 助手功能

---

## 📖 功能详解

### Markdown 渲染支持

AI 助手回复支持完整的 Markdown 格式：

- **标题** - H1、H2、H3 等各级标题
- **文本样式** - 粗体、斜体、删除线
- **代码块** - 支持语法高亮
- **列表** - 有序/无序列表
- **引用块** - 引用样式
- **表格** - 表格渲染
- **链接** - 超链接支持

### LaTeX 数学公式

使用 `$...$` 包裹数学公式即可渲染：

**行内公式：**
```markdown
质能方程 $E = mc^2$ 是相对论的核心。
```

**常用符号：**
- 分数：`$\frac{a}{b}$`
- 根号：`$\sqrt{x}$` 或 `$\sqrt[n]{x}$`
- 希腊字母：`$\alpha, \beta, \gamma, \pi$`
- 求和：`$\sum_{i=1}^{n} x_i$`
- 积分：`$\int_{a}^{b} f(x)dx$`
- 极限：`$\lim_{x \to \infty} f(x)$`
- 矩阵：`$\begin{pmatrix} a & b \\ c & d \end{pmatrix}$`

**完整示例：**
```markdown
对于函数 $f(x, y)$，其梯度定义为：

$\nabla f = \left( \frac{\partial f}{\partial x}, \frac{\partial f}{\partial y} \right)$

根据链式法则：

$\frac{d}{dx}[f(g(x))] = f'(g(x)) \cdot g'(x)$
```

---

## 🔄 数据同步指南

### 电脑 → 手机

1. **电脑端导出**
   - 打开 Windows 应用
   - 点击"数据管理" → "导出数据到本地"
   - 文件保存在文档目录，文件名为时间戳（如 `1730123456789.json`）

2. **传输文件**
   - 通过微信/QQ/邮箱发送到手机
   - 或使用 USB 数据线复制
   - 或上传到云盘（百度网盘、OneDrive 等）

3. **手机端导入**
   - 打开 Android 应用
   - 点击"数据管理" → "导入数据"
   - 选择接收到的 JSON 文件

### 文件路径

- **Windows**: `C:\Users\你的用户名\Documents\1234567890.json`
- **Android**: `/storage/emulated/0/Documents/1234567890.json`
- **iOS**: 应用的文档目录

### 注意事项

⚠️ **导入会覆盖现有数据**  
建议在导入前先导出备份当前数据

🔒 **数据安全**  
导出的文件包含 API Key，请妥善保管

📅 **定期备份**  
建议每周导出一次数据作为备份

完整的数据同步指南请参考：[DATA_SYNC_GUIDE.md](./DATA_SYNC_GUIDE.md)

---

## 📦 依赖包

### 核心依赖

```yaml
dependencies:
  # 本地数据存储
  shared_preferences: ^2.2.2
  
  # HTTP 网络请求
  http: ^1.2.0
  
  # Markdown 渲染
  markdown_widget: ^2.3.2+7
  
  # LaTeX 数学公式
  flutter_math_fork: ^0.7.2
  
  # 文件操作
  path_provider: ^2.1.1
  file_picker: ^8.1.2
  share_plus: ^7.2.1
```

---

## 🏗️ 项目结构

```
lib/
├── main.dart                    # 应用入口
├── models/                      # 数据模型
│   ├── word.dart               # 单词模型
│   └── error_question.dart     # 错题模型
├── services/                    # 服务层
│   ├── data_manager.dart       # 数据管理
│   └── api_manager.dart        # API 调用
├── pages/                       # 页面
│   ├── index_page.dart         # 主页
│   ├── word_list_page.dart     # 单词列表
│   ├── word_detail_page.dart   # 单词详情
│   ├── error_main_page.dart    # 错题主页
│   ├── error_list_page.dart    # 错题列表
│   ├── error_detail_page.dart  # 错题详情
│   ├── api_config_page.dart    # API 配置
│   └── data_management_page.dart # 数据管理
└── widgets/                     # 组件
    └── ai_response_widget.dart # AI 回复组件
```

---

## 🎨 技术特点

### 界面设计

- 🎯 Material Design 3 设计语言
- 🌈 现代化的色彩搭配
- 📱 响应式布局，适配多种屏幕
- ✨ 流畅的动画效果

### 数据管理

- 💾 使用 SharedPreferences 本地存储
- 📦 JSON 序列化/反序列化
- 🔄 支持数据导入导出
- 🔍 高效的数据查询

### AI 集成

- 🤖 集成 DeepSeek API
- ⚡ 异步请求处理
- 🔄 自动重试机制
- ⏱️ 超时处理

---

## 📝 更新日志

### v1.1.0 (2025-10-28)

**新增功能：**
- ✅ 数据导入导出功能
- ✅ 文件分享功能
- ✅ 数据统计显示
- ✅ 跨设备数据同步

**优化改进：**
- ✅ 详情页文本框高度自适应
- ✅ 优化导出文件命名（使用时间戳）
- ✅ 改进文件保存路径（文档目录）

**Bug 修复：**
- ✅ 修复 API 字符串转义问题
- ✅ 解决 Android 构建兼容性问题

### v1.0.0 (2025-10-27)

**初始版本：**
- ✅ 单词速记功能
- ✅ 错题管理功能
- ✅ AI 智能助手
- ✅ Markdown 渲染
- ✅ LaTeX 公式支持
- ✅ 本地数据存储

---

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

### 开发规范

1. 遵循 Flutter 官方代码规范
2. 提交前运行 `flutter analyze` 检查代码
3. 编写清晰的 commit 信息
4. 添加必要的注释和文档

### 提交流程

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

---

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

---

## 🙏 致谢

- [Flutter](https://flutter.dev/) - 跨平台 UI 框架
- [DeepSeek](https://www.deepseek.com/) - AI API 服务
- [markdown_widget](https://pub.dev/packages/markdown_widget) - Markdown 渲染
- [flutter_math_fork](https://pub.dev/packages/flutter_math_fork) - LaTeX 渲染

---

## 📧 联系方式

如有问题或建议，欢迎联系：

咕咕嘎嘎 骗你的，没有联系方式

---

## 🌟 Star History

如果这个项目对您有帮助，请给它一个 ⭐️！如果没有帮助也给一个⭐！（bushi）

---

<div align="center">

**Made with ❤️ by DeepReview Team**

</div>
