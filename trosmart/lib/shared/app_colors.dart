import 'package:flutter/material.dart';

class AppColors {
  // ===== MÀU CHỦ ĐẠO =====
  static const Color primaryPurple = Color(0xFFB794F4);

  // ===== MÀU ADMIN =====
  static const Color adminDarkPurple = Color(0xFF6A3092);
  static const Color accentTeal = Color(0xFF2DDCB1);
  static const Color statusOrange = Color(0xFFFF9800);

  // ===== BACKGROUND & TEXT =====
  static const Color backgroundGray = Color(0xFFF8F7FA);
  static const Color textDark = Color(0xFF1A0D2D);
  static const Color textLight = Color(0xFF999999);

  // ===== GRADIENT =====
  static const LinearGradient adminHeaderGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFA161D2),
      Color(0xFF64417F),
      Color(0xFF27202C),
    ],
  );
}