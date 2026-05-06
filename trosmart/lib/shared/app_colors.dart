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

  // ===== MÀU BỔ SUNG =====
  static const Color darkAccent = Color(0xFF27202C);
  static const Color warningLightBg = Color(0xFFFFF3E0); 
  static const Color purpleLightBg = Color(0xFFF3E5F5); 
  static const Color purpleBorder = Color(0xFFE1BEE7); 
  static const Color dividerLight = Color(0xFFF5F5F5); 
  
  // Màu đặc thù cho Quản lý Điện Nước
  static const Color utilityPurpleLight = Color(0xFF9D50CF);
  static const Color utilityPurpleDark = Color(0xFF4D2A72);
  static const Color utilityTealLight = Color(0xFFE5FDF8);
  static const Color utilityDarkCard = Color(0xFF362E40);
  static const Color utilityGray = Color(0xFF8C8C91);
  static const Color utilityBorder = Color(0xFFE8E8EE);
}