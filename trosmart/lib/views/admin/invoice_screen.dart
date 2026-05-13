import 'package:flutter/material.dart';

import '../../widgets/admin/invoice_widgets.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          SizedBox(height: 100),
        ],
      ),
    );
  }
}