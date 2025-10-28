import 'package:flutter/material.dart';
import 'markdown_demo_page.dart';

/// 主页 - DR学习助手
class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // 标题
            const Padding(
              padding: EdgeInsets.only(top: 60, bottom: 40),
              child: Text(
                'DR习题助手',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E88E5),
                ),
              ),
            ),

            // 导航卡片容器
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // 单词速记卡片
                  _NavigationCard(
                    title: '单词速记',
                    color: const Color(0xFF4CAF50),
                    onTap: () {
                      Navigator.pushNamed(context, '/word-list');
                    },
                  ),
                  const SizedBox(height: 20),

                  // 错题速记卡片
                  _NavigationCard(
                    title: '错题速记',
                    color: const Color(0xFFFF9800),
                    onTap: () {
                      Navigator.pushNamed(context, '/error-main');
                    },
                  ),
                  const SizedBox(height: 20),

                  // API填写卡片
                  _NavigationCard(
                    title: 'API填写',
                    color: const Color(0xFF9C27B0),
                    onTap: () {
                      Navigator.pushNamed(context, '/api-config');
                    },
                  ),
                  const SizedBox(height: 20),

                  // 与AI对话演示卡片
                  _NavigationCard(
                    title: '与 AI 对话',
                    color: const Color(0xFF2196F3),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MarkdownDemoPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // 数据管理卡片
                  _NavigationCard(
                    title: '数据管理',
                    color: const Color(0xFF607D8B),
                    onTap: () {
                      Navigator.pushNamed(context, '/data-management');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _NavigationCard({
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}


