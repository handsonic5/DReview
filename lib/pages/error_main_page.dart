import 'package:flutter/material.dart';

/// 错题主页 - 科目分类导航
class ErrorMainPage extends StatelessWidget {
  const ErrorMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('错题速记'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
        shadowColor: Colors.black12,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            '返回',
            style: TextStyle(fontSize: 16, color: Color(0xFF2196F3)),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            _CategoryCard(
              title: '数学',
              color: const Color(0xFFE91E63),
              onTap: () {
                Navigator.pushNamed(context, '/math-category');
              },
            ),
            const SizedBox(height: 20),
            _CategoryCard(
              title: '专业课',
              color: const Color(0xFF3F51B5),
              onTap: () {
                Navigator.pushNamed(context, '/major-category');
              },
            ),
            const SizedBox(height: 20),
            _CategoryCard(
              title: '政治',
              color: const Color(0xFFF44336),
              onTap: () {
                Navigator.pushNamed(context, '/politics-category');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
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


