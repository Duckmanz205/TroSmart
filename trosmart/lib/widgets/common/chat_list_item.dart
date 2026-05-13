import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

/// Chat list item showing avatar (initials), name, last message, and time.
class ChatListItem extends StatelessWidget {
  final String initials;
  final String name;
  final String lastMessage;
  final String time;
  final bool isUnread;
  final VoidCallback? onTap;

  const ChatListItem({
    super.key,
    required this.initials,
    required this.name,
    required this.lastMessage,
    this.time = '',
    this.isUnread = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: ShapeDecoration(
                color: AppTheme.primaryPurple.withValues(alpha: 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: AppTheme.titleMd.copyWith(color: AppTheme.deepPurple),
              ),
            ),
            const SizedBox(width: 12),
            // Name & message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTheme.titleMd.copyWith(
                      fontSize: 15,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lastMessage,
                    style: isUnread
                        ? AppTheme.bodySm.copyWith(
                            color: AppTheme.deepPurple,
                            fontWeight: FontWeight.w700,
                          )
                        : AppTheme.bodySm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Time
            if (time.isNotEmpty)
              Text(time, style: AppTheme.timestamp),
          ],
        ),
      ),
    );
  }
}
