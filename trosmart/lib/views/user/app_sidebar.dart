import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:trosmart/models/user/app_pages.dart';

import '../../widgets/user/sidebar_item.dart';

import '../auth/role_selection_screen.dart';

class AppSidebar extends StatelessWidget {
 final String activePage;
  final Function(String) onPageSelected;

  const AppSidebar({
    super.key, 
    required this.activePage, 
    required this.onPageSelected
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _item(LucideIcons.home, AppPages.home),
                _item(LucideIcons.creditCard, AppPages.payment),
                _item(LucideIcons.fileText, AppPages.contract),
                _item(LucideIcons.search, AppPages.searchRoom),
                _item(LucideIcons.alertTriangle, AppPages.incidentReport),
                _item(LucideIcons.messageSquare, AppPages.chat, badge: '3'),
                _item(LucideIcons.bell, AppPages.notifications, hasDot: true),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: Color(0xFFF3F4F6)),
                ),
                _item(LucideIcons.users, AppPages.findRoommate),
                _item(LucideIcons.barChart, AppPages.stats),
                _item(LucideIcons.user, AppPages.profileDetail),
              ],
            ),
          ),
          _buildFooterProfile(context),
        ],
      ),
    );
  }

  // Hàm tạo item nhanh để code sạch hơn
  Widget _item(IconData icon, String title, {String? badge, bool hasDot = false}) {
    return SidebarItem(
      icon: icon,
      title: title,
      badge: badge,
      hasDot: hasDot,
      isActive: activePage == title,
      onTap: () => onPageSelected(title),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF6D28D9),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'TroSmart',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1F2937),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterProfile(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Column(
        children: [
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xFF00D1B2),
              child: Text(
                'T',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            title: Text(
              'Trọ Smart User',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            subtitle: Text(
              'user@trosmart.vn',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
          const SizedBox(height: 16),
          SidebarItem(
            icon: LucideIcons.logOut,
            title: 'Đăng xuất',
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}