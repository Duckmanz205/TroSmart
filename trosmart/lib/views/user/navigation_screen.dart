import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:trosmart/models/user/app_pages.dart';
import 'package:trosmart/views/user/notification_screen.dart';
import 'package:trosmart/views/user/stats_screen.dart';
import 'package:trosmart/widgets/common/user_app_bar.dart';
import 'app_sidebar.dart';
import 'payment_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // 1. Quản lý bằng Tên Trang
  String _activePage = AppPages.home;

  // 2. Danh sách các trang hiển thị trong IndexedStack
  // Thứ tự này sẽ tương ứng với số index của IndexedStack
  final List<String> _pageOrder = [
    AppPages.home,          // 0
    AppPages.payment,       // 1
    AppPages.chat,          // 2
    AppPages.contract,      // 3
    AppPages.notifications, // 4
    AppPages.stats,         // 5
    AppPages.profileDetail, // 6
  ];

  // 3. Hàm điều hướng dùng chung
  void _navigateTo(String pageName) {
    setState(() {
      _activePage = pageName;
    });
    if (Navigator.canPop(context)) {
      Navigator.pop(context); // Đóng drawer nếu đang mở
    }
  }

  // Tính toán Index cho BottomNavigationBar
  int _getBottomNavIndex() {
    if (_activePage == AppPages.home) return 0;
    if (_activePage == AppPages.payment) return 1;
    if (_activePage == AppPages.chat) return 2;
    if (_activePage == AppPages.profileDetail) return 3;
    return 0; // Mặc định về 0 nếu trang đó không nằm trong BottomNav
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserAppBar(title: _activePage), // Hiển thị tiêu đề động
      drawer: AppSidebar(
        activePage: _activePage, 
        onPageSelected: _navigateTo,
      ),
      body: IndexedStack(
        index: _pageOrder.indexOf(_activePage), // Tự động tìm số thứ tự dựa trên tên
        children: [
          const Center(child: Text("Trang chủ")),      // 0
          const PaymentDetailsScreen(),                // 1
          const Center(child: Text("Chat")),           // 2
          const Center(child: Text("Hợp đồng")),       // 3
          const NotificationScreen(),                  // 4
          const HistoryStatsScreen(),                  // 5
          const Center(child: Text("Cá nhân")),        // 6
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getBottomNavIndex(),
        onTap: (index) {
          // Ánh xạ từ số bấm ở dưới ra Tên trang tương ứng
          final bottomPages = [AppPages.home, AppPages.payment, AppPages.chat, AppPages.profileDetail];
          _navigateTo(bottomPages[index]);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'TRANG CHỦ'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.creditCard), label: 'THANH TOÁN'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.messageCircle), label: 'CHAT'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'HỒ SƠ'),
        ],
      ),
    );
  }
}