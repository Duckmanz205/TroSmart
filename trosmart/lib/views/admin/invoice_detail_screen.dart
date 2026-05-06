import 'package:flutter/material.dart';
import 'package:trosmart/widgets/common/admin/custom_bottom_navigation.dart';
import '../../shared/app_colors.dart';
import '../../widgets/admin/invoice_detail_widgets.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  const InvoiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const InvoiceDetailHeader(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: const [
                      InvoiceSummaryCard(),
                      SizedBox(height: 16),
                      InvoiceDetailsCard(),
                      SizedBox(height: 16),
                      BankTransferCard(),
                      SizedBox(height: 24),
                      ActionButtons(),
                      SizedBox(height: 120), // Khoảng trống cho BottomNav
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNav(), 
          ),
        ],
      ),
    );
  }
}