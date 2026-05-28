import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';
import '../../widgets/common/notification_card.dart';

/// User Notification (Thông báo) screen.
class UrThongBao extends StatelessWidget {
  final VoidCallback? onNavigateToPayment;
  const UrThongBao({super.key, this.onNavigateToPayment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgSlate,
      body: SafeArea(
        child: Column(
          children: [
            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Thông báo',
                      style: AppTheme.titleMd.copyWith(
                        color: AppTheme.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 1,
                          color: AppTheme.bgGray200,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Cập nhật mới nhất từ hệ thống',
                            style: AppTheme.bodyMd.copyWith(
                              fontStyle: FontStyle.italic,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Notification Cards ──

                    // Urgent: Payment warning
                    NotificationCard(
                      title: 'Cảnh báo thanh toán\n(Khẩn cấp)',
                      description:
                          'Tiền điện tháng 10 của bạn đã quá hạn thanh toán 3 ngày. Vui lòng thanh toán ngay để tránh bị tạm ngưng cung cấp dịch vụ.',
                      timeAgo: 'VỪA\nXONG',
                      themeColor: AppTheme.statusRed,
                      icon: Icons.payment_outlined,
                      isUrgent: true,
                      actionLabel: 'THANH TOÁN NGAY',
                      onActionTap: onNavigateToPayment,
                    ),

                    const SizedBox(height: 24),

                    // Maintenance notice
                    NotificationCard(
                      title: 'Bảo trì hệ thống\nnước',
                      description:
                          'Hệ thống cấp nước khu vực tầng 3 sẽ tạm ngưng từ 14:00 đến 16:00 chiều nay để bảo trì định kỳ. Mong bạn thông cảm.',
                      timeAgo: '2 GIỜ\nTRƯỚC',
                      themeColor: AppTheme.deepPurple,
                      icon: Icons.water_drop_outlined,
                    ),

                    const SizedBox(height: 24),

                    // New rules
                    NotificationCard(
                      title: 'Quy định mới về rác\nthải',
                      description:
                          'Từ ngày mai, rác thải cần được phân loại thành Rác hữu cơ và Rác vô cơ trước khi bỏ vào thùng rác chung của tòa nhà.',
                      timeAgo: 'SÁNG\nNAY',
                      themeColor: AppTheme.statusYellow,
                      icon: Icons.delete_outline_rounded,
                    ),

                    const SizedBox(height: 24),

                    // Community event
                    NotificationCard(
                      title: 'Sự kiện cộng đồng\nsắp diễn ra',
                      description:
                          'Buổi gặp mặt cư dân quý IV sẽ được tổ chức vào thứ 7, ngày 15/10 tại sảnh tầng 1. Mọi người nhớ tham gia nhé!',
                      timeAgo: 'HÔM\nQUA',
                      themeColor: const Color(0xFF5A4D8D),
                      icon: Icons.groups_outlined,
                    ),

                    const SizedBox(height: 24),

                    // Package delivery
                    NotificationCard(
                      title: 'Bưu kiện đến nơi',
                      description:
                          'Bạn có 1 bưu kiện đang chờ nhận tại quầy lễ tân. Mã đơn hàng: #SP20261008.',
                      timeAgo: '2 NGÀY\nTRƯỚC',
                      themeColor: AppTheme.statusTeal,
                      icon: Icons.local_shipping_outlined,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}