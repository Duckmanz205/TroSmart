import 'package:flutter/material.dart';
import '../../widgets/common/admin/custom_app_bar.dart'; 
import '../../widgets/common/admin/custom_bottom_navigation.dart';
import '../../widgets/admin/invoice_widgets.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      // Tái sử dụng CustomAppBar tại đây
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60), // AppBar mặc định của Flutter thường cao 56-60
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SectionTitleAction(),
            SizedBox(height: 24),
            SummaryGrid(),
            SizedBox(height: 24),
            SearchAndFilter(),
            SizedBox(height: 24),
            InvoiceList(),
            SizedBox(height: 100), // Khoảng trống cho BottomNav
          ],
        ),
      ),
      // Nếu bạn đã chuyển BottomNav vào thư mục layout, hãy nhớ trỏ đúng import
      bottomNavigationBar: const CustomBottomNav(), 
    );
  }
}