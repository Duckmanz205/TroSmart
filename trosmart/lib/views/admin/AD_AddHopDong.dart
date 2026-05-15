import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

class AdAddHopDong extends StatelessWidget {
  const AdAddHopDong({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgSlate, // Nền xám nhạt đồng bộ dự án
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSubHeader(context),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('BÊN THUÊ & VỊ TRÍ'),
                    _buildDropdownField('Chọn khách thuê *'),
                    const SizedBox(height: 12),
                    _buildInputField(null, 'Chọn phòng (Cơ sở Quận 7 - P.101)'),
                    
                    const SizedBox(height: 24),
                    _buildLabel('THỜI HẠN (THÁNG)'),
                    _buildDurationToggle(),
                    
                    const SizedBox(height: 24),
                    _buildLabel('CHI PHÍ & TIỀN CỌC'),
                    _buildInputField('Giá thuê / tháng (VND)', '3.500.000', isPurple: true),
                    const SizedBox(height: 12),
                    _buildInputField('Tiền cọc giữ chỗ', '3.500.000', isRed: true),
                    
                    const SizedBox(height: 24),
                    _buildLabel('CHỈ SỐ ĐIỆN / NƯỚC ĐẦU KỲ'),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('Số điện (kWh)', '1250')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('Số nước (m3)', '430')),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    _buildLabel('HÌNH ẢNH HỢP ĐỒNG & CCCD'),
                    _buildUploadBox(),
                    
                    const SizedBox(height: 24),
                    _buildLabel('GHI CHÚ / ĐIỀU KHOẢN RIÊNG'),
                    _buildTextArea(),
                    
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- AppBar Gradient TroSmart ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFA161D2), Color(0xFF64417F)]),
        ),
      ),
      leading: const Icon(Icons.menu, color: Colors.white),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.home_work_rounded, color: Color(0xFF2DDCB1), size: 24),
          const SizedBox(width: 8),
          const Text('TroSmart', style: TextStyle(color: Color(0xFF2DDCB1), fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x4C2DDCB1)),
              ),
              child: const Text('Chủ trọ', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSubHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      color: AppTheme.deepPurple,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Text('Tạo hợp đồng mới', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: TextStyle(color: AppTheme.deepPurple, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInputField(String? label, String hint, {bool isPurple = false, bool isRed = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: isPurple ? Border.all(color: AppTheme.deepPurple.withOpacity(0.5)) : Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Text(hint, style: TextStyle(
            fontSize: 14, 
            fontWeight: (isPurple || isRed) ? FontWeight.bold : FontWeight.normal,
            color: isRed ? Colors.red : const Color(0xFF1A0D2D)
          )),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildDurationToggle() {
    return Row(
      children: [
        _toggleItem('6 tháng', isSelected: true),
        const SizedBox(width: 8),
        _toggleItem('12 tháng', isSelected: false),
        const SizedBox(width: 8),
        _toggleItem('Khác', isSelected: false),
      ],
    );
  }

  Widget _toggleItem(String label, {required bool isSelected}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.deepPurple : const Color(0xFFF3F0F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: isSelected ? Colors.white : AppTheme.deepPurple, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildUploadBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.deepPurple.withOpacity(0.1), style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          const Icon(Icons.camera_alt_outlined, color: AppTheme.deepPurple),
          const SizedBox(height: 8),
          const Text('Chụp ảnh / Tải lên', style: TextStyle(color: AppTheme.deepPurple, fontWeight: FontWeight.bold, fontSize: 13)),
          Text('(Mặt trước, mặt sau CCCD và hợp đồng)', style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildTextArea() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.deepPurple,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      child: const Text('Ký & Tạo hợp đồng', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.deepPurple,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Hóa đơn'),
        BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Phòng'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Tài khoản'),
      ],
    );
  }
}