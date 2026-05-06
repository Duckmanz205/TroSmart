import 'package:flutter/material.dart';
import 'package:trosmart/views/admin/invoice_detail_screen.dart';
import 'package:trosmart/views/admin/utility_management_view.dart';
import 'shared/app_theme.dart';

void main() {
  runApp(const TroSmartApp());
}

class TroSmartApp extends StatelessWidget {
  const TroSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TroSmart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: UtilityManagementView(),
    );
  }
}