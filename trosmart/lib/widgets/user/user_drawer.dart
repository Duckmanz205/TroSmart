import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Brand
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 20),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6D4CA6),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Color(0x666D4CA6), blurRadius: 8)],
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "TroSmart",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827), letterSpacing: -0.5),
                ),
              ],
            ),
          ),
          
          // Navigation Links
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _buildMenuItem(icon: Icons.home_outlined, title: "Trang chủ"),
                  _buildMenuItem(icon: Icons.payment, title: "Thanh toán", isActive: true, badgeText: "ACTIVE"),
                  _buildMenuItem(icon: Icons.description_outlined, title: "Hợp đồng"),
                  _buildMenuItem(icon: Icons.search, title: "Tra cứu phòng trọ"),
                  _buildMenuItem(icon: Icons.report_problem_outlined, title: "Báo cáo sự cố"),
                  _buildMenuItem(icon: Icons.chat_bubble_outline, title: "Trò chuyện", badgeCount: 3),
                  _buildMenuItem(icon: Icons.notifications_none, title: "Thông báo", hasDot: true),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: Color(0xFFF3F4F6), thickness: 1),
                  ),
                  _buildMenuItem(icon: Icons.group_outlined, title: "Ở ghép"),
                  _buildMenuItem(icon: Icons.history, title: "Lịch sử và thống kê"),
                  _buildMenuItem(icon: Icons.person_outline, title: "Hồ sơ cá nhân"),
                ],
              ),
            ),
          ),
          
          // Footer: User Info & Logout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(color: Color(0xFF00D1B2), shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Text("T", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Trọ Smart User", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                          Text("user@trosmart.vn", style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {},
                  child: Row(
                    children: const [
                      Icon(Icons.logout, size: 20, color: Color(0xFF6B7280)),
                      SizedBox(width: 8),
                      Text("Đăng xuất", style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool isActive = false,
    String? badgeText,
    int? badgeCount,
    bool hasDot = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0x0D6D4CA6) : Colors.transparent,
        border: isActive ? Border.all(color: const Color(0x336D4CA6)) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? const Color(0x1A6D4CA6) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: isActive ? const Color(0xFF6D4CA6) : const Color(0xFF6B7280)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
            color: isActive ? const Color(0xFF6D4CA6) : const Color(0xFF6B7280),
          ),
        ),
        trailing: _buildTrailing(badgeText, badgeCount, hasDot),
        onTap: () {},
      ),
    );
  }

  Widget? _buildTrailing(String? text, int? count, bool hasDot) {
    if (text != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: const Color(0x1A6D4CA6), borderRadius: BorderRadius.circular(6)),
        child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6D4CA6))),
      );
    }
    if (count != null) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: Color(0xFFF97316), shape: BoxShape.circle),
        child: Text(count.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
      );
    }
    if (hasDot) {
      return Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF14B8A6), shape: BoxShape.circle));
    }
    return null;
  }
}