import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/data_manager.dart';
import 'package:intl/intl.dart';

/// 单词列表页
class WordListPage extends StatefulWidget {
  const WordListPage({super.key});

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  final DataManager _dataManager = DataManager();
  List<Word> _words = [];
  List<Word> _filteredWords = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final words = await _dataManager.getWords();
    // 按创建时间降序排序（最新的在最前面）
    words.sort((a, b) => b.createTime.compareTo(a.createTime));
    setState(() {
      _words = words;
      _filterWords();
    });
    print('单词列表已刷新，当前数量: ${words.length}');
  }

  void _filterWords() {
    if (_searchText.trim().isEmpty) {
      _filteredWords = _words;
    } else {
      _filteredWords = _words
          .where((w) =>
              w.title.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }
  }

  // 格式化日期为"今天"、"昨天"或"MM月DD日"
  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return '今天';
    } else if (dateOnly == yesterday) {
      return '昨天';
    } else {
      return DateFormat('M月d日').format(date);
    }
  }

  // 格式化时间为"HH:MM"
  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('HH:mm').format(date);
  }

  // 获取日期分组
  Map<String, List<Word>> _getDateGroups() {
    final groups = <String, List<Word>>{};
    for (final word in _filteredWords) {
      final dateKey = _formatDate(word.createTime);
      groups.putIfAbsent(dateKey, () => []).add(word);
    }
    return groups;
  }

  Future<void> _deleteWord(String id) async {
    final success = await _dataManager.deleteWord(id);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('删除成功')),
      );
      await _loadWords();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('删除失败')),
      );
    }
  }

  void _showDeleteDialog(String id) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '确认删除',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '确定要删除这个单词吗？',
              style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
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
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteWord(id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF44336),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('确定'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateGroups = _getDateGroups();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('单词列表'),
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
            onPressed: () async {
              await Navigator.pushNamed(
                context,
                '/word-detail',
                arguments: {'isNew': true},
              );
              _loadWords();
            },
            child: const Text(
              '添加',
              style: TextStyle(fontSize: 16, color: Color(0xFF4CAF50)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索框
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索单词...',
                filled: true,
                fillColor: const Color(0xFFF0F0F0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                  _filterWords();
                });
              },
            ),
          ),

          // 单词列表
          Expanded(
            child: _filteredWords.isEmpty
                ? Center(
                    child: Text(
                      _searchText.isNotEmpty ? '未找到相关单词' : '暂无单词，点击右上角添加',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF999999),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: dateGroups.length,
                    itemBuilder: (context, index) {
                      final dateKey = dateGroups.keys.elementAt(index);
                      final words = dateGroups[dateKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 日期头部
                          Container(
                            width: double.infinity,
                            height: 36,
                            padding: const EdgeInsets.only(left: 16),
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF0F0F0),
                            ),
                            child: Text(
                              dateKey,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // 该日期的单词列表
                          ...words.map((word) => Container(
                                margin: const EdgeInsets.only(bottom: 1),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  title: Text(
                                    word.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    _formatTime(word.createTime),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF999999),
                                    ),
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: () => _showDeleteDialog(word.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF44336),
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(60, 36),
                                    ),
                                    child: const Text('删除'),
                                  ),
                                  onTap: () async {
                                    await Navigator.pushNamed(
                                      context,
                                      '/word-detail',
                                      arguments: {
                                        'id': word.id,
                                        'isNew': false,
                                      },
                                    );
                                    _loadWords();
                                  },
                                ),
                              )),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}


