import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trosmart/models/user/app_pages.dart';
import 'package:trosmart/views/user/UR_BaoCaoSuCo.dart';
import 'package:trosmart/views/user/UR_DanhSachChat.dart';
import 'package:trosmart/views/user/UR_OGhep.dart';
import 'package:trosmart/views/user/UR_ThongBao.dart';
import 'package:trosmart/views/user/UR_TrangChu.dart';
import 'package:trosmart/views/user/UR_Frofile.dart';
import 'package:trosmart/views/user/UR_TimKiemPhong.dart';
import 'package:trosmart/views/user/UR_ThongKe.dart';
import 'package:trosmart/views/user/UR_HopDong.dart'; // 🌟 1. IMPORT FILE CHINH CỦA ÔNG
import 'package:trosmart/widgets/common/user/user_app_bar.dart';
import 'app_sidebar.dart';
import 'UR_ThanhToan.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  String _activePage = AppPages.home;
  int _dynamicMaHopDong = 0; 
  bool _isLoadingContract = true;
  int _currentMaKhach = 0; 

  final List<String> _pageOrder = [
    AppPages.home, AppPages.payment, AppPages.chat, AppPages.contract,
    AppPages.searchroom, AppPages.reportIssue, AppPages.notifications,
    AppPages.accommodationShare, AppPages.stats, AppPages.profileDetail,
  ];

  @override
  void initState() {
    super.initState();
    _fetchActiveContract();
  }

  Future<void> _fetchActiveContract() async {
    try {
      try {
        final prefs = await SharedPreferences.getInstance();
        final saved = prefs.getInt('maKhach');
        if (saved != null && saved > 0) {
          _currentMaKhach = saved;
        } else {
          _currentMaKhach = 1; 
        }
      } catch (e) {
        _currentMaKhach = 1;
      }

      final response = await http.get(Uri.parse('http://10.0.2.2:5137/api/HopDong'));

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        List<dynamic> contracts = [];
        if (decoded is List) {
          contracts = decoded;
        } else if (decoded is Map) {
          if (decoded.containsKey('data') && decoded['data'] is List) {
            contracts = decoded['data'];
          } else if (decoded.containsKey('value') && decoded['value'] is List) {
            contracts = decoded['value'];
          } else {
            contracts = [decoded];
          }
        }

        dynamic userContract;
        for (var hd in contracts) {
          if (hd == null || hd is! Map) continue;
          var dynamicMaKhach = hd['MaKhach'] ?? hd['maKhach'] ?? hd['MAKHACH'] ?? hd['ma_khach'];

          if (dynamicMaKhach != null && dynamicMaKhach.toString() == _currentMaKhach.toString()) {
            userContract = hd;
            break;
          }
        }

        if (userContract != null) {
          setState(() {
            var rawMaHopDong = userContract['MaHopDong'] ?? userContract['maHopDong'] ?? 0;
            _dynamicMaHopDong = int.tryParse(rawMaHopDong.toString()) ?? 0;
            _isLoadingContract = false;
          });
          return;
        }
      }
      setState(() => _isLoadingContract = false);
    } catch (e) {
      setState(() => _isLoadingContract = false);
      debugPrint('Lỗi nạp hợp đồng động: $e');
    }
  }

  void _navigateTo(String pageName) {
    setState(() { _activePage = pageName; });
    if (Navigator.canPop(context)) { Navigator.pop(context); }
  }

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
      appBar: UserAppBar(), 
      drawer: AppSidebar(activePage: _activePage, onPageSelected: _navigateTo),
      body: IndexedStack(
        index: _pageOrder.indexOf(_activePage), 
        children: [
          const UserHomeScreen(),                                                       // 0
          const PaymentDetailsScreen(),                                                 // 1
          const UrDanhSachChat(),                                                       // 2
          
          // 🌟 CHẠY FLOW CHUẨN: Đổ thẳng vào trang chi tiết hợp đồng xem trước của ông
          _isLoadingContract
              ? const Center(child: CircularProgressIndicator(color: Colors.purple))
              : _dynamicMaHopDong == 0
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Tài khoản của ông hiện chưa có hợp đồng thuê phòng nào được tạo nháp!",
                          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : UrHopDong(maHopDong: _dynamicMaHopDong),                            // 3
          
          const RoomSearchView(),                                                       // 4
          const IssueReportingScreen(),                                                 // 5
          UrThongBao(onNavigateToPayment: () => _navigateTo(AppPages.payment)),         // 6
          const UrOGhep(),                                                              // 7
          const HistoryStatsScreen(),                                                   // 8
          const UserProfileScreen(),                                                    // 9
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getBottomNavIndex(),
        onTap: (index) {
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