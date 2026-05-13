import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';
import '../../widgets/chat_widgets.dart';

/// User Chat screen – chatbot-style conversation with TroSmart AI assistant.
class UrChat extends StatelessWidget {
  const UrChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Header ──
            _ChatAppHeader(),

            // ── Contact Info ──
            _ContactInfoBar(),

            // ── Messages ──
            Expanded(
              child: Container(
                color: AppTheme.bgLight,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Date label
                    _DateLabel(label: 'HÔM NAY'),
                    const SizedBox(height: 16),

                    // Bot message
                    _BotMessage(
                      message:
                          'Chào bạn! Mình là trợ lý ảo của TroSmart. Bạn cần tìm phòng trọ ở khu vực nào ạ?',
                      time: '08:00',
                    ),
                    const SizedBox(height: 16),

                    // User message
                    const ChatBubble(
                      message:
                          'Chào bạn, mình đang tìm phòng ở khu vực Quận 1, giá khoảng 3-5 triệu.',
                      time: '08:02',
                      isSent: true,
                      backgroundColor: Color(0xFF8B5CF6),
                    ),
                    const SizedBox(height: 16),

                    // Bot response with room card
                    _BotMessage(
                      message:
                          'Mình đã tìm thấy 3 phòng phù hợp với yêu cầu của bạn tại Quận 1. Bạn có muốn xem chi tiết không?',
                      time: '08:05',
                    ),
                    const SizedBox(height: 12),

                    // Room suggestion card
                    _RoomSuggestionCard(
                      imageUrl: 'https://placehold.co/300x160',
                      title: 'Phòng trọ Quận 1 - Gần chợ Bến Thành',
                      price: '3.500.000đ/tháng',
                      area: '25m²',
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ── Chat Input ──
            const ChatInputBar(hintText: 'Nhập tin nhắn...'),
          ],
        ),
      ),
    );
  }
}

/// Top app bar with logo and role.
class _ChatAppHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgWhite,
        border: Border(
          bottom: BorderSide(color: AppTheme.bgGray100),
        ),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back_ios_new, size: 20),
            ),
          ),
          const SizedBox(width: 8),
          // Online status dot
          Container(
            width: 8,
            height: 8,
            decoration: const ShapeDecoration(
              color: AppTheme.statusGreen,
              shape: OvalBorder(),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'TroSmart',
            style: AppTheme.headingMd.copyWith(
              color: const Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: ShapeDecoration(
              color: AppTheme.bgGray100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_outline, size: 12, color: AppTheme.textBody),
                const SizedBox(width: 8),
                Text('Guest', style: AppTheme.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Contact info bar showing chat partner.
class _ContactInfoBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgWhite,
        border: Border(
          bottom: BorderSide(color: AppTheme.bgGray100),
        ),
      ),
      child: Row(
        children: [
          // Avatar with online indicator
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: AppTheme.bgGray100,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: AppTheme.bgGray100),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: AppTheme.deepPurple,
                  size: 24,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: ShapeDecoration(
                    color: AppTheme.statusGreen,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Name and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chủ trọ - Anh An',
                  style: AppTheme.bodyMd.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                Text(
                  'Online',
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.statusGreenText,
                  ),
                ),
              ],
            ),
          ),
          // Info button
          const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.info_outline, size: 24, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }
}

/// Date separator label.
class _DateLabel extends StatelessWidget {
  final String label;
  const _DateLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: ShapeDecoration(
          color: AppTheme.bgGray200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: Text(
          label,
          style: AppTheme.labelSm.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

/// Bot (received) message with avatar icon.
class _BotMessage extends StatelessWidget {
  final String message;
  final String time;

  const _BotMessage({required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bot avatar
        Container(
          width: 32,
          height: 32,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: AppTheme.bgGray200),
              borderRadius: BorderRadius.circular(9999),
            ),
            shadows: AppTheme.cardShadow,
          ),
          child: const Icon(
            Icons.smart_toy_outlined,
            size: 16,
            color: AppTheme.deepPurple,
          ),
        ),
        const SizedBox(width: 8),
        // Message bubble
        Expanded(
          child: ChatBubble(
            message: message,
            time: time,
            isSent: false,
            backgroundColor: Colors.white,
            textColor: const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}

/// Room suggestion card shown inside chat.
class _RoomSuggestionCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String area;

  const _RoomSuggestionCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.area,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: AppTheme.bgGray200),
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 160,
                  color: AppTheme.bgGray100,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF8B5CF6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'Phù hợp 95%',
                      style: AppTheme.labelSm.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        price,
                        style: AppTheme.bodyMd.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF8B5CF6),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.square_foot, size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text(area, style: AppTheme.caption),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}