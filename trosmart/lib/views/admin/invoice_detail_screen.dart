import 'package:flutter/material.dart';
import '../../shared/app_colors.dart';
import '../../widgets/admin/invoice_detail_widgets.dart';

import '../../models/admin/invoice_model.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final InvoiceModel invoice;
  const InvoiceDetailsScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                InvoiceDetailHeader(invoice: invoice),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      InvoiceSummaryCard(invoice: invoice),
                      const SizedBox(height: 16),
                      InvoiceDetailsCard(invoice: invoice),
                      const SizedBox(height: 16),
                      const BankTransferCard(),
                      SizedBox(height: 24),
                      ActionButtons(),
                      SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
          

        ],
      ),
    );
  }
}
