import 'package:flutter/material.dart';
import '../../shared/app_colors.dart';
import '../../widgets/admin/invoice_header.dart';
import '../../widgets/admin/billing_info_card.dart';
import '../../widgets/admin/invoice_summary_header.dart';

class AddInvoiceScreen extends StatelessWidget {
  const AddInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          const InvoiceHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text('Lập hóa đơn tháng', 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.adminDarkPurple)),
                const Text('Tháng 04/2026 - Cơ sở Quận 7', 
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 32),
                
                const Text('ĐỐI TƯỢNG THANH TOÁN', 
                  style: TextStyle(color: AppColors.adminDarkPurple, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Phòng P.402 - Nguyễn Văn A', 
                  style: TextStyle(fontSize: 14, color: AppColors.textDark)),
                
                const SizedBox(height: 24),
                const BillingInfoCard(title: 'CHỈ SỐ ĐIỆN (⚡ 3.500đ/kWh)', oldVal: '1250', newVal: '1342'),
                const BillingInfoCard(title: 'CHỈ SỐ NƯỚC (💧 20.000đ/m3)', oldVal: '430', newVal: '438'),
                
                const SizedBox(height: 24),
                const Text('TIỀN PHÒNG & DỊCH VỤ CỐ ĐỊNH', 
                  style: TextStyle(color: AppColors.adminDarkPurple, fontSize: 12, fontWeight: FontWeight.bold)),
                const Text('Phòng: 4.500.000 | Wifi: 100.000', 
                  style: TextStyle(color: Colors.grey, fontSize: 13)),
                
                const SizedBox(height: 40),
                const InvoiceSummaryHeader(amount: '4.982.000 đ', isEntry: true),
                
                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.adminHeaderGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text('Lưu & Xuất hóa đơn', 
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}