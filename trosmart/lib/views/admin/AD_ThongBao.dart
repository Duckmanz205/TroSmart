import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/app_colors.dart';
import '../../widgets/common/admin/custom_app_bar.dart';

class AD_ThongBao extends StatelessWidget {
  const AD_ThongBao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thông báo',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Quản lý và gửi thông báo cho khách thuê',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Add new notification logic
                    },
                    icon: const Icon(Icons.add, size: 20, color: Colors.white,),
                    label: Text(
                      'Tạo mới', 
                      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D28D9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            
            // Search and Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm thông báo...',
                          hintStyle: GoogleFonts.inter(color: Colors.grey),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Icon(Icons.filter_list, color: Color(0xFF6D28D9)),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildNotificationCard(
                    title: 'Nhắc nhở thanh toán tiền phòng tháng 10',
                    content: 'Đã gửi đến 15 phòng chưa thanh toán. Vui lòng thanh toán trước ngày 15/10/2025.',
                    time: '10:30 AM, 10/10/2025',
                    type: 'Nhắc nhở',
                    typeColor: Colors.orange,
                    status: 'Đã gửi',
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    title: 'Lịch bảo trì thang máy cơ sở 1',
                    content: 'Thang máy sẽ ngừng hoạt động từ 14:00 đến 16:00 ngày 12/10 để bảo trì định kỳ.',
                    time: '09:00 AM, 09/10/2025',
                    type: 'Hệ thống',
                    typeColor: Colors.blue,
                    status: 'Đã lên lịch',
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard(
                    title: 'Quy định mới về phân loại rác',
                    content: 'Yêu cầu toàn bộ khách thuê thực hiện phân loại rác hữu cơ và vô cơ từ 01/11/2025.',
                    time: '15:45 PM, 05/10/2025',
                    type: 'Quy định',
                    typeColor: Colors.purple,
                    status: 'Đã gửi',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String content,
    required String time,
    required String type,
    required Color typeColor,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  type,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: typeColor,
                  ),
                ),
              ),
              Text(
                status,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: status == 'Đã gửi' ? Colors.green : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
