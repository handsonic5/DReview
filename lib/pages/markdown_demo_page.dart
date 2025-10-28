import 'package:flutter/material.dart';
import '../widgets/ai_response_widget.dart';

/// Markdown演示页面
class MarkdownDemoPage extends StatelessWidget {
  const MarkdownDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    const sampleMarkdown = r'''
# AI助手回复示例

这是一个支持**Markdown格式**和**LaTeX数学公式**的AI回复控件演示。

## 主要功能

- ✅ **Markdown渲染** - 支持标题、列表、代码块等
- ✅ **LaTeX数学公式** - 支持行内公式和块级公式
- ✅ **复制功能** - 点击复制按钮
- ✅ **美观样式** - 精心设计的UI样式
- ✅ **可选中文本** - 支持文本选择

## 数学公式示例

### 行内公式
这是一个行内公式：$E = mc^2$，爱因斯坦的质能方程。

勾股定理：$a^2 + b^2 = c^2$

### 常用数学符号
- 希腊字母：$\alpha, \beta, \gamma, \theta, \pi$
- 分数：$\frac{1}{2}, \frac{a}{b}$
- 根号：$\sqrt{2}, \sqrt[3]{8}$
- 求和：$\sum_{i=1}^{n} i = \frac{n(n+1)}{2}$
- 积分：$\int_{0}^{1} x^2 dx = \frac{1}{3}$
- 极限：$\lim_{x \to \infty} \frac{1}{x} = 0$

### 向量和矩阵
- 向量：$\vec{v} = (x, y, z)$
- 点积：$\vec{a} \cdot \vec{b} = |\vec{a}||\vec{b}|\cos\theta$
- 梯度：$\nabla f$

### 微积分
- 导数：$\frac{dy}{dx}, \frac{\partial f}{\partial x}$
- 二阶导数：$\frac{d^2y}{dx^2}$
- 链式法则：$\frac{dy}{dx} = \frac{dy}{du} \cdot \frac{du}{dx}$

## 代码示例

```dart
void main() {
  print('Hello, Flutter!');
}
```

## 引用块

> 这是一个引用块，用于突出显示重要信息。

## 表格

| 功能 | 状态 | 说明 |
|------|------|------|
| Markdown | ✅ | 完全支持 |
| LaTeX | ✅ | 数学公式 |
| 复制 | ✅ | 一键复制 |
| 样式 | ✅ | 美观设计 |

## 列表

1. 第一项
2. 第二项
3. 第三项

- 无序列表项1
- 无序列表项2
- 无序列表项3

---

*这个控件可以完美渲染AI助手的回复内容，包括数学公式！*
''';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Markdown演示'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
        shadowColor: Colors.black12,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基础控件演示
            AiResponseWidget(
              content: sampleMarkdown,
              title: '基础Markdown控件',
            ),
            const SizedBox(height: 30),
            
            // 带加载状态的控件演示
            AiResponseWidgetWithLoading(
              content: sampleMarkdown,
              title: '带加载状态的控件',
              isLoading: false,
            ),
            const SizedBox(height: 30),
            
            // 空内容演示
            AiResponseWidget(
              content: '',
              title: '空内容演示',
            ),
            const SizedBox(height: 30),
            
            // 自定义样式演示
            AiResponseWidget(
              content: '''
## 自定义样式演示

这个控件支持**自定义样式**：

- 背景色
- 内边距
- 最小高度
- 标题显示/隐藏

> 所有样式都可以通过参数自定义！
''',
              title: '自定义样式',
              backgroundColor: const Color(0xFFF0F8FF),
              padding: const EdgeInsets.all(16),
              minHeight: 150,
            ),
          ],
        ),
      ),
    );
  }
}
