import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

class UrLichSuXemPhong extends StatelessWidget {
  const UrLichSuXemPhong({super.key});

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTabToggle(),
                  const SizedBox(height: 20),
                  _buildNotificationBanner(),
                  const SizedBox(height: 20),
                  
                  // Lịch hẹn 1: Chờ xác nhận
                  _buildAppointmentCard(
                    status: 'Chờ xác nhận',
                    statusColor: const Color(0xFF1976D2),
                    statusBg: const Color(0xFFE3F2FD),
                    date: 'THỨ 5, 23 THÁNG 04',
                    title: 'Luxury Studio P.402',
                    time: '14:30 - 15:00',
                    guide: 'Anh Quân (Quản lý)',
                    contact: 'Liên hệ: 090xxxx136',
                    hasCallButton: true,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Lịch hẹn 2: Đã xác nhận
                  _buildAppointmentCard(
                    status: 'Đã xác nhận',
                    statusColor: const Color(0xFF2E7D32),
                    statusBg: const Color(0xFFE8F5E9),
                    date: 'THỨ 7, 25 THÁNG 04',
                    title: 'Phòng Gác - HUIT House',
                    time: '09:00 - 09:30',
                    address: 'Địa chỉ: 140 Lê Trọng Tấn, Tân Phú',
                    hasCancelButton: true,
                  ),
                  
                  const SizedBox(height: 32),
                  const Text(
                    'LỊCH HẸN TRƯỚC ĐÓ',
                    style: TextStyle(color: Color(0xFFADB5BD), fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  
                  // Lịch hẹn cũ: Đã hoàn thành
                  _buildPastAppointmentCard(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

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
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0x4C2DDCB1))),
              child: const Text('Khách', style: TextStyle(color: Colors.white, fontSize: 11)),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text('Lịch hẹn của tôi', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 32, top: 4),
            child: Text('Theo dõi và quản lý các lượt xem phòng', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildTabToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: AppTheme.deepPurple, borderRadius: BorderRadius.circular(25)),
              child: const Center(child: Text('Sắp tới (2)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
            ),
          ),
          const Expanded(child: Center(child: Text('Đã xem', style: TextStyle(color: Colors.grey, fontSize: 12)))),
          const Expanded(child: Center(child: Text('Đã hủy', style: TextStyle(color: Colors.grey, fontSize: 12)))),
        ],
      ),
    );
  }

  Widget _buildNotificationBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.deepPurple.withOpacity(0.2), style: BorderStyle.none),
      ),
      child: const Row(
        children: [
          Text('🔔', style: TextStyle(fontSize: 16)),
          SizedBox(width: 8),
          Text('Bạn có 1 lịch hẹn lúc 14:30 chiều nay!', style: TextStyle(color: AppTheme.deepPurple, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard({
    required String status, required Color statusColor, required Color statusBg,
    required String date, required String title, required String time,
    String? guide, String? contact, String? address,
    bool hasCallButton = false, bool hasCancelButton = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.bgGray200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(color: Color(0xFF6C757D), fontSize: 11)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(time, style: const TextStyle(color: AppTheme.deepPurple, fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(height: 24),
          if (guide != null) ...[
            Row(
              children: [
                const CircleAvatar(radius: 20, backgroundColor: Color(0xFFF3F0F8)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(guide, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(contact!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ),
                if (hasCallButton)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.deepPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    child: const Text('Gọi điện', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
              ],
            ),
          ],
          if (address != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(address, style: const TextStyle(color: Colors.grey, fontSize: 12))),
                if (hasCancelButton)
                  TextButton(onPressed: () {}, child: const Text('Hủy lịch', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPastAppointmentCard() {
    return Opacity(
      opacity: 0.6,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFF1F3F5), borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Phòng Balcony Quận 7', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
                  child: const Text('Đã hoàn thành', style: TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Text('Ngày: 15/04/2026', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),
            const Text('Đánh giá buổi xem phòng ⭐⭐⭐⭐⭐', style: TextStyle(color: AppTheme.deepPurple, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.deepPurple,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Hóa đơn'),
        BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'Phòng'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Tài khoản'),
      ],
    );
  }
}