import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../widgets/user/stats_widgets.dart';

class HistoryStatsScreen extends StatelessWidget {
  const HistoryStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha:0.1)),
              ),
              child: const Icon(LucideIcons.history, color: Color(0xFFB794F4), size: 20),
            ),
            const SizedBox(width: 12),
            const Text("Lịch sử & Thống kê", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: "TỔNG CHI 6 THÁNG", value: "25.460.000đ",
                    dotColor: Color(0xFF4FD1C5), status: "Đã thanh toán", valueColor: Color(0xFFB794F4),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(title: "TRUNG BÌNH/THÁNG", value: "4.243.000đ", dotColor: Color(0xFFF6AD55), status: "Ổn định"),
                ),
              ],
            ),
            SizedBox(height: 24),
            ExpenditureChartBox(),
            SizedBox(height: 24),
            SavingTipCard(),
            SizedBox(height: 24),
            RecentActivityHeader(),
            TransactionItem(
              title: "Hóa đơn Điện T2", subtitle: "15/02/2024 • 14:30", amount: "-540.000đ",
              icon: LucideIcons.zap, iconColor: Color(0xFFF6AD55),
            ),
            TransactionItem(
              title: "Hóa đơn Nước T2", subtitle: "15/02/2024 • 14:30", amount: "-85.000đ",
              icon: LucideIcons.droplet, iconColor: Color(0xFF4FD1C5),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}