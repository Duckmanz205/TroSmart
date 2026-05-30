import 'package:flutter/material.dart';
import '../../widgets/user/issue_reporting_widgets.dart';

class IssueReportingScreen extends StatefulWidget {
  const IssueReportingScreen({super.key});

  @override
  State<IssueReportingScreen> createState() => _IssueReportingScreenState();
}

class _IssueReportingScreenState extends State<IssueReportingScreen> {
  Key _historyKey = UniqueKey();

  void _refreshHistory() {
    setState(() {
      _historyKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ActionHeader(),
            NewRequestForm(onSubmitSuccess: _refreshHistory),
            const HistoryDivider(),
            IssueHistoryList(key: _historyKey),
            const SizedBox(height: 40),
            const FooterIndicator(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}