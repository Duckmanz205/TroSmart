import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trosmart/views/admin/AD_LichCongViec.dart';
import 'package:trosmart/views/admin/AD_QLHopDong.dart';
import 'package:trosmart/views/admin/AD_TrangChu.dart';
import 'package:trosmart/views/admin/settings_screen.dart';
// Import models
import '../../models/admin/admin_pages.dart';

// Import views
import 'select_manager_view.dart';
import 'AD_HoaDon.dart';
import 'AD_QLPhong.dart';
import 'AD_QLCoSo.dart';
import 'AD_QLDienNuoc.dart';
import 'AD_SuCo.dart';
import 'AD_QLThongKe.dart';
import 'AD_Chat.dart';

// Import widgets
import '../../widgets/common/admin/custom_app_bar.dart';
import '../../widgets/common/admin/custom_bottom_navigation.dart';
import '../../widgets/common/admin/admin_drawer.dart';

// Import logic
import '../../logic/admin/invoice_controller.dart';

class AdminNavigationScreen extends StatefulWidget {
  const AdminNavigationScreen({super.key});

  @override
  State<AdminNavigationScreen> createState() => _AdminNavigationScreenState();
}

class _AdminNavigationScreenState extends State<AdminNavigationScreen> {
  // 1. Quản lý trạng thái bằng Tên Trang như phía User
  String _activePage = AdminPages.dashboard;

  // 2. Danh sách các trang tương ứng với thứ tự hiển thị trong IndexedStack
  final List<String> _pageOrder = [
    AdminPages.dashboard, // 0
    AdminPages.coSo, // 1
    AdminPages.phong, // 2
    AdminPages.thuThue, // 3
    AdminPages.hopDong, // 4
    AdminPages.dienNuoc, // 5
    AdminPages.suCo, // 6
    AdminPages.lichCongViec, // 7
    AdminPages.baoCao, // 8
    AdminPages.chat, // 9
    AdminPages.caiDat, // 10
    AdminPages.taiKhoan, // 11
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const AdminHomeScreen(), // 0: Dashboard
      const Text('Cơ sở'), // 1: Cơ sở
      const Text('Phòng'), // 2: Phòng
      ChangeNotifierProvider(
        create: (context) => InvoiceController(),
        child: const InvoiceScreen(),
      ), // 3: Thu & Thuê (Hóa đơn)
      const AdQLHopDong(), // 4: Hợp đồng (chờ hoàn thiện)
      const UtilityManagementView(), // 5: Điện nước
      const AD_SuCo(), // 6: Sự cố
      const AdLichCongViec(), // 7: Lịch & Công việc
      const StatisticsScreen(), // 8: Báo cáo (Thống kê)
      const AdChat(), // 9: Chat
      const AdminSettingsScreen(), // 10: Cài đặt (chờ hoàn thiện)
      const Center(
        child: Text('Quản lý Tài khoản'),
      ), // 11: Tài khoản (chờ hoàn thiện)
    ];
  }

  // 3. Hàm điều hướng dùng chung để đóng drawer và chuyển trang
  void _navigateTo(String pageName) {
    setState(() {
      _activePage = pageName;
    });
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // Tính toán Index cho BottomNavigationBar
  int _getBottomNavIndex() {
    if (_activePage == AdminPages.dashboard) return 0;
    if (_activePage == AdminPages.thuThue) return 1;
    if (_activePage == AdminPages.phong) return 2;
    if (_activePage == AdminPages.taiKhoan) return 3;
    return -1; // Trả về -1 để không làm sáng mục nào khi đang xem trang chi tiết từ Drawer
  }

  void _onBottomNavTapped(int index) {
    final bottomPages = [
      AdminPages.dashboard,
      AdminPages.thuThue,
      AdminPages.phong,
      AdminPages.taiKhoan,
    ];
    _navigateTo(bottomPages[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: AdminDrawer(activePage: _activePage, onPageSelected: _navigateTo),
      body: IndexedStack(
        index: _pageOrder.indexOf(_activePage),
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _getBottomNavIndex(),
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
