import 'dart:io';
import 'package:flutter/material.dart';
import 'shared/app_theme.dart';
import 'shared/api_constants.dart';
import 'views/auth/role_selection_screen.dart';
import 'package:trosmart/views/admin/add_invoice_screen.dart';
import 'package:trosmart/views/admin/invoice_detail_screen.dart';
import 'package:trosmart/views/admin/invoice_screen.dart';
import 'package:trosmart/views/admin/select_manager_view.dart';
import 'package:trosmart/views/admin/utility_management_view.dart';
import 'package:trosmart/views/user/navigation_screen.dart';
import 'package:trosmart/views/user/payment_screen.dart';
import 'package:trosmart/views/admin/navigation_screen_admin.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
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
      home: const RoleSelectionScreen(),
    );
  }
}
