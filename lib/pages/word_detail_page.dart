import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/data_manager.dart';
import '../services/api_manager.dart';
import '../widgets/ai_response_widget.dart';

/// 单词详情与编辑页
class WordDetailPage extends StatefulWidget {
  const WordDetailPage({super.key});

  @override
  State<WordDetailPage> createState() => _WordDetailPageState();
}

class _WordDetailPageState extends State<WordDetailPage> {
  final DataManager _dataManager = DataManager();
  final ApiManager _apiManager = ApiManager();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _aiQuestionController = TextEditingController();

  Word _word = Word();
  bool _isNew = true;
  bool _isAiLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadWord();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _aiQuestionController.dispose();
    super.dispose();
  }

  Future<void> _loadWord() async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      _isNew = args['isNew'] as bool? ?? true;

      if (!_isNew) {
        final id = args['id'] as String?;
        if (id != null) {
          final word = await _dataManager.getWordById(id);
          if (word != null) {
            setState(() {
              _word = word;
              _titleController.text = word.title;
              _contentController.text = word.content;
            });
          }
        }
      }
    }
  }

  Future<void> _saveWord() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入单词标题')),
      );
      return;
    }

    _word = _word.copyWith(
      title: _titleController.text,
      content: _contentController.text,
    );

    final success = await _dataManager.saveWord(_word);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存成功')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存失败')),
      );
    }
  }

  Future<void> _askAi() async {
    if (_aiQuestionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入问题')),
      );
      return;
    }

    setState(() {
      _isAiLoading = true;
    });

    final response = await _apiManager.callDeepSeek(
      _aiQuestionController.text,
      _word.content,
    );

    setState(() {
      _isAiLoading = false;
      _word = _word.copyWith(aiResponse: response);
      _aiQuestionController.clear();
    });

    // 自动保存AI回复
    await _dataManager.saveWord(_word);

    if (mounted) {
      Navigator.pop(context); // 关闭对话框
    }
  }

  void _showAiDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '向AI提问',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _aiQuestionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: '请输入你的问题...',
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _aiQuestionController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9E9E9E),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('取消'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isAiLoading ? null : _askAi,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C27B0),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(_isAiLoading ? '请求中...' : '发送'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(_isNew ? '新建单词' : '编辑单词'),
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
        actions: [
          TextButton(
            onPressed: _saveWord,
            child: const Text(
              '保存',
              style: TextStyle(fontSize: 16, color: Color(0xFF4CAF50)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 单词标题
            const Text(
              '单词',
              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: '请输入单词',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 详细内容
            const Text(
              '详细内容',
              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              minLines: 3,
              maxLines: null,
              decoration: InputDecoration(
                hintText: '请输入释义、音标、例句等',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // AI助手回复
            AiResponseWidget(
              content: _word.aiResponse,
              title: 'AI助手回复',
            ),
            const SizedBox(height: 20),

            // 与AI对话按钮
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _showAiDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C27B0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '与 AI 对话',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


