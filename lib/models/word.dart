/// 单词数据模型
class Word {
  String id;
  String title; // 单词标题
  String content; // 释义、音标、例句等详细内容
  String aiResponse; // AI回复内容
  int createTime; // 创建时间戳

  Word({
    String? id,
    this.title = '',
    this.content = '',
    this.aiResponse = '',
    int? createTime,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createTime = createTime ?? DateTime.now().millisecondsSinceEpoch;

  // 从 JSON 转换
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      aiResponse: json['aiResponse'] as String? ?? '',
      createTime: json['createTime'] as int? ?? 0,
    );
  }

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'aiResponse': aiResponse,
      'createTime': createTime,
    };
  }

  // 创建副本
  Word copyWith({
    String? id,
    String? title,
    String? content,
    String? aiResponse,
    int? createTime,
  }) {
    return Word(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      aiResponse: aiResponse ?? this.aiResponse,
      createTime: createTime ?? this.createTime,
    );
  }
}


