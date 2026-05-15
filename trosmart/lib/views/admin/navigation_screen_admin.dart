import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import các View
import 'package:trosmart/views/admin/AD_HoaDon.dart';
import 'package:trosmart/views/admin/select_manager_view.dart';
// Import Widgets chung
import 'package:trosmart/widgets/common/admin/custom_app_bar.dart';
import 'package:trosmart/widgets/common/admin/custom_bottom_navigation.dart';

import 'package:trosmart/logic/admin/invoice_controller.dart'; 

class AdminNavigationScreen extends StatefulWidget {
  const AdminNavigationScreen({super.key});

  @override
  State<AdminNavigationScreen> createState() => _AdminNavigationScreenState();
}

class _AdminNavigationScreenState extends State<AdminNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const SelectManagerView(),
      
      ChangeNotifierProvider(
        create: (context) => InvoiceController(),
        child: const InvoiceScreen(),
      ),       
      const Text('Phòng'),
      const Text('Tài khoản'),
    ];
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Thêm const nếu CustomAppBar hỗ trợ
      drawer: const Drawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}