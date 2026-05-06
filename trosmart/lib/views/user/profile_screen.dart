import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Trạng thái cho các Toggles (Switch)
  bool pushNotification = true;
  bool paymentReminder = true;
  bool maintenanceAlert = false;
  bool newMessages = true;
  bool contractReminder = true;
  bool biometricAuth = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            _buildProfileSummary(),
            const SizedBox(height: 32),
            _buildPersonalInfoForm(),
            const Divider(height: 48, color: Color(0xFFF3F4F6), thickness: 1),
            _buildNotificationSettings(),
            const Divider(height: 48, color: Color(0xFFF3F4F6), thickness: 1),
            _buildSecuritySettings(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: const Color(0xFFF3F4F6), height: 1.0),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Color(0xFF374151)),
        onPressed: () {},
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          const Text(
            "User",
            style: TextStyle(color: Color(0xFF111827), fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Text(
              "Khách",
              style: TextStyle(color: Color(0xFF718096), fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSummary() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Hồ Sơ Cá Nhân",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
          ),
        ),
        const SizedBox(height: 28),
        Stack(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFF14B8A6),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 10))],
              ),
              alignment: Alignment.center,
              child: const Text("B", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB), // Gray dot for offline/status
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
        const Text("Bùi Minh Khoa", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
        const SizedBox(height: 4),
        const Text("+84 912 345 678", style: TextStyle(fontSize: 14, color: Color(0xFF718096))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDFA),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF99F6E4)),
          ),
          child: const Text("Người thuê", style: TextStyle(color: Color(0xFF0D9488), fontSize: 12, fontStyle: FontStyle.italic)),
        )
      ],
    );
  }

  Widget _buildPersonalInfoForm() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Thông tin cá nhân", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
            TextButton(
              onPressed: () {},
              child: const Text("Chỉnh sửa", style: TextStyle(fontSize: 12, color: Color(0xFF0D9488))),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField("HỌ VÀ TÊN", "Bùi Minh Khoa"),
        const SizedBox(height: 20),
        _buildTextField("SỐ ĐIỆN THOẠI", "+84 912 345 678"),
        const SizedBox(height: 20),
        _buildTextField("EMAIL", "bui.minhkhoa@gmail.com"),
        const SizedBox(height: 20),
        _buildTextField("SỐ CCCD / CMND", "079 203 012 345", isVerified: true),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB794F4), // Màu tím sáng
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              shadowColor: const Color(0xFFB794F4).withOpacity(0.4),
            ),
            child: const Text("Lưu Thay Đổi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String value, {bool isVerified = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF718096), letterSpacing: 0.5)),
        const SizedBox(height: 6),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937))),
              ),
              if (isVerified)
                const Text("Đã xác thực", style: TextStyle(fontSize: 10, color: Color(0xFF0D9488), fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: const Color(0xFFF0FDFA), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.notifications_none, color: Color(0xFF0D9488), size: 20),
            ),
            const SizedBox(width: 12),
            const Text("Cài Đặt Thông Báo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          ],
        ),
        const SizedBox(height: 24),
        _buildSwitchTile("Thông báo đẩy", "Nhận thông báo trên điện thoại", pushNotification, (val) => setState(() => pushNotification = val)),
        _buildSwitchTile("Nhắc nhở thanh toán", "Thông báo hóa đơn đến hạn", paymentReminder, (val) => setState(() => paymentReminder = val)),
        _buildSwitchTile("Cảnh báo bảo trì", "Lịch bảo trì và sửa chữa", maintenanceAlert, (val) => setState(() => maintenanceAlert = val)),
        _buildSwitchTile("Tin nhắn mới", "Thông báo từ chủ nhà", newMessages, (val) => setState(() => newMessages = val)),
        _buildSwitchTile("Hợp đồng sắp hết hạn", "Nhắc nhở gia hạn hợp đồng", contractReminder, (val) => setState(() => contractReminder = val)),
      ],
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF111827))),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF718096))),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFFB794F4),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE5E7EB),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: const Color(0xFFF0FDFA), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.security, color: Color(0xFF0D9488), size: 20),
            ),
            const SizedBox(width: 12),
            const Text("Bảo Mật", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
          ],
        ),
        const SizedBox(height: 16),
        _buildActionTile("Đổi mật khẩu", Icons.chevron_right, onTap: () {}),
        const SizedBox(height: 12),
        Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Xác thực sinh trắc học", style: TextStyle(fontSize: 14, color: Color(0xFF374151))),
              Switch(
                value: biometricAuth,
                onChanged: (val) => setState(() => biometricAuth = val),
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFFB794F4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF9FAFB),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              elevation: 0,
            ),
            child: const Text("Đăng Xuất", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF6B7280))),
          ),
        ),
        const SizedBox(height: 20), // Tránh đè với BottomNav
      ],
    );
  }

  Widget _buildActionTile(String title, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Color(0xFF374151))),
            Icon(icon, size: 20, color: const Color(0xFF718096)),
          ],
        ),
      ),
    );
  }
}