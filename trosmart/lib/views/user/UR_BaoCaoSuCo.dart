import 'package:flutter/material.dart';
import '../../widgets/user/issue_reporting_widgets.dart';

class IssueReportingScreen extends StatelessWidget {
  const IssueReportingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            ActionHeader(),
            NewRequestForm(),
            HistoryDivider(),
            IssueHistoryList(),
            SizedBox(height: 40),
            FooterIndicator(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}