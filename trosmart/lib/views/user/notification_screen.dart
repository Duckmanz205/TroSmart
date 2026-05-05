import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../shared/app_colors.dart';
import '../../widgets/common/user/user_app_bar.dart';
import '../../widgets/user/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const UserAppBar(title: "Thông báo"),
  
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          const NotificationTile(
            icon: LucideIcons.alertOctagon,
            title: "Cảnh báo thanh toán\n(Khẩn cấp)",
            time: "VỪA XONG",
            content: "Tiền điện tháng 10 của bạn đã quá hạn thanh toán 3 ngày. Vui lòng thanh toán ngay để tránh bị tạm ngưng dịch vụ.",
            themeColor: AppColors.statusOrange, 
            actionText: "THANH TOÁN NGAY",
          ),
          const NotificationTile(
            icon: LucideIcons.droplets,
            title: "Bảo trì hệ thống nước",
            time: "2 GIỜ TRƯỚC",
            content: "Hệ thống cấp nước khu vực tầng 3 sẽ tạm ngưng từ 14:00 đến 16:00 chiều nay để bảo trì định kỳ.",
            themeColor: AppColors.adminDarkPurple,
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Thông báo", 
          style: TextStyle(color: AppColors.adminDarkPurple, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(width: 32, height: 1, color: AppColors.textLight.withValues(alpha:0.5)),
            const SizedBox(width: 8),
            const Text("Cập nhật mới nhất từ hệ thống", 
              style: TextStyle(color: AppColors.textLight, fontStyle: FontStyle.italic)),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Opacity(
          opacity: 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(border: Border.all(color: AppColors.textLight.withValues(alpha:0.3))),
            child: const Text("KẾT THÚC DANH SÁCH", 
              style: TextStyle(color: AppColors.textLight, fontSize: 10, letterSpacing: 1.2)),
          ),
        ),
      ),
    );
  }
}