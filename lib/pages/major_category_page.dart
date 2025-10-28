import 'package:flutter/material.dart';

/// 专业课分类页
class MajorCategoryPage extends StatelessWidget {
  const MajorCategoryPage({super.key});

  static const List<String> subjects = ['计组', '计网', '数据结构', '计算机系统'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('专业课'),
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
            ...subjects.map((subject) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _SubjectCard(
                    title: subject,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/error-list',
                        arguments: {'subject': subject},
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3F51B5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}


