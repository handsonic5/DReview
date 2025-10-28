import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// AI助手回复控件，支持Markdown渲染和复制功能
class AiResponseWidget extends StatelessWidget {
  final String content;
  final String? title;
  final bool showTitle;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? minHeight;

  const AiResponseWidget({
    Key? key,
    required this.content,
    this.title,
    this.showTitle = true,
    this.padding,
    this.backgroundColor,
    this.minHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Text(
            title ?? 'AI助手回复',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: minHeight ?? 100,
          ),
          padding: padding ?? const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: content.isEmpty
              ? const Text(
                  '暂无AI回复',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Markdown 内容（支持LaTeX）
                    _MarkdownWithLatex(content: content),
                    const SizedBox(height: 8),
                    // 复制按钮
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _copyToClipboard(context),
                        icon: const Icon(
                          Icons.copy,
                          size: 16,
                        ),
                        label: const Text('复制'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF9C27B0),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  /// 复制内容到剪贴板
  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: content));
    
    // 显示复制成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已复制到剪贴板'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }
}

/// 带加载状态的AI回复控件
class AiResponseWidgetWithLoading extends StatefulWidget {
  final String content;
  final String? title;
  final bool showTitle;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? minHeight;

  const AiResponseWidgetWithLoading({
    Key? key,
    required this.content,
    this.title,
    this.showTitle = true,
    this.isLoading = false,
    this.padding,
    this.backgroundColor,
    this.minHeight,
  }) : super(key: key);

  @override
  State<AiResponseWidgetWithLoading> createState() => _AiResponseWidgetWithLoadingState();
}

class _AiResponseWidgetWithLoadingState extends State<AiResponseWidgetWithLoading> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle) ...[
          Text(
            widget.title ?? 'AI助手回复',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: widget.minHeight ?? 100,
          ),
          padding: widget.padding ?? const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: widget.isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9C27B0)),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'AI正在思考中...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                )
              : widget.content.isEmpty
                  ? const Text(
                      '暂无AI回复',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Markdown 内容（支持LaTeX）
                        _MarkdownWithLatex(content: widget.content),
                        const SizedBox(height: 8),
                        // 复制按钮
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => _copyToClipboard(context),
                            icon: const Icon(
                              Icons.copy,
                              size: 16,
                            ),
                            label: const Text('复制'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF9C27B0),
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ],
    );
  }

  /// 复制内容到剪贴板
  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.content));
    
    // 显示复制成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已复制到剪贴板'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }
}

/// 支持LaTeX的Markdown渲染控件
class _MarkdownWithLatex extends StatelessWidget {
  final String content;

  const _MarkdownWithLatex({required this.content});

  @override
  Widget build(BuildContext context) {
    // 解析内容，分离Markdown和LaTeX部分
    final parts = _parseContentWithLatex(content);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: parts.map((part) {
        if (part['type'] == 'latex') {
          // 渲染LaTeX公式
          try {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              child: Math.tex(
                part['content'] as String,
                textStyle: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                mathStyle: MathStyle.text,
              ),
            );
          } catch (e) {
            // 如果LaTeX渲染失败，显示原始文本
            return Text(
              part['content'] as String,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFE83E8C),
                fontFamily: 'monospace',
              ),
            );
          }
        } else {
          // 渲染Markdown
          return MarkdownWidget(
            data: part['content'] as String,
            selectable: true,
            shrinkWrap: true,
          );
        }
      }).toList(),
    );
  }

  /// 解析内容，分离Markdown和LaTeX部分
  List<Map<String, dynamic>> _parseContentWithLatex(String text) {
    final List<Map<String, dynamic>> parts = [];
    
    // 支持多种LaTeX格式：
    // 1. $...$ - 行内公式
    // 2. \(...\) - 行内公式
    // 3. \[...\] - 块级公式
    // 4. \\command - LaTeX命令（如 \nabla, \theta 等）
    final RegExp latexPattern = RegExp(
      r'\$([^\$]+)\$|'  // $...$
      r'\\\(([^\)]+)\\\)|'  // \(...\)
      r'\\\[([^\]]+)\\\]|'  // \[...\]
      r'\\[a-zA-Z]+(?:\{[^\}]*\})*',  // \command{...}
      multiLine: true,
    );
    
    int lastIndex = 0;
    for (final match in latexPattern.allMatches(text)) {
      // 添加LaTeX之前的Markdown内容
      if (match.start > lastIndex) {
        final markdownContent = text.substring(lastIndex, match.start);
        if (markdownContent.isNotEmpty) {
          parts.add({'type': 'markdown', 'content': markdownContent});
        }
      }
      
      // 提取LaTeX公式内容
      String latexContent = match.group(1) ?? 
                           match.group(2) ?? 
                           match.group(3) ?? 
                           match.group(0)!;
      
      // 如果是 \command 格式，直接使用
      if (latexContent.startsWith('\\') && !latexContent.contains(r'\(') && !latexContent.contains(r'\[')) {
        latexContent = latexContent;
      }
      
      parts.add({'type': 'latex', 'content': latexContent});
      lastIndex = match.end;
    }
    
    // 添加剩余的Markdown内容
    if (lastIndex < text.length) {
      final markdownContent = text.substring(lastIndex);
      if (markdownContent.isNotEmpty) {
        parts.add({'type': 'markdown', 'content': markdownContent});
      }
    }
    
    // 如果没有找到LaTeX，返回整个内容作为Markdown
    if (parts.isEmpty) {
      parts.add({'type': 'markdown', 'content': text});
    }
    
    return parts;
  }
}
