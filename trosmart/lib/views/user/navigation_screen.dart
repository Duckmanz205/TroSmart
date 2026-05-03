import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'stats_screen.dart';
import 'payment_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Chỉ sắp xếp lại các màn hình sẵn có theo thứ tự mới
  final List<Widget> _screens = [
    const HistoryStatsScreen(),      // 0. TRANG CHỦ
    const PaymentDetailsScreen(),    // 1. THANH TOÁN
    const Center(child: Text("Màn hình Chat")),    // 2. CHAT (Tạm thời)
    const Center(child: Text("Màn hình Hồ sơ")),  // 3. HỒ SƠ (Tạm thời)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFB794F4),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home), 
            label: 'TRANG CHỦ',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.creditCard), 
            label: 'THANH TOÁN',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.messageCircle), 
            label: 'CHAT',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.user), 
            label: 'HỒ SƠ',
          ),
        ],
      ),
    );
  }
}