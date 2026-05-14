import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

class AdEditLich extends StatefulWidget {
  const AdEditLich({super.key});

  @override
  State<AdEditLich> createState() => _AdEditLichState();
}

class _AdEditLichState extends State<AdEditLich> {
  bool _sendNotify = true; // Trạng thái của Switch gửi thông báo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgSlate,
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
                    _buildLabel('THÔNG TIN CHUNG'),
                    _buildInputField('Tiêu đề lịch hẹn', 'Hẹn xem phòng P.101', hasBorder: true),
                    
                    const SizedBox(height: 24),
                    _buildLabel('THỜI GIAN MỚI'),
                    Row(
                      children: [
                        Expanded(child: _buildSelectBox('23/04/2026')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSelectBox('09:30 AM')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTimeQuickOptions(),
                    
                    const SizedBox(height: 24),
                    _buildLabel('ĐỐI TÁC & ĐỊA ĐIỂM'),
                    _buildInputField(null, 'Anh Tuấn - 0908 123 456'),
                    const SizedBox(height: 12),
                    _buildInputField(null, 'Cơ sở Quận 7 - Luxury'),
                    
                    const SizedBox(height: 24),
                    _buildLabel('TÙY CHỌN CẬP NHẬT'),
                    _buildNotifySwitch(),
                    
                    const SizedBox(height: 24),
                    _buildLabel('Ghi chú nội bộ', isMuted: true),
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

  // --- AppBar Gradient ---
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
          const Expanded(
            child: Text('Chỉnh sửa lịch hẹn', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Text('ID: #L882', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool isMuted = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, 
        style: TextStyle(
          color: isMuted ? Colors.grey : AppTheme.deepPurple, 
          fontSize: 11, 
          fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInputField(String? label, String value, {bool hasBorder = false}) {
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
            border: hasBorder ? Border.all(color: AppTheme.deepPurple.withOpacity(0.5)) : Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF1A0D2D))),
        ),
      ],
    );
  }

  Widget _buildSelectBox(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.deepPurple.withOpacity(0.2)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _buildTimeQuickOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ['+30 phút', '+1 giờ', 'Dời sang chiều'].map((opt) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: const Color(0xFFF3EDF7), borderRadius: BorderRadius.circular(8)),
          child: Text(opt, style: TextStyle(color: AppTheme.deepPurple, fontSize: 11)),
        );
      }).toList(),
    );
  }

  Widget _buildNotifySwitch() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF3F0F8), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Gửi thông báo thay đổi cho khách', style: TextStyle(fontSize: 13)),
          Switch(
            value: _sendNotify,
            onChanged: (v) => setState(() => _sendNotify = v),
            activeColor: AppTheme.deepPurple,
          )
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
      child: const Text('Lưu cập nhật', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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