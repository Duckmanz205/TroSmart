import 'package:flutter/material.dart';
import '../../widgets/user/payment_widgets.dart';
class PaymentDetailsScreen extends StatelessWidget {
  const PaymentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            BillBanner(),
            SizedBox(height: 32),
            SectionHeader(title: "CHI TIẾT HÓA ĐƠN"),
            BillDetailList(),
            SizedBox(height: 32),
            SharedCostSection(),
            SizedBox(height: 32),
            SectionHeader(title: "LỊCH SỬ THANH TOÁN"),
            PaymentHistoryItem(month: "02/2024", amount: "4.180.000đ", date: "15/02/2024"),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}