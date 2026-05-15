import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../shared/app_colors.dart';
import '../../widgets/user/stats_widgets.dart';

class HistoryStatsScreen extends StatelessWidget {
  const HistoryStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: "TỔNG CHI 6 THÁNG",
                    value: "25.460.000đ",
                    dotColor: AppColors.accentTeal,
                    status: "Đã thanh toán",
                    valueColor: AppColors.primaryPurple,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    title: "TRUNG BÌNH/THÁNG",
                    value: "4.243.000đ",
                    dotColor: AppColors.statusOrange,
                    status: "Ổn định",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const ExpenditureChartBox(),
            const SizedBox(height: 24),
            const SavingTipCard(),
            const SizedBox(height: 24),
            const RecentActivityHeader(),
            const TransactionItem(
              title: "Hóa đơn Điện T2",
              subtitle: "15/02/2024 • 14:30",
              amount: "-540.000đ",
              icon: LucideIcons.zap,
              iconColor: AppColors.statusOrange,
            ),
            const TransactionItem(
              title: "Hóa đơn Nước T2",
              subtitle: "15/02/2024 • 14:30",
              amount: "-85.000đ",
              icon: LucideIcons.droplet,
              iconColor: AppColors.accentTeal,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}