import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';
import '../../views/user/UR_HoanTatDatLich.dart';



class UrDatLichXemPhong extends StatelessWidget {
  const UrDatLichXemPhong({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgSlate,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // --- PHẦN 1: ĐẶT LỊCH MỚI ---
                    _buildSectionTitle(Icons.calendar_today_outlined, 'Đặt lịch mới'),
                    const SizedBox(height: 16),
                    _buildRoomPreviewCard(),
                    const SizedBox(height: 20),
                    _buildInputField('Họ và tên', Icons.person_outline, 'Nhập họ tên của bạn'),
                    _buildInputField('Số điện thoại', Icons.phone_outlined, '090 123 4567'),
                    _buildInputField('Ngày xem', Icons.calendar_month_outlined, 'mm/dd/yyyy'),
                    _buildInputField('Khung giờ', Icons.access_time_outlined, 'Chọn khung giờ', isDropdown: true),
                    _buildNoteField(),
                    const SizedBox(height: 24),
                    _buildConfirmButton(context),

                    const SizedBox(height: 32),

                    // --- PHẦN 2: LỊCH HẸN CỦA BẠN ---
                    _buildSectionTitle(Icons.list_alt_outlined, 'Lịch hẹn của bạn', badge: '4'),
                    const SizedBox(height: 16),
                    
                    // Card 1: Chờ xác nhận (Vàng)
                    _buildAppointmentCard(
                      title: 'Căn Hộ Mini 1PN',
                      subtitle: 'Sunrise Home',
                      date: '24/10/2023',
                      time: '14:00 - 16:00',
                      status: 'CHỜ XÁC NHẬN',
                      statusColor: const Color(0xFFD97706),
                      statusBg: const Color(0xFFFEF3C7),
                      hasCancel: true,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Card 2: Đã xác nhận (SỬA THÀNH XANH DƯƠNG)
                    _buildAppointmentCard(
                      title: 'Phòng Trọ Gác Lửng',
                      subtitle: 'Sinh Viên House',
                      date: '25/10/2023',
                      time: '08:00 - 10:00',
                      status: 'ĐÃ XÁC NHẬN',
                      statusColor: const Color(0xFF2563EB), // Xanh dương đậm
                      statusBg: const Color(0xFFDBEAFE),    // Xanh dương nhạt
                      hasCancel: true,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Card 3: Đã xem (Xanh lá)
                    _buildAppointmentCard(
                      title: 'Studio Full Nội Thất',
                      subtitle: 'City View Apt',
                      date: '20/10/2023',
                      time: '16:00 - 18:00',
                      status: 'ĐÃ XEM',
                      statusColor: const Color(0xFF059669),
                      statusBg: const Color(0xFFD1FAE5),
                      hasCancel: false,
                    ),

                    const SizedBox(height: 12),

                    // Card 4: Đã hủy (THÊM MỚI THEO FIGMA)
                    _buildAppointmentCard(
                      title: 'Phòng Trọ Cơ Bản',
                      subtitle: 'Nhà Trọ Cô Ba',
                      date: '18/10/2023',
                      time: null, // Không có giờ
                      status: 'ĐÃ HỦY',
                      statusColor: const Color(0xFF64748B),
                      statusBg: const Color(0xFFF1F5F9),
                      hasCancel: false,
                      opacity: 0.6, // Làm mờ đi một chút vì đã hủy
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS THÀNH PHẦN ---

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, size: 18),
              ),
              const SizedBox(width: 8),
              Text('Đặt lịch xem phòng', 
                style: AppTheme.titleMd.copyWith(color: AppTheme.deepPurple, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Sắp xếp thời gian đến xem trực tiếp', 
            style: AppTheme.bodySm.copyWith(color: AppTheme.textSecondary, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, {String? badge}) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.deepPurple, size: 20),
        const SizedBox(width: 8),
        Text(title, style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.bold)),
        const Spacer(),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(12)),
            child: Text(badge, style: AppTheme.bodySm.copyWith(fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Widget _buildRoomPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: AppTheme.bgGray200, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.bed_outlined, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Studio Ban Công Lớn', style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.bold)),
              Text('Green Space Apartment', style: AppTheme.bodySm.copyWith(color: AppTheme.textSecondary)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInputField(String label, IconData icon, String hint, {bool isDropdown = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(children: [Icon(icon, size: 14, color: AppTheme.textSecondary), const SizedBox(width: 4), Text(label, style: AppTheme.bodySm.copyWith(fontWeight: FontWeight.bold))]),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppTheme.bgGray200), borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(hint, style: AppTheme.bodyMd.copyWith(color: AppTheme.textSecondary)),
              if (isDropdown) const Icon(Icons.keyboard_arrow_down, size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(children: [Icon(Icons.chat_bubble_outline, size: 14, color: AppTheme.textSecondary), const SizedBox(width: 4), Text('Ghi chú thêm', style: AppTheme.bodySm.copyWith(fontWeight: FontWeight.bold))]),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppTheme.bgGray200), borderRadius: BorderRadius.circular(12)),
          child: Text('Ví dụ: Tôi muốn xem thêm phòng ở tầng cao...', style: AppTheme.bodySm.copyWith(color: AppTheme.textSecondary)),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.deepPurple,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      onPressed: () {
        // Chuyển sang trang hoàn tất đặt lịch
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UrHoanTatDatLich(),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Xác nhận đặt lịch',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
        ],
      ),
    ),
  );
}

  Widget _buildAppointmentCard({
    required String title, required String subtitle, required String date, 
    String? time, required String status, required Color statusColor, 
    required Color statusBg, required bool hasCancel, double opacity = 1.0
  }) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: AppTheme.bodySm.copyWith(color: AppTheme.textSecondary)),
                ]),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
                  child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(children: [
              Icon(Icons.calendar_today, size: 13, color: AppTheme.textSecondary), const SizedBox(width: 4), Text(date, style: AppTheme.bodySm),
              if (time != null) ...[
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 13, color: AppTheme.textSecondary), const SizedBox(width: 4), Text(time, style: AppTheme.bodySm),
              ]
            ]),
            if (hasCancel) ...[
              const SizedBox(height: 12),
              const Align(alignment: Alignment.centerRight, child: Text('✕ Hủy lịch', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold))),
            ]
          ],
        ),
      ),
    );
  }
}