import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/data_manager.dart';

/// 数据管理页面 - 数据导入导出
class DataManagementPage extends StatefulWidget {
  const DataManagementPage({super.key});

  @override
  State<DataManagementPage> createState() => _DataManagementPageState();
}

class _DataManagementPageState extends State<DataManagementPage> {
  final DataManager _dataManager = DataManager();
  Map<String, dynamic> _stats = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await _dataManager.getDataStats();
    setState(() {
      _stats = stats;
    });
  }

  Future<void> _exportData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final filePath = await _dataManager.exportData();
      if (!mounted) return;

      if (filePath != null) {
        // 显示带有文件路径的对话框
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('导出成功'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('数据已成功导出！'),
                const SizedBox(height: 12),
                const Text(
                  '文件位置：',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SelectableText(
                    filePath,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '💡 提示：可以通过文件管理器找到该文件，或使用下方的分享功能发送到其他设备。',
                  style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('数据导出失败')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导出失败：$e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _shareData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _dataManager.shareExportedData();
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请选择分享方式')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('分享失败')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('分享失败：$e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _importData() async {
    try {
      // 选择文件
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _isLoading = true;
        });

        final filePath = result.files.single.path!;
        final success = await _dataManager.importData(filePath);

        if (!mounted) return;

        if (success) {
          // 重新加载统计信息
          await _loadStats();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('数据导入成功！')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('数据导入失败，请检查文件格式')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导入失败：$e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('数据管理'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
        shadowColor: Colors.black12,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 数据统计卡片
                  _buildStatsCard(),
                  const SizedBox(height: 20),

                  // 导出数据按钮
                  _buildActionCard(
                    icon: Icons.upload_file,
                    title: '导出数据到本地',
                    description: '保存到文档目录，文件名为时间戳',
                    color: const Color(0xFF4CAF50),
                    onTap: _exportData,
                  ),
                  const SizedBox(height: 16),

                  // 分享数据按钮
                  _buildActionCard(
                    icon: Icons.share,
                    title: '分享数据文件',
                    description: '导出并通过系统分享功能发送到其他应用',
                    color: const Color(0xFF9C27B0),
                    onTap: _shareData,
                  ),
                  const SizedBox(height: 16),

                  // 导入数据按钮
                  _buildActionCard(
                    icon: Icons.download,
                    title: '导入数据',
                    description: '从JSON文件导入数据（会覆盖当前数据）',
                    color: const Color(0xFF2196F3),
                    onTap: _importData,
                  ),
                  const SizedBox(height: 20),

                  // 使用说明
                  _buildInstructionsCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsCard() {
    final totalWords = _stats['totalWords'] ?? 0;
    final totalErrors = _stats['totalErrors'] ?? 0;
    final errorsBySubject =
        _stats['errorsBySubject'] as Map<String, dynamic>? ?? {};

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics, color: Color(0xFF9C27B0)),
              SizedBox(width: 8),
              Text(
                '当前数据统计',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('单词总数', '$totalWords', Icons.book),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem('错题总数', '$totalErrors', Icons.error),
              ),
            ],
          ),
          if (errorsBySubject.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              '错题分布：',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: errorsBySubject.entries
                  .map((entry) => Chip(
                        label: Text('${entry.key}: ${entry.value}'),
                        backgroundColor: const Color(0xFFE3F2FD),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF2196F3), size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2196F3),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF2196F3)),
              SizedBox(width: 8),
              Text(
                '使用说明',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInstructionStep(
            '1',
            '电脑端导出',
            '在Windows应用上点击"导出数据"，选择分享方式（如微信、邮箱）发送到手机',
          ),
          const SizedBox(height: 12),
          _buildInstructionStep(
            '2',
            '文件传输',
            '通过微信、QQ、邮箱、云盘等方式将JSON文件传输到目标设备',
          ),
          const SizedBox(height: 12),
          _buildInstructionStep(
            '3',
            '手机端导入',
            '在手机应用上点击"导入数据"，选择接收到的JSON文件即可',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber, color: Color(0xFFFF9800), size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '注意：导入数据会覆盖当前所有数据，请谨慎操作！建议先导出备份当前数据。',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFE65100),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


