import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(LucideIcons.menu, color: Color(0xFF1A1D1F)),
        onPressed: () {},
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF2DDCB1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(LucideIcons.home, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Text(
            'TroSmart',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2DDCB1),
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE9FAF6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFD0F4EC)),
          ),
          child: Row(
            children: [
              const CircleAvatar(radius: 3, backgroundColor: Color(0xFF2DDCB1)),
              const SizedBox(width: 6),
              Text(
                'Chủ trọ',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2DDCB1),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}