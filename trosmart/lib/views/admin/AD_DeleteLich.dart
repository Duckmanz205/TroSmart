import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

class AdDeleteLich extends StatefulWidget {
  const AdDeleteLich({super.key});

  @override
  State<AdDeleteLich> createState() => _AdDeleteLichState();
}

class _AdDeleteLichState extends State<AdDeleteLich> {
  bool _sendNotify = true; // Trạng thái Switch gửi thông báo

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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // --- Icon X đỏ xác nhận ---
                  _buildDeleteIllustration(),
                  const SizedBox(height: 16),
                  const Text(
                    'Xác nhận hủy lịch?',
                    style: TextStyle(color: Color(0xFFFF4D4D), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // --- Card Thông tin lịch hẹn ---
                  _buildAppointmentInfoCard(),
                  const SizedBox(height: 24),

                  // --- Form Lý do và Tùy chọn ---
                  _buildCancelForm(),
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Lưu ý: Sau khi xóa, lịch hẹn này sẽ chuyển vào mục "Đã hủy" và không thể khôi phục.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  
                  const SizedBox(height: 40),

                  // --- Nút hành động ---
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- AppBar chuẩn TroSmart ---
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
          const Text('Hủy / Xóa lịch hẹn', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDeleteIllustration() {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(color: Color(0xFFFFF1F0), shape: BoxShape.circle),
      child: const Icon(Icons.close_rounded, color: Color(0xFFFF4D4D), size: 48),
    );
  }

  Widget _buildAppointmentInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('LỊCH HẸN VỚI', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Anh Tuấn - Xem phòng P.101', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Icons.calendar_month_outlined, size: 16, color: AppTheme.deepPurple),
              SizedBox(width: 6),
              Text('09:30 AM | 23/04/2026', style: TextStyle(color: AppTheme.deepPurple, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCancelForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lý do hủy lịch', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Khách báo bận / Dời lịch', style: TextStyle(fontSize: 14)),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFF3F0F8), borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gửi thông báo hủy cho khách', style: TextStyle(fontSize: 13)),
              Switch(
                value: _sendNotify,
                onChanged: (v) => setState(() => _sendNotify = v),
                activeColor: AppTheme.deepPurple,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5252),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            elevation: 0,
          ),
          child: const Text('Xác nhận xóa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            side: const BorderSide(color: AppTheme.deepPurple),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          child: const Text('Quay lại', style: TextStyle(color: AppTheme.deepPurple, fontWeight: FontWeight.bold)),
        ),
      ],
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