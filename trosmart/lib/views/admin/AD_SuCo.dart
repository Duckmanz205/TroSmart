import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/app_colors.dart';
import '../../widgets/common/admin/custom_app_bar.dart'; 
import '../../widgets/common/admin/custom_bottom_navigation.dart'; 
import '../../widgets/admin/incident_management_widgets.dart';

class AD_SuCo extends StatelessWidget {
  const AD_SuCo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quản lý sự cố',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Theo dõi và xử lý yêu cầu sửa chữa từ khách thuê',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              
              const IncidentStatsGrid(),
              const SizedBox(height: 24),
              const IncidentSearchAndFilter(),
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách yêu cầu',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  Text(
                    '67 sự cố',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Danh sách thẻ
              const IncidentCard(
                code: 'SC089',
                title: 'Vỡ ống nước nhà vệ sinh, ngập sàn',
                status: 'CHỜ XỬ LÝ',
                type: 'NƯỚC',
                room: 'P.201 - Cơ sở 1',
                requester: 'Nguyễn Văn A',
                date: '28/03/2025',
                imagesCount: 2,
                isUrgent: true,
                bgColor: AppColors.incidentBg1,
              ),
              const IncidentCard(
                code: 'SC088',
                title: 'Chập điện aptomat phòng khách',
                status: 'ĐANG XỬ LÝ',
                type: 'ĐIỆN',
                room: 'P.305 - Cơ sở 2',
                requester: 'Trần Thị B',
                date: '27/03/2025',
                imagesCount: 1,
                bgColor: AppColors.incidentBg2,
              ),
              const IncidentCard(
                code: 'SC085',
                title: 'Hỏng bản lề cửa sổ',
                status: 'HOÀN THÀNH',
                type: 'KHÁC',
                room: 'P.102 - Cơ sở 1',
                requester: 'Lê Hoàng C',
                date: '25/03/2025',
                imagesCount: 0,
                rating: 4,
                bgColor: AppColors.incidentBg3,
              ),
              const SizedBox(height: 100), // Padding cho bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(), // Tái sử dụng BottomNav
    );
  }
}