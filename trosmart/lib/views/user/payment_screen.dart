import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../widgets/user/payment_widgets.dart';

class PaymentDetailsScreen extends StatelessWidget {
  const PaymentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TroSmart", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Color(0xFFB794F4))),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 18, backgroundColor: const Color(0xFFB794F4).withValues(alpha:0.2),
              child: const Icon(LucideIcons.user, size: 20),
            ),
          )
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            BillBanner(),
            SizedBox(height: 32),
            SectionHeader(title: "CHI TIẾT HÓA ĐƠN"),
            SizedBox(height: 12),
            BillDetailList(),
            SizedBox(height: 32),
            SharedCostSection(),
            SizedBox(height: 32),
            SectionHeader(title: "LỊCH SỬ THANH TOÁN"),
            SizedBox(height: 12),
            PaymentHistoryItem(month: "02/2024", amount: "4.180.000đ", date: "15/02/2024"),
            PaymentHistoryItem(month: "01/2024", amount: "4.210.000đ", date: "12/01/2024"),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}