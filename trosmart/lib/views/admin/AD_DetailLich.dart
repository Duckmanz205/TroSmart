import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

class AdDetailLich extends StatelessWidget {
  const AdDetailLich({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Card 1: Thông tin khách hàng ---
                  _buildCustomerCard(),
                  const SizedBox(height: 16),

                  // --- Card 2: Chi tiết mục đích, thời gian, địa điểm ---
                  _buildMainDetailCard(),
                  const SizedBox(height: 24),

                  // --- Phần Ghi chú ---
                  _buildLabel('GHI CHÚ CỦA BẠN'),
                  _buildNoteBox(),
                  
                  const SizedBox(height: 32),

                  // --- Nút hành động ---
                  _buildActionButtons(context),
                  const SizedBox(height: 32),
                ],
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
            child: Text('Chi tiết lịch hẹn', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
            child: const Text('● SẮP DIỄN RA', style: TextStyle(color: Color(0xFF7DFFB3), fontSize: 9, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildCustomerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.deepPurple.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFF3F0F8),
            child: Text('AT', style: TextStyle(color: AppTheme.deepPurple, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Anh Tuấn (Khách xem phòng)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('0908 123 456', style: AppTheme.bodySm),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: AppTheme.deepPurple, shape: BoxShape.circle),
            child: const Icon(Icons.close, color: Colors.white, size: 16),
          )
        ],
      ),
    );
  }

  Widget _buildMainDetailCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemDetail('MỤC ĐÍCH', 'Hẹn xem phòng P.101 & Cọc giữ chỗ'),
          const Divider(height: 32),
          _buildItemDetail('THỜI GIAN', 'Thứ Năm, 23 Tháng 4, 2026'),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('09:30 AM', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.deepPurple)),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF3F0F8), borderRadius: BorderRadius.circular(20)),
                child: const Text('Còn 2 giờ 15 phút', style: TextStyle(color: AppTheme.deepPurple, fontSize: 10)),
              )
            ],
          ),
          const Divider(height: 32),
          _buildItemDetail('ĐỊA ĐIỂM CƠ SỞ', 'Cơ sở Quận 7 - Luxury'),
          Text('123 Nguyễn Văn Linh, P. Tân Phong', style: AppTheme.bodySm),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.location_on, size: 14, color: AppTheme.deepPurple),
            label: const Text('Chỉ đường', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.deepPurple,
              side: const BorderSide(color: AppTheme.deepPurple),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text, style: TextStyle(color: AppTheme.deepPurple, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildNoteBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.deepPurple.withOpacity(0.1), style: BorderStyle.solid),
      ),
      child: Text(
        'Khách đi cùng bạn thân, cần phòng thoáng...',
        style: AppTheme.bodyMd.copyWith(fontStyle: FontStyle.italic, color: Colors.grey),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.deepPurple,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          child: const Text('Hoàn thành lịch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 56),
                  side: const BorderSide(color: AppTheme.deepPurple),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Chỉnh sửa', style: TextStyle(color: AppTheme.deepPurple, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 56),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Hủy hẹn', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
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