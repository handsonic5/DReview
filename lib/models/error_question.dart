/// 错题数据模型
class ErrorQuestion {
  String id;
  String subject; // 科目（如：高等数学、线性代数等）
  String title; // 错题标题
  String content; // 错题详细内容
  String aiResponse; // AI回复内容
  int createTime; // 创建时间戳

  ErrorQuestion({
    String? id,
    this.subject = '',
    this.title = '',
    this.content = '',
    this.aiResponse = '',
    int? createTime,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createTime = createTime ?? DateTime.now().millisecondsSinceEpoch;

  // 从 JSON 转换
  factory ErrorQuestion.fromJson(Map<String, dynamic> json) {
    return ErrorQuestion(
      id: json['id'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
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
      'subject': subject,
      'title': title,
      'content': content,
      'aiResponse': aiResponse,
      'createTime': createTime,
    };
  }

  // 创建副本
  ErrorQuestion copyWith({
    String? id,
    String? subject,
    String? title,
    String? content,
    String? aiResponse,
    int? createTime,
  }) {
    return ErrorQuestion(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      title: title ?? this.title,
      content: content ?? this.content,
      aiResponse: aiResponse ?? this.aiResponse,
      createTime: createTime ?? this.createTime,
    );
  }
}


