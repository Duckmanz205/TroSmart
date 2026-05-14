import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => onTap(0),
            child: NavItem(icon: Icons.home_outlined, label: 'Trang chủ', isActive: currentIndex == 0),
          ),
          GestureDetector(
            onTap: () => onTap(1),
            child: NavItem(icon: Icons.description, label: 'Hóa đơn', isActive: currentIndex == 1),
          ),
          GestureDetector(
            onTap: () => onTap(2),
            child: NavItem(icon: Icons.business_outlined, label: 'Phòng', isActive: currentIndex == 2),
          ),
          GestureDetector(
            onTap: () => onTap(3),
            child: NavItem(icon: Icons.person_outline_rounded, label: 'Tài khoản', isActive: currentIndex == 3),
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const NavItem({required this.icon, required this.label, this.isActive = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? const Color(0xFF2DDCB1) : Colors.black26),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isActive ? const Color(0xFF2DDCB1) : Colors.black26,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(color: Color(0xFF2DDCB1), shape: BoxShape.circle),
          ),
      ],
    );
  }
}