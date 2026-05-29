import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/chat_widgets.dart';

/// Admin Chat Detail screen – conversation with a specific tenant.
class AdChiTietChat extends StatelessWidget {
  const AdChiTietChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            const AppGradientHeader(
              roleLabel: 'Chủ trọ',
              isDarkText: true,
            ),

            // ── Contact Info Bar ──
            const AppDetailHeader(title: 'Lê Hùng (P103)'),

            // ── Chat Messages ──
            Expanded(
              child: Container(
                color: AppTheme.bgLight,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Date label
                    _DateLabel(label: 'Hôm nay'),
                    const SizedBox(height: 20),

                    // Tenant message (received)
                    const ChatBubble(
                      message:
                          'Anh ơi, tháng này tiền điện bao nhiêu ạ?',
                      time: '10:30',
                      isSent: false,
                    ),
                    const SizedBox(height: 20),

                    // Admin reply (sent)
                    const ChatBubble(
                      message:
                          'Chào em, tiền điện tháng này của phòng 103 là 250k nhé. Em xem chỉ số chi tiết trên app nha.',
                      time: '10:35',
                      isSent: true,
                    ),
                    const SizedBox(height: 20),

                    // Tenant reply
                    const ChatBubble(
                      message:
                          'Vâng, để chiều em chuyển khoản luôn cùng tiền phòng nhé.',
                      time: '10:40',
                      isSent: false,
                    ),
                    const SizedBox(height: 20),

                    // Admin reply
                    const ChatBubble(
                      message:
                          'Được em, cảm ơn em nhé. Nhớ chụp lại biên lai gửi anh xác nhận nha!',
                      time: '10:42',
                      isSent: true,
                    ),
                  ],
                ),
              ),
            ),

            // ── Input Bar ──
            const ChatInputBar(),
          ],
        ),
      ),
    );
  }
}

/// Date separator label in chat.
class _DateLabel extends StatelessWidget {
  final String label;
  const _DateLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: ShapeDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: Text(label, style: AppTheme.timestamp),
      ),
    );
  }
}