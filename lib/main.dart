import 'package:flutter/material.dart';
import 'services/data_manager.dart';
import 'pages/index_page.dart';
import 'pages/api_config_page.dart';
import 'pages/word_list_page.dart';
import 'pages/word_detail_page.dart';
import 'pages/error_main_page.dart';
import 'pages/math_category_page.dart';
import 'pages/major_category_page.dart';
import 'pages/politics_category_page.dart';
import 'pages/error_list_page.dart';
import 'pages/error_detail_page.dart';
import 'pages/data_management_page.dart';

void main() async {
  // 确保 Flutter 绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化数据管理器
  await DataManager().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DR习题助手',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
        // 优化 AppBar 样式
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      // 主页
      home: const IndexPage(),
      // 路由配置
      routes: {
        '/api-config': (context) => const ApiConfigPage(),
        '/word-list': (context) => const WordListPage(),
        '/word-detail': (context) => const WordDetailPage(),
        '/error-main': (context) => const ErrorMainPage(),
        '/math-category': (context) => const MathCategoryPage(),
        '/major-category': (context) => const MajorCategoryPage(),
        '/politics-category': (context) => const PoliticsCategoryPage(),
        '/error-list': (context) => const ErrorListPage(),
        '/error-detail': (context) => const ErrorDetailPage(),
        '/data-management': (context) => const DataManagementPage(),
      },
    );
  }
}
