import 'dart:io';
import 'package:flutter/material.dart';
import 'shared/app_theme.dart';
import 'shared/api_constants.dart';
import 'views/auth/role_selection_screen.dart';

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
