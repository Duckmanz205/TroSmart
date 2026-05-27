import 'package:flutter/material.dart';
import 'package:trosmart/logic/auth/auth_service.dart';
import 'package:trosmart/views/user/navigation_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isAgreeTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> _handleRegister() async {
    if (!isAgreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đồng ý với Điều khoản dịch vụ!')),
      );
      return;
    }

    final hoTen = _nameController.text.trim();
    final sDT = _phoneController.text.trim();
    // _emailController được dùng làm TenDangNhap (username)
    final tenDangNhap = _emailController.text.trim();
    final matKhau = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (hoTen.isEmpty || tenDangNhap.isEmpty || matKhau.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin!')),
      );
      return;
    }

    if (matKhau != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu nhập lại không khớp!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // register() tự động gọi login() sau khi thành công
      await _authService.register(
        tenDangNhap,
        matKhau,
        hoTen,
        sDT.isEmpty ? null : sDT,
      );

      if (!mounted) return;
      // VaiTro luôn là KhachThue → điến home user
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nền tảng phía sau theo thiết kế (Gradient tối)
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF022C22), Color(0xFF020617)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 50,
                          offset: Offset(0, 25),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputField(
                          label: "HỌ VÀ TÊN",
                          icon: Icons.person_outline,
                          hint: "Nguyễn Văn A",
                          controller: _nameController,
                        ),
                        const SizedBox(height: 20),
                        
                        _buildInputField(
                          label: "SỐ ĐIỆN THOẠI",
                          icon: Icons.phone_android,
                          hint: "0123 456 789",
                          keyboardType: TextInputType.phone,
                          controller: _phoneController,
                        ),
                        const SizedBox(height: 20),
                        
                        _buildInputField(
                          label: "TÊN ĐĂNG NHẬP",
                          icon: Icons.person_outline,
                          hint: "Tên để đăng nhập vào hệ thống",
                          keyboardType: TextInputType.text,
                          controller: _emailController,
                        ),
                        const SizedBox(height: 20),
                        
                        _buildInputField(
                          label: "MẬT KHẨU",
                          icon: Icons.lock_outline,
                          hint: "••••••••",
                          isPassword: true,
                          obscureText: _obscurePassword,
                          onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                          subText: "Ít nhất 8 ký tự, bao gồm chữ và số",
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 20),
                        
                        _buildInputField(
                          label: "NHẬP LẠI MẬT KHẨU",
                          icon: Icons.lock_outline,
                          hint: "••••••••",
                          isPassword: true,
                          obscureText: _obscureConfirmPassword,
                          onToggleVisibility: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          controller: _confirmPasswordController,
                        ),
                        const SizedBox(height: 24),
                        
                        // Checkbox Điều khoản
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: isAgreeTerms,
                                onChanged: (val) => setState(() => isAgreeTerms = val ?? false),
                                activeColor: const Color(0xFF022C22),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), height: 1.5),
                                  children: [
                                    TextSpan(text: "Tôi đồng ý với Điều khoản dịch vụ và "),
                                    TextSpan(
                                      text: "Chính sách bảo mật",
                                      style: TextStyle(color: Color(0xFF0D0F11), fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        // Nút Đăng ký
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A3092),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 5,
                              shadowColor: const Color(0xFF988BE9).withOpacity(0.5),
                            ),
                            onPressed: _isLoading ? null : _handleRegister,
                            child: _isLoading 
                                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text(
                                    "Đăng ký",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Chuyển sang Đăng nhập
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Đã có tài khoản? ", style: TextStyle(color: Color(0xFF595959), fontSize: 14)),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                "Đăng nhập",
                                style: TextStyle(color: Color(0xFF6A3092), fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            "Tạo tài khoản mới",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    String? subText,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF595959)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF595959), letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade100, // Thay thế nền trong suốt để dễ nhìn trên thẻ trắng
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(color: Color(0xFF0D0F11), fontSize: 15),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
                      onPressed: onToggleVisibility,
                    )
                  : null,
            ),
          ),
        ),
        if (subText != null) ...[
          const SizedBox(height: 6),
          Text(subText, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
        ]
      ],
    );
  }
}