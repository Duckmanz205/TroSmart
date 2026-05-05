import 'package:flutter/material.dart';
import 'shared/app_theme.dart';
// import 'views/user/navigation_screen.dart'; // ← Trang gốc, bỏ comment khi xong preview

// Import 6 màn hình đã refactor
import 'views/admin/AD_Chat.dart';
import 'views/admin/AD_ChiTietChat.dart';
import 'views/admin/AD_SuCo.dart';
import 'views/user/UR_BaoCaoSuCo.dart';
import 'views/user/UR_Chat.dart';
import 'views/user/UR_ThongBao.dart';

void main() {
  runApp(const TroSmartApp());
}

class TroSmartApp extends StatelessWidget {
  const TroSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TroSmart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const _ScreenPreviewLauncher(), // ← Tạm thời dùng preview
      // home: const MainNavigationScreen(), // ← Khôi phục khi xong
    );
  }
}

/// Trang preview tạm – hiển thị danh sách 6 màn hình để kiểm tra.
class _ScreenPreviewLauncher extends StatelessWidget {
  const _ScreenPreviewLauncher();

  @override
  Widget build(BuildContext context) {
    final screens = <_ScreenItem>[
      _ScreenItem(
        title: 'AD_Chat',
        subtitle: 'Admin – Danh sách tin nhắn',
        icon: Icons.chat_outlined,
        color: AppTheme.deepPurple,
        builder: () => const AdChat(),
      ),
      _ScreenItem(
        title: 'AD_ChiTietChat',
        subtitle: 'Admin – Chi tiết hội thoại',
        icon: Icons.chat_bubble_outline,
        color: AppTheme.deepPurple,
        builder: () => const AdChiTietChat(),
      ),
      _ScreenItem(
        title: 'AD_SuCo',
        subtitle: 'Admin – Quản lý sự cố',
        icon: Icons.report_outlined,
        color: AppTheme.statusOrange,
        builder: () => const AdSuCo(),
      ),
      _ScreenItem(
        title: 'UR_BaoCaoSuCo',
        subtitle: 'User – Báo cáo sự cố',
        icon: Icons.warning_amber_outlined,
        color: AppTheme.statusRed,
        builder: () => const UrBaoCaoSuCo(),
      ),
      _ScreenItem(
        title: 'UR_Chat',
        subtitle: 'User – Trò chuyện AI',
        icon: Icons.smart_toy_outlined,
        color: const Color(0xFF8B5CF6),
        builder: () => const UrChat(),
      ),
      _ScreenItem(
        title: 'UR_ThongBao',
        subtitle: 'User – Thông báo',
        icon: Icons.notifications_outlined,
        color: AppTheme.accentTeal,
        builder: () => const UrThongBao(),
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.bgSlate,
      appBar: AppBar(
        title: const Text('🔍 Preview – Màn hình đã refactor'),
        centerTitle: true,
        backgroundColor: AppTheme.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: screens.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = screens[index];
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: item.color.withValues(alpha: 0.20)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              leading: Container(
                width: 48,
                height: 48,
                decoration: ShapeDecoration(
                  color: item.color.withValues(alpha: 0.10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Icon(item.icon, color: item.color),
              ),
              title: Text(
                item.title,
                style: AppTheme.titleMd.copyWith(color: item.color),
              ),
              subtitle: Text(item.subtitle, style: AppTheme.bodySm),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: item.color,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item.builder()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ScreenItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget Function() builder;

  const _ScreenItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.builder,
  });
}
