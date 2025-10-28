# GitHub 上传前检查清单

在将项目上传到 GitHub 之前，请确保完成以下检查：

---

## ✅ 安全检查

### 1. 敏感信息检查

- [x] **API Key 安全**
  - ✅ 代码中没有硬编码 API Key
  - ✅ API Key 存储在 `SharedPreferences` 本地
  - ✅ 用户需要自己配置 API Key
  
- [x] **本地配置文件已忽略**
  - ✅ `android/local.properties` - 包含本地 SDK 路径
  - ✅ `gradle.properties` - 可能包含代理配置
  - ✅ `ios/Flutter/Generated.xcconfig` - iOS 本地配置

- [x] **构建产物已忽略**
  - ✅ `build/` 目录
  - ✅ `.dart_tool/` 目录
  - ✅ `*.apk`, `*.ipa` 等二进制文件

### 2. 个人信息检查

- [ ] **更新文档中的占位符**
  - ⚠️ `README.md` 中的邮箱地址：`your-email@example.com`
  - ⚠️ `DOCS_INDEX.md` 中的邮箱地址：`your-email@example.com`
  - ⚠️ GitHub 仓库链接：`your-username/deepreview`

### 3. 本地文件检查

- [x] **确保 .gitignore 正确配置**
  - ✅ 包含所有必要的忽略规则
  - ✅ 本地配置文件不会被上传

---

## 📝 上传前准备

### 1. 更新个人信息

替换文档中的占位符为您的真实信息：

**README.md:**
```markdown
- 📮 Email: your-email@example.com  → 您的邮箱
- GitHub: your-username/deepreview  → 您的用户名/仓库名
```

**DOCS_INDEX.md:**
```markdown
- 📧 发送邮件至：your-email@example.com  → 您的邮箱
```

### 2. 创建示例配置文件

已创建：
- ✅ `gradle.properties.example` - 不含敏感代理配置的示例

用户需要：
1. 复制 `gradle.properties.example` 为 `gradle.properties`
2. 根据需要配置代理等本地设置

### 3. 添加 LICENSE 文件

建议添加开源许可证（如 MIT）：

```bash
# 创建 LICENSE 文件
# 访问 https://choosealicense.com/ 选择合适的许可证
```

---

## 🚀 上传步骤

### 方法一：使用 GitHub Desktop（推荐新手）

1. 打开 GitHub Desktop
2. File → Add Local Repository
3. 选择项目文件夹
4. 点击 "Publish repository"
5. 设置仓库名称和描述
6. 取消勾选 "Keep this code private"（如果要公开）
7. 点击 "Publish repository"

### 方法二：使用命令行

```bash
# 1. 初始化 git 仓库（如果还没有）
git init

# 2. 添加远程仓库
git remote add origin https://github.com/your-username/deepreview.git

# 3. 添加所有文件
git add .

# 4. 检查将要提交的文件（重要！）
git status

# 5. 确认没有敏感文件后，提交
git commit -m "Initial commit: DeepReview 考研学习助手"

# 6. 推送到 GitHub
git push -u origin main
```

---

## ⚠️ 上传前最后检查

### 使用 git status 检查

```bash
git status
```

**确保以下文件/目录不在列表中：**
- ❌ `build/`
- ❌ `android/local.properties`
- ❌ `gradle.properties`（如果包含代理配置）
- ❌ `*.apk`, `*.ipa` 等二进制文件
- ❌ `.dart_tool/`

### 使用 git diff 检查内容

```bash
# 查看所有待提交的更改
git diff --cached
```

确保没有包含：
- ❌ API Key
- ❌ 个人邮箱（如果不想公开）
- ❌ 本地路径
- ❌ 代理配置

---

## 📋 上传后的工作

### 1. 设置 GitHub 仓库

- [ ] 添加仓库描述
- [ ] 添加标签（tags）：`flutter`, `deepseek`, `education`, `study-tool`
- [ ] 设置主页（选择 README.md）
- [ ] 启用 Issues（接收反馈）
- [ ] 启用 Discussions（社区讨论）

### 2. 添加 Shields 徽章

在 README.md 顶部的徽章链接需要更新：

```markdown
[![Flutter](https://img.shields.io/badge/Flutter-3.9+-blue.svg)](https://flutter.dev/)
[![Platform](https://img.shields.io/badge/Platform-Windows%20|%20Android%20|%20iOS-green.svg)](#)
[![License](https://img.shields.io/badge/License-MIT-orange.svg)](#)
```

### 3. 创建 Release

```bash
# 打标签
git tag -a v1.1.0 -m "Version 1.1.0 - 数据同步功能"
git push origin v1.1.0
```

然后在 GitHub 上创建 Release，附上：
- 📦 Windows exe 文件
- 📱 Android apk 文件
- 📝 更新说明

---

## 🔒 安全最佳实践

### 如果不小心上传了敏感信息

1. **立即更改 API Key**
   - 登录 DeepSeek 控制台
   - 删除或重新生成 API Key

2. **从 Git 历史中删除**
   ```bash
   # 使用 git filter-branch 或 BFG Repo-Cleaner
   # 参考：https://docs.github.com/cn/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository
   ```

3. **强制推送清理后的历史**
   ```bash
   git push --force
   ```

### 预防措施

1. ✅ 始终使用 `.gitignore`
2. ✅ 上传前运行 `git status` 检查
3. ✅ 敏感配置使用环境变量或本地配置文件
4. ✅ 提供示例配置文件（如 `config.example.json`）

---

## ✅ 检查清单总结

在推送到 GitHub 之前，确认：

- [ ] `.gitignore` 已正确配置
- [ ] 没有硬编码的 API Key
- [ ] 本地配置文件已被忽略
- [ ] 构建产物已被忽略
- [ ] 文档中的个人信息已更新
- [ ] 运行 `git status` 确认无敏感文件
- [ ] 已创建 LICENSE 文件
- [ ] README.md 中的链接已更新

---

## 📞 需要帮助？

如果不确定某个文件是否应该上传：

1. 查看 `.gitignore` 规则
2. 运行 `git check-ignore -v <文件名>` 检查
3. 在 GitHub Issues 中询问

---

<div align="center">

**祝您的项目在 GitHub 上大受欢迎！⭐**

</div>

