import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

class AdAddLich extends StatelessWidget {
  const AdAddLich({super.key});

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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('TIÊU ĐỀ & MỤC ĐÍCH'),
                    _buildTextField('Ví dụ: Hẹn xem phòng P.101'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildTag('Xem phòng', isSelected: true),
                        const SizedBox(width: 12),
                        _buildTag('Sửa chữa', isSelected: false),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('THỜI GIAN'),
                    Row(
                      children: [
                        Expanded(child: _buildSelectField('23/04/2026', Icons.add)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSelectField('09:30 AM', null)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('NGƯỜI LIÊN HỆ'),
                    _buildTextField('0908 123 456 (Anh Tuấn)'),
                    const SizedBox(height: 24),
                    _buildLabel('ĐỊA ĐIỂM / CƠ SỞ'),
                    _buildDropdownField('Cơ sở Quận 7 - Luxury'),
                    const SizedBox(height: 24),
                    _buildLabel('NHẮC NHỞ'),
                    _buildReminderBox('🔔 Nhắc trước 15 phút'),
                    const SizedBox(height: 24),
                    _buildLabel('GHI CHÚ THÊM'),
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

  // --- AppBar Gradient đúng chuẩn TroSmart ---
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
          const Text('TroSmart', 
            style: TextStyle(color: Color(0xFF2DDCB1), fontWeight: FontWeight.bold, fontSize: 18)),
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
              child: const Text('Chủ trọ', 
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ],
    );
  }

  // --- Header phụ màu tím ---
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
          const Text('Thêm lịch hẹn mới', 
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, 
        style: TextStyle(color: AppTheme.deepPurple, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Text(hint, style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 14)),
    );
  }

  Widget _buildTextArea() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
    );
  }

  Widget _buildTag(String text, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.deepPurple : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? null : Border.all(color: Colors.orange.withOpacity(0.5)),
      ),
      child: Text(text, 
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.orange, 
          fontSize: 12, 
          fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSelectField(String text, IconData? icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.deepPurple.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 14)),
          if (icon != null) Icon(icon, size: 16, color: AppTheme.deepPurple),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 14)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildReminderBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EDF7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: TextStyle(color: AppTheme.deepPurple, fontSize: 13)),
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
      child: const Text('Tạo lịch hẹn', 
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.deepPurple,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Hóa đơn'),
        BottomNavigationBarItem(icon: Icon(Icons.business_outlined), label: 'Phòng'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Tài khoản'),
      ],
    );
  }
}