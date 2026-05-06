import 'package:flutter/material.dart';
import '../../shared/app_colors.dart';

class NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final String content;
  final Color themeColor;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const NotificationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.time,
    required this.content,
    required this.themeColor,
    this.actionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUrgent = actionText != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUrgent ? themeColor.withValues(alpha:0.5) : AppColors.textLight.withValues(alpha:0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: themeColor, size: 24),
          ),
          const SizedBox(width: 16),
          // Nội dung thông báo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(title,
                          style: TextStyle(
                              color: themeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                    Text(time,
                        style: const TextStyle(
                            color: AppColors.textLight, fontSize: 11)), // Sử dụng textLight
                  ],
                ),
                const SizedBox(height: 8),
                Text(content,
                    style: const TextStyle(
                        color: AppColors.textDark, // Sử dụng textDark
                        fontSize: 14,
                        height: 1.5)),
                if (isUrgent) ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: onActionPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: Text(actionText!,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}