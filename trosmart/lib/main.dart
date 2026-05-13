import 'package:flutter/material.dart';
import 'package:trosmart/views/admin/add_invoice_screen.dart';
import 'package:trosmart/views/admin/invoice_detail_screen.dart';
import 'package:trosmart/views/admin/invoice_screen.dart';
import 'package:trosmart/views/admin/select_manager_view.dart';
import 'package:trosmart/views/admin/utility_management_view.dart';
import 'package:trosmart/views/user/navigation_screen.dart';
import 'package:trosmart/views/user/payment_screen.dart';
import 'shared/app_theme.dart';
import 'package:trosmart/views/admin/navigation_screen_admin.dart';

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
      home: const AdminNavigationScreen(),
    );
  }
}

/*
// main xem tra cuu
import 'package:flutter/material.dart';
import 'views/user/room_search_view.dart';

void main() {
  runApp(const TroSmartApp());
}

class TroSmartApp extends StatelessWidget {
  const TroSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoomSearchView(),
    );
  }
}
*/