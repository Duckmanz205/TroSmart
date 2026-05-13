import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

class AdGiaHanHopDong extends StatelessWidget {
  const AdGiaHanHopDong({super.key});

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
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('ĐỐI TƯỢNG KÝ KẾT'),
                    _buildDisabledField('Khách thuê: Nguyễn Văn A'),
                    const SizedBox(height: 12),
                    _buildDisabledField('Phòng: Luxury P.402 (Quận 7)'),
                    
                    const SizedBox(height: 24),
                    _buildLabel('THỜI HẠN THUÊ'),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('Ngày bắt đầu', '23/04/2026')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('Thời hạn (Tháng)', '12 Tháng')),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    _buildLabel('CHI PHÍ & TIỀN CỌC'),
                    _buildMainPriceField('5.500.000 đ / tháng'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildInputField('Cọc phòng (1 tháng)', '5.500.000 đ', isRed: true)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildInputField('Cọc thiết bị (nếu có)', '1.000.000 đ', isBold: true)),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    _buildLabel('DỊCH VỤ ĐI KÈM'),
                    _buildServiceInfo('⚡ Điện: 3.500đ/kWh | 💧 Nước: 20k/m3'),
                    const SizedBox(height: 8),
                    _buildServiceInfo('🌐 Wifi: 100k/phòng | 🗑 Rác: 30k/người'),
                    
                    const SizedBox(height: 24),
                    _buildLabel('HỒ SƠ MINH CHỨNG'),
                    Row(
                      children: [
                        Expanded(child: _buildDashedUploadBox('Ảnh CCCD')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDashedUploadBox('Hợp đồng giấy')),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    _buildLabel('ĐIỀU KHOẢN BỔ SUNG'),
                    _buildTextArea('Nhập các nội quy riêng (giờ giấc, nuôi thú cưng...)'),
                    
                    const SizedBox(height: 32),
                    _buildTotalSummary('12.000.000 đ'),
                    const SizedBox(height: 24),
                    _buildNextButton(),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Lập hợp đồng thuê', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Bước 1: Thiết lập thông tin & Tài chính', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
            ],
          ),
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

  Widget _buildDisabledField(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF1A0D2D))),
    );
  }

  Widget _buildInputField(String label, String value, {bool isRed = false, bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Text(value, style: TextStyle(
            fontSize: 13, 
            fontWeight: (isRed || isBold) ? FontWeight.bold : FontWeight.normal,
            color: isRed ? Colors.red : const Color(0xFF1A0D2D)
          )),
        ),
      ],
    );
  }

  Widget _buildMainPriceField(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.deepPurple.withOpacity(0.5)),
      ),
      child: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A0D2D))),
    );
  }

  Widget _buildServiceInfo(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: TextStyle(color: AppTheme.deepPurple, fontSize: 12)),
    );
  }

  Widget _buildDashedUploadBox(String label) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2), style: BorderStyle.solid), // Thay thế dashed bằng solid nhạt nếu chưa cài plugin dashed_container
      ),
      child: Center(child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11))),
    );
  }

  Widget _buildTextArea(String hint) {
    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.deepPurple.withOpacity(0.2)),
      ),
      child: Text(hint, style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 13)),
    );
  }

  Widget _buildTotalSummary(String amount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.deepPurple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TỔNG THU KHI NHẬN PHÒNG:', style: TextStyle(color: AppTheme.deepPurple, fontSize: 12)),
          const SizedBox(height: 4),
          Text(amount, style: TextStyle(color: AppTheme.deepPurple, fontSize: 24, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.deepPurple,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      child: const Text('Tiếp theo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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