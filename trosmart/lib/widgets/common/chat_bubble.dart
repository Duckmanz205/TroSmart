import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

/// Chat bubble widget for both sent and received messages.
class ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isSent;

  /// For admin chat detail: sent = purple bubble, received = dark bubble.
  /// For user chat: sent = purple bubble, received = white bubble.
  final Color? backgroundColor;
  final Color? textColor;

  const ChatBubble({
    super.key,
    required this.message,
    required this.time,
    this.isSent = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ??
        (isSent
            ? AppTheme.deepPurple.withValues(alpha: 0.80)
            : AppTheme.bgDarkCard);
    final msgColor = textColor ?? Colors.white;

    return Column(
      crossAxisAlignment:
          isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: ShapeDecoration(
            color: bgColor,
            shape: RoundedRectangleBorder(
              side: isSent
                  ? BorderSide.none
                  : BorderSide(
                      width: 1,
                      color: AppTheme.bgGray100,
                    ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isSent ? 16 : 4),
                topRight: Radius.circular(isSent ? 4 : 16),
                bottomLeft: const Radius.circular(16),
                bottomRight: const Radius.circular(16),
              ),
            ),
            shadows: AppTheme.cardShadow,
          ),
          child: Text(
            message,
            style: AppTheme.bodyLg.copyWith(color: msgColor),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 4,
            left: isSent ? 0 : 4,
            right: isSent ? 4 : 0,
          ),
          child: Text(time, style: AppTheme.timestamp),
        ),
      ],
    );
  }
}
