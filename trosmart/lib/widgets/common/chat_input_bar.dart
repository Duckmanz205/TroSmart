import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

/// Chat input bar with text field and send button.
class ChatInputBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onSend;

  const ChatInputBar({
    super.key,
    this.controller,
    this.hintText = 'Nhập tin nhắn...',
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: const BoxDecoration(color: AppTheme.bgWhite),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Text input
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 52),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: ShapeDecoration(
                color: AppTheme.bgDark,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: controller,
                style: AppTheme.bodyLg.copyWith(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: AppTheme.bodyLg.copyWith(color: AppTheme.textHint),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Send button
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 52,
              height: 52,
              decoration: ShapeDecoration(
                color: AppTheme.deepPurple.withValues(alpha: 0.80),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
                shadows: [
                  BoxShadow(
                    color: AppTheme.accentTeal.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
