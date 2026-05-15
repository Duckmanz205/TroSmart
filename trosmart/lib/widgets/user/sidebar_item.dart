import 'package:flutter/material.dart';
import '../../shared/app_colors.dart';

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final String? badge;
  final bool hasDot;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.title,
    this.isActive = false,
    this.badge,
    this.hasDot = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: isActive
          ? AppColors.primaryPurple.withValues(alpha: 0.1)
          : Colors.transparent,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryPurple.withValues(alpha: 0.1)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive
              ? AppColors.primaryPurple
              : const Color(0xFF6B7280),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive
              ? AppColors.adminDarkPurple
              : const Color(0xFF6B7280),
          fontSize: 15,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
        ),
      ),
      trailing: badge != null
          ? _buildBadge()
          : (hasDot ? _buildDot() : null),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF97316),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        badge!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFF14B8A6),
        shape: BoxShape.circle,
      ),
    );
  }
}