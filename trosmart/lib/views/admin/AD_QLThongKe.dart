import 'package:flutter/material.dart';
import '../../widgets/admin/statistics_widgets.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                PageHeader(),
                SizedBox(height: 24),
                ActionButtonsRow(),
                SizedBox(height: 32),
                SectionLabel(label: 'OVERVIEW'),
                SizedBox(height: 16),
                MetricGrid(),
                SizedBox(height: 24),
                RevenueProfitChartCard(),
                SizedBox(height: 24),
                RentalTrendChartCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
