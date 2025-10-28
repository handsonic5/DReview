import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// API管理类 - 负责 DeepSeek AI API 调用
class ApiManager {
  static final ApiManager _instance = ApiManager._internal();
  factory ApiManager() => _instance;
  ApiManager._internal();

  static const String _keyApi = 'deepseek_api';

  // 保存 API Key
  Future<bool> saveApiKey(String apiKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyApi, apiKey);
      print('API Key保存成功');
      return true;
    } catch (err) {
      print('保存API Key失败: $err');
      return false;
    }
  }

  // 获取 API Key
  Future<String> getApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyApi) ?? '';
    } catch (err) {
      print('获取API Key失败: $err');
      return '';
    }
  }

  // 调用 DeepSeek AI API
  Future<String> callDeepSeek(String question, String context) async {
    final apiKey = await getApiKey();

    if (apiKey.isEmpty) {
      return '错误：未配置API Key，请先在主页点击"API填写"进行配置。';
    }

    try {
      final requestBody = {
        'model': 'deepseek-chat',
        'messages': [
          {
            'role': 'system',
            'content': r'你是一个考研学习助手，请帮助用户理解和掌握知识点。在回答中使用Markdown格式，所有数学公式必须用$符号包裹。例如：梯度 $\nabla f$，偏导数 $\frac{\partial f}{\partial x}$'
          },
          {
            'role': 'user',
            'content': '上下文信息：\n$context\n\n用户问题：\n$question'
          }
        ],
        'temperature': 0.7
      };

      print('发送DeepSeek请求，API Key长度: ${apiKey.length}');

      final response = await http.post(
        Uri.parse('https://api.deepseek.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 60));

      print('DeepSeek响应码: ${response.statusCode}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['choices'] != null && result['choices'].isNotEmpty) {
          return result['choices'][0]['message']['content'] as String;
        } else {
          return '错误：AI返回数据格式异常';
        }
      } else {
        print('响应内容: ${response.body}');
        return '错误：API调用失败 (${response.statusCode})';
      }
    } catch (err) {
      print('调用DeepSeek API失败: $err');
      
      // 更详细的错误处理
      if (err.toString().contains('Failed host lookup')) {
        return '错误：无法连接到服务器，请检查网络连接或稍后重试';
      } else if (err.toString().contains('timeout')) {
        return '错误：请求超时，请检查网络连接后重试';
      } else if (err.toString().contains('SocketException')) {
        return '错误：网络连接异常，请检查网络设置';
      } else {
        return '错误：网络请求失败 - $err';
      }
    }
  }
}


