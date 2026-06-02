import 'package:flutter/material.dart';
import 'package:trosmart/shared/app_theme.dart';
import 'package:trosmart/views/auth/login_screen.dart';
import '../../services/khach_thue_service.dart';
import '../../models/khach_thue.dart';
import '../../logic/auth/auth_service.dart';

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

  KhachThue? _profile;
  bool _isLoadingProfile = true;
  final KhachThueService _profileService = KhachThueService();
  final AuthService _authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cccdController = TextEditingController();

  int? _maKhach;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      _maKhach = await _authService.getMaKhach();
      if (_maKhach != null) {
        final profile = await _profileService.getCustomerProfile(_maKhach!);
        setState(() {
          _profile = profile;
          _nameController.text = profile.hoTen ?? '';
          _phoneController.text = profile.sdt ?? '';
          _emailController.text = profile.email ?? '';
          _cccdController.text = profile.cccd ?? '';
          _isLoadingProfile = false;
        });
      } else {
        setState(() {
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      debugPrint("Lỗi tải thông tin cá nhân: $e");
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_profile == null) return;
    final updated = KhachThue(
      maKhach: _profile!.maKhach,
      hoTen: _nameController.text.trim(),
      sdt: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      cccd: _cccdController.text.trim(),
      gioiTinh: _profile!.gioiTinh,
      diaChiThuongTru: _profile!.diaChiThuongTru,
      ngaySinh: _profile!.ngaySinh,
      ngayCapCccd: _profile!.ngayCapCccd,
      noiCapCccd: _profile!.noiCapCccd,
      trangThai: _profile!.trangThai,
    );

    try {
      final success = await _profileService.updateCustomerProfile(updated);
      if (success) {
        setState(() {
          _profile = updated;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cập nhật thông tin thành công!", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cập nhật thất bại. Vui lòng kiểm tra lại."), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cccdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProfile) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF14B8A6)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
              child: Text(
                _profile?.hoTen != null && _profile!.hoTen!.isNotEmpty 
                    ? _profile!.hoTen![0].toUpperCase() 
                    : "U", 
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF14B8A6), // Active green
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
        Text(_profile?.hoTen ?? "Khách thuê", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
        const SizedBox(height: 4),
        Text(_profile?.sdt ?? "Chưa bổ sung số điện thoại", style: const TextStyle(fontSize: 14, color: Color(0xFF718096))),
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
            const SizedBox(),
          ],
        ),
        const SizedBox(height: 16),
        _buildEditTextField("HỌ VÀ TÊN", _nameController),
        const SizedBox(height: 20),
        _buildEditTextField("SỐ ĐIỆN THOẠI", _phoneController),
        const SizedBox(height: 20),
        _buildEditTextField("EMAIL", _emailController),
        const SizedBox(height: 20),
        _buildEditTextField("SỐ CCCD / CMND", _cccdController, isVerified: true),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _updateProfile,
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

  Widget _buildEditTextField(String label, TextEditingController controller, {bool isVerified = false}) {
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
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                ),
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
            child: ListTile(
              title: const Center(child: Text('Đăng xuất', style: TextStyle(color: AppTheme.textDark))),
              onTap: () {
                // Luôn nhớ dùng pushAndRemoveUntil cho đăng xuất
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            )
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