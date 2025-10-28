# 更新日志

## v1.1.1 (2025-10-28)

### 🐛 Bug修复

**Android 导出路径修复：**
- ✅ 修复 Android 手机端导出文件路径错误
- ✅ 从应用私有目录 `/data/user/0/...` 改为公共存储 `/storage/emulated/0/Documents/`
- ✅ 用户现在可以通过文件管理器直接访问导出的文件

**权限更新：**
- ✅ 添加 Android 存储权限（READ_EXTERNAL_STORAGE、WRITE_EXTERNAL_STORAGE）
- ✅ 添加 Android 11+ 的 MANAGE_EXTERNAL_STORAGE 权限
- ✅ 启用 requestLegacyExternalStorage 支持旧版存储方式

**平台优化：**
- ✅ 添加平台检测，为不同平台使用合适的存储路径
- ✅ Android: `/storage/emulated/0/Documents/`
- ✅ Windows: `C:\Users\用户名\Documents\`
- ✅ iOS: 应用文档目录

---

## v1.1.0 (2025-10-28)

### ✨ 新增功能

**数据同步功能：**
- ✅ 数据导出到本地（时间戳命名）
- ✅ 数据分享功能（通过系统分享）
- ✅ 数据导入功能
- ✅ 数据统计显示

**界面优化：**
- ✅ 详情页文本框高度自适应
- ✅ 导出成功显示文件路径对话框
- ✅ 数据管理页面美化

### 📝 文档完善

- ✅ 创建完整的 README.md
- ✅ 添加使用指南 USAGE_GUIDE.md
- ✅ 添加数据同步指南 DATA_SYNC_GUIDE.md
- ✅ 添加 GitHub 上传检查清单
- ✅ 添加安全检查报告

### 🐛 Bug修复

- ✅ 修复 API 字符串转义问题
- ✅ 升级 file_picker 解决 Android 兼容性问题

---

## v1.0.0 (2025-10-27)

### 🎉 初始版本

**核心功能：**
- ✅ 单词速记功能
- ✅ 错题管理功能（数学、专业课、政治）
- ✅ AI 智能助手（DeepSeek API）
- ✅ Markdown 渲染支持
- ✅ LaTeX 数学公式支持
- ✅ 本地数据存储

**支持平台：**
- ✅ Windows
- ✅ Android
- ✅ iOS（理论支持）

---

## 升级指南

### 从 v1.1.0 升级到 v1.1.1

**Android 用户重要提示：**

如果您已经使用 v1.1.0 版本导出过数据，请注意：

1. **旧版本导出的文件位置：**
   - `/data/user/0/com.example.flutter_app_dr/app_flutter/1234567890.json`
   - 这个文件无法通过文件管理器访问

2. **新版本导出的文件位置：**
   - `/storage/emulated/0/Documents/1234567890.json`
   - 可以通过文件管理器访问

3. **建议操作：**
   - 安装新版本后，重新导出一次数据
   - 旧版本的数据文件已经无法直接访问（但数据仍在应用内）

**Windows/iOS 用户：**
- 无需特殊操作，升级即可使用

---

## 路线图

### 计划中的功能

**v1.2.0 (计划中):**
- [ ] 云端同步支持（可选）
- [ ] 数据备份自动化
- [ ] 学习统计图表
- [ ] 复习提醒功能

**v1.3.0 (计划中):**
- [ ] 主题切换（深色模式）
- [ ] 字体大小调整
- [ ] 更多 AI 模型支持
- [ ] 导出格式选项（PDF、Markdown）

**长期规划:**
- [ ] 多语言支持（英文）
- [ ] Web 版本优化
- [ ] 插件系统
- [ ] 社区分享功能

---

## 反馈与建议

如果您在使用过程中遇到问题或有改进建议，欢迎：

- 📧 提交 GitHub Issue
- 💬 参与 GitHub Discussions
- ⭐ 给项目点个 Star

---

<div align="center">

**感谢您的使用和支持！**

[返回 README](./README.md) | [查看使用指南](./USAGE_GUIDE.md)

</div>


