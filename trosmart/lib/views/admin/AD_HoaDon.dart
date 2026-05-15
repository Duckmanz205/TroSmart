import 'package:flutter/material.dart';
import '../../widgets/common/admin/custom_app_bar.dart'; 
import '../../widgets/admin/invoice_widgets.dart';
import '../../widgets/common/admin/custom_bottom_navigation.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
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
    );
  }
}
