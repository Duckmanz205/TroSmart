import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:trosmart/models/user/app_pages.dart';
import 'package:trosmart/views/user/UR_ThongBao.dart';
import 'package:trosmart/views/user/UR_Chat.dart';
import 'package:trosmart/views/user/UR_BaoCaoSuCo.dart';
import 'package:trosmart/views/user/stats_screen.dart';
import 'package:trosmart/widgets/common/user/user_app_bar.dart';
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
    AppPages.contract,      // 2
    AppPages.searchRoom,    // 3
    AppPages.incidentReport, // 4
    AppPages.chat,          // 5
    AppPages.notifications, // 6
    AppPages.findRoommate,  // 7
    AppPages.stats,         // 8
    AppPages.profileDetail, // 9
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
    return 0;
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
        index: _pageOrder.indexOf(_activePage),
        children: [
          const Center(child: Text("Trang chủ (Dashboard)")), // 0
          const PaymentDetailsScreen(),                      // 1
          const Center(child: Text("Hợp đồng")),              // 2
          const Center(child: Text("Tra cứu phòng trọ")),     // 3
          const UrBaoCaoSuCo(),                              // 4
          const UrChat(),                                    // 5
          const UrThongBao(),                                // 6
          const Center(child: Text("Ở ghép")),                // 7
          const HistoryStatsScreen(),                        // 8
          const Center(child: Text("Cá nhân")),              // 9
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final bottomPages = [AppPages.home, AppPages.payment, AppPages.chat, AppPages.profileDetail];
    final currentIndex = _getBottomNavIndex();

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(bottomPages.length, (index) {
          final page = bottomPages[index];
          final isActive = currentIndex == index;
          
          IconData icon;
          switch (index) {
            case 0: icon = LucideIcons.home; break;
            case 1: icon = LucideIcons.creditCard; break;
            case 2: icon = LucideIcons.messageSquare; break;
            case 3: icon = LucideIcons.user; break;
            default: icon = LucideIcons.home;
          }

          return GestureDetector(
            onTap: () => _navigateTo(page),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFFF5F3FF) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isActive ? const Color(0xFF6D28D9) : const Color(0xFF6B7280),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                if (isActive)
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6D28D9),
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  const SizedBox(height: 4),
              ],
            ),
          );
        }),
      ),
    );
  }
}