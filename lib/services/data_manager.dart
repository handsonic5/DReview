import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/word.dart';
import '../models/error_question.dart';

/// 数据管理类 - 负责本地数据持久化
class DataManager {
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  static const String _keyWords = 'words';
  static const String _keyErrors = 'errors';
  static const String _keyInitialized = 'data_initialized';

  // 初始化数据存储
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final initialized = prefs.getBool(_keyInitialized) ?? false;

      if (!initialized) {
        print('首次启动，初始化默认数据...');
        await _initDefaultData();
        await prefs.setBool(_keyInitialized, true);
        print('默认数据初始化完成');
      } else {
        print('数据已初始化，跳过');
      }
    } catch (err) {
      print('初始化数据存储失败: $err');
    }
  }

  // 初始化默认数据
  Future<void> _initDefaultData() async {
    await _initDefaultWords();
    await _initDefaultErrors();
  }

  // 初始化默认单词
  Future<void> _initDefaultWords() async {
    final defaultWords = [
      Word(
        id: '${DateTime.now().millisecondsSinceEpoch}_1',
        title: 'abandon',
        content: '''释义：v. 放弃；抛弃；离弃
音标：/əˈbændən/
例句：
1. We had to abandon the car and walk the rest of the way.
   我们只好弃车，步行完成剩下的路程。
2. Never abandon hope in face of difficulties.
   面对困难永远不要放弃希望。
词根：from French "a bandon" = at one's disposal''',
      ),
      Word(
        id: '${DateTime.now().millisecondsSinceEpoch}_2',
        title: 'ambiguous',
        content: '''释义：adj. 模棱两可的；含糊不清的
音标：/æmˈbɪɡjuəs/
例句：
1. Her answer was ambiguous, so I couldn't tell if she agreed.
   她的回答模棱两可，我无法判断她是否同意。
2. The treaty is deliberately ambiguous to allow flexibility.
   条约故意含糊其辞以保持灵活性。
同义词：vague, unclear, equivocal
反义词：clear, explicit, unambiguous''',
      ),
    ];

    for (final word in defaultWords) {
      await saveWord(word);
    }
    print('默认单词初始化完成，共${defaultWords.length}个');
  }

  // 初始化默认错题（部分示例）
  Future<void> _initDefaultErrors() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final defaultErrors = [
      // 高等数学
      ErrorQuestion(
        id: '${now}_math1',
        subject: '高等数学',
        title: '求极限：lim(x→0) sin(x)/x',
        content: '''题目：求 lim(x→0) sin(x)/x 的值

解答：
方法一：洛必达法则
lim(x→0) sin(x)/x = lim(x→0) cos(x)/1 = 1

方法二：泰勒展开
sin(x) = x - x³/3! + x⁵/5! - ...
sin(x)/x = 1 - x²/3! + x⁴/5! - ...
当 x→0 时，结果为 1

错误原因：之前忘记了这是一个重要极限公式，需要牢记。''',
      ),
      ErrorQuestion(
        id: '${now}_math2',
        subject: '高等数学',
        title: '求定积分：∫₀¹ x²dx',
        content: '''题目：计算定积分 ∫₀¹ x²dx

解答步骤：
1. 求不定积分：∫ x²dx = x³/3 + C
2. 应用牛顿-莱布尼茨公式：
   ∫₀¹ x²dx = [x³/3]₀¹ = 1³/3 - 0³/3 = 1/3

答案：1/3

注意事项：
- 计算时要注意上下限
- 记住幂函数积分公式：∫ xⁿdx = x^(n+1)/(n+1) + C''',
      ),
      // 线性代数
      ErrorQuestion(
        id: '${now}_linear1',
        subject: '线性代数',
        title: '求2阶矩阵的行列式',
        content: '''题目：求矩阵 A = |2  3| 的行列式
              |1  4|

解答：
|A| = 2×4 - 3×1 = 8 - 3 = 5

公式：对于2阶矩阵 |a  b|
              |c  d|
行列式 = ad - bc

易错点：减法顺序不要搞反了''',
      ),
      // 计组
      ErrorQuestion(
        id: '${now}_arch1',
        subject: '计组',
        title: 'CPU的基本组成',
        content: '''题目：简述CPU的基本组成部分及其功能。

解答：
CPU主要由以下部分组成：

1. 运算器（ALU）
   - 算术运算（加减乘除）
   - 逻辑运算（与或非等）

2. 控制器（CU）
   - 指令译码
   - 发出控制信号
   - 协调各部件工作

3. 寄存器组
   - 通用寄存器
   - 专用寄存器（PC、IR、MAR、MDR等）

4. 内部总线
   - 连接各部件''',
      ),
      // 马原
      ErrorQuestion(
        id: '${now}_marx1',
        subject: '马原',
        title: '物质和意识的辩证关系',
        content: '''题目：阐述物质和意识的辩证关系。

解答：

一、物质决定意识（物质第一性）
1. 意识是物质世界长期发展的产物
2. 意识是人脑的机能
3. 意识是客观存在的主观映像

二、意识对物质具有能动作用
1. 意识活动具有目的性和计划性
2. 意识活动具有创造性
3. 意识通过实践改造客观世界
4. 意识还能调控人的行为和生理活动

三、方法论意义
1. 坚持一切从实际出发
2. 充分发挥主观能动性
3. 把尊重客观规律和发挥主观能动性结合起来

记忆口诀：物质决定，意识能动''',
      ),
    ];

    for (final error in defaultErrors) {
      await saveError(error);
    }
    print('默认错题初始化完成，共${defaultErrors.length}个');
  }

  // ========== 单词管理 ==========

  // 获取所有单词
  Future<List<Word>> getWords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_keyWords) ?? '[]';
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => Word.fromJson(json)).toList();
    } catch (err) {
      print('获取单词失败: $err');
      return [];
    }
  }

  // 保存单词
  Future<bool> saveWord(Word word) async {
    try {
      final words = await getWords();
      final index = words.indexWhere((w) => w.id == word.id);

      if (index >= 0) {
        words[index] = word;
        print('更新单词: ${word.title}');
      } else {
        words.add(word);
        print('新增单词: ${word.title}');
      }

      final prefs = await SharedPreferences.getInstance();
      final jsonData = jsonEncode(words.map((w) => w.toJson()).toList());
      await prefs.setString(_keyWords, jsonData);

      print('单词保存成功');
      return true;
    } catch (err) {
      print('保存单词失败: $err');
      return false;
    }
  }

  // 删除单词
  Future<bool> deleteWord(String id) async {
    try {
      final words = await getWords();
      words.removeWhere((w) => w.id == id);

      final prefs = await SharedPreferences.getInstance();
      final jsonData = jsonEncode(words.map((w) => w.toJson()).toList());
      await prefs.setString(_keyWords, jsonData);

      return true;
    } catch (err) {
      print('删除单词失败: $err');
      return false;
    }
  }

  // 根据ID获取单词
  Future<Word?> getWordById(String id) async {
    final words = await getWords();
    try {
      return words.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  // ========== 错题管理 ==========

  // 获取所有错题
  Future<List<ErrorQuestion>> getErrors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_keyErrors) ?? '[]';
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => ErrorQuestion.fromJson(json)).toList();
    } catch (err) {
      print('获取错题失败: $err');
      return [];
    }
  }

  // 获取指定科目的错题
  Future<List<ErrorQuestion>> getErrorsBySubject(String subject) async {
    final errors = await getErrors();
    return errors.where((e) => e.subject == subject).toList();
  }

  // 保存错题
  Future<bool> saveError(ErrorQuestion error) async {
    try {
      final errors = await getErrors();
      final index = errors.indexWhere((e) => e.id == error.id);

      if (index >= 0) {
        errors[index] = error;
        print('更新错题: ${error.title}, 科目: ${error.subject}');
      } else {
        errors.add(error);
        print('新增错题: ${error.title}, 科目: ${error.subject}');
      }

      final prefs = await SharedPreferences.getInstance();
      final jsonData = jsonEncode(errors.map((e) => e.toJson()).toList());
      await prefs.setString(_keyErrors, jsonData);

      print('错题保存成功');
      return true;
    } catch (err) {
      print('保存错题失败: $err');
      return false;
    }
  }

  // 删除错题
  Future<bool> deleteError(String id) async {
    try {
      final errors = await getErrors();
      errors.removeWhere((e) => e.id == id);

      final prefs = await SharedPreferences.getInstance();
      final jsonData = jsonEncode(errors.map((e) => e.toJson()).toList());
      await prefs.setString(_keyErrors, jsonData);

      return true;
    } catch (err) {
      print('删除错题失败: $err');
      return false;
    }
  }

  // 根据ID获取错题
  Future<ErrorQuestion?> getErrorById(String id) async {
    final errors = await getErrors();
    try {
      return errors.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  // ========== 数据导入导出 ==========

  /// 导出所有数据到JSON文件
  Future<String?> exportData() async {
    try {
      // 获取所有数据
      final words = await getWords();
      final errors = await getErrors();
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('deepseek_api') ?? '';

      // 构建导出数据
      final exportData = {
        'version': '1.0',
        'exportTime': DateTime.now().toIso8601String(),
        'apiKey': apiKey,
        'words': words.map((w) => w.toJson()).toList(),
        'errors': errors.map((e) => e.toJson()).toList(),
      };

      // 生成JSON字符串
      final jsonString = jsonEncode(exportData);

      // 获取合适的保存目录
      Directory? directory;
      try {
        // 优先使用文档目录（Windows/Android/iOS都可访问）
        directory = await getApplicationDocumentsDirectory();
      } catch (e) {
        // 如果失败，使用临时目录
        directory = await getTemporaryDirectory();
      }

      // 使用时间戳作为文件名
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$timestamp.json';
      final filePath = '${directory.path}/$fileName';

      // 写入文件
      final file = File(filePath);
      await file.writeAsString(jsonString);

      print('数据导出成功: $filePath');
      print('文件名: $fileName');
      return filePath;
    } catch (err) {
      print('导出数据失败: $err');
      return null;
    }
  }

  /// 分享导出的数据文件
  Future<bool> shareExportedData() async {
    try {
      final filePath = await exportData();
      if (filePath == null) return false;

      final result = await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'DeepReview 数据备份',
        text: '这是我的DeepReview学习数据备份文件',
      );

      return result.status == ShareResultStatus.success;
    } catch (err) {
      print('分享数据失败: $err');
      return false;
    }
  }

  /// 从JSON文件导入数据
  Future<bool> importData(String filePath) async {
    try {
      // 读取文件
      final file = File(filePath);
      if (!await file.exists()) {
        print('文件不存在: $filePath');
        return false;
      }

      final jsonString = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonString);

      // 验证数据格式
      if (!data.containsKey('version') ||
          !data.containsKey('words') ||
          !data.containsKey('errors')) {
        print('数据格式不正确');
        return false;
      }

      final prefs = await SharedPreferences.getInstance();

      // 导入API Key（可选）
      if (data['apiKey'] != null && data['apiKey'].toString().isNotEmpty) {
        await prefs.setString('deepseek_api', data['apiKey']);
        print('API Key导入成功');
      }

      // 导入单词
      final List<dynamic> wordsJson = data['words'];
      final words = wordsJson.map((json) => Word.fromJson(json)).toList();
      final jsonWordsData = jsonEncode(words.map((w) => w.toJson()).toList());
      await prefs.setString(_keyWords, jsonWordsData);
      print('单词导入成功，共${words.length}个');

      // 导入错题
      final List<dynamic> errorsJson = data['errors'];
      final errors =
          errorsJson.map((json) => ErrorQuestion.fromJson(json)).toList();
      final jsonErrorsData =
          jsonEncode(errors.map((e) => e.toJson()).toList());
      await prefs.setString(_keyErrors, jsonErrorsData);
      print('错题导入成功，共${errors.length}个');

      return true;
    } catch (err) {
      print('导入数据失败: $err');
      return false;
    }
  }

  /// 获取数据统计信息
  Future<Map<String, dynamic>> getDataStats() async {
    final words = await getWords();
    final errors = await getErrors();

    final errorsBySubject = <String, int>{};
    for (final error in errors) {
      errorsBySubject[error.subject] =
          (errorsBySubject[error.subject] ?? 0) + 1;
    }

    return {
      'totalWords': words.length,
      'totalErrors': errors.length,
      'errorsBySubject': errorsBySubject,
    };
  }
}


