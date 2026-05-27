import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';
import '../../widgets/common/app_search_field.dart';
import '../../widgets/common/chat_list_item.dart';
import 'AD_ChiTietChat.dart';

class AdChat extends StatelessWidget {
  const AdChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Page Title ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text('Tin nhắn', style: AppTheme.headingXl),
            ),

            // ── Search Bar ──
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppSearchField(hintText: 'Tìm kiếm người thuê...'),
            ),

            const SizedBox(height: 8),

            // ── Chat List ──
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ChatListItem(
                    initials: 'VA',
                    name: 'Nguyễn Văn An (P.101)',
                    lastMessage: 'Em đã gửi tiền phòng rồi ạ!',
                    time: '15:30',
                    isUnread: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdChiTietChat(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 80),
                  ChatListItem(
                    initials: 'TT',
                    name: 'Trần Thị Thu (P.202)',
                    lastMessage: 'Dạ vâng, cảm ơn chủ trọ.',
                    time: '14:20',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdChiTietChat(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 80),
                  ChatListItem(
                    initials: 'LM',
                    name: 'Lê Minh (P.305)',
                    lastMessage: 'Phòng em bị hỏng vòi nước...',
                    time: '12:05',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdChiTietChat(),
                        ),
                      );
                    },
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
