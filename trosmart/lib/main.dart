import 'package:flutter/material.dart';
import 'package:trosmart/views/auth/login_screen.dart';
import 'shared/app_theme.dart';
import 'views/user/navigation_screen.dart';

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
      home: const LoginScreen(),
    );
  }
}