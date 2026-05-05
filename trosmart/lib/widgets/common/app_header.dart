import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

/// Gradient header bar used in admin screens (TroSmart brand bar).
class AppGradientHeader extends StatelessWidget {
  final String roleLabel;
  final bool isDarkText;
  final VoidCallback? onMenuTap;

  const AppGradientHeader({
    super.key,
    this.roleLabel = 'Chủ trọ',
    this.isDarkText = false,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkText ? Colors.black : Colors.white;
    final menuColor = isDarkText ? Colors.black : Colors.white;

    return Container(
      width: double.infinity,
      height: 65,
      decoration: ShapeDecoration(
        gradient: isDarkText ? null : AppTheme.headerGradient,
        color: isDarkText ? Colors.white.withValues(alpha: 0.95) : null,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppTheme.accentTeal.withValues(alpha: 0.10),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            // Hamburger menu
            GestureDetector(
              onTap: onMenuTap,
              child: _HamburgerIcon(color: menuColor),
            ),
            const Spacer(),
            // Logo
            _TroSmartLogo(),
            const Spacer(),
            // Role badge
            _RoleBadge(label: roleLabel, textColor: textColor),
          ],
        ),
      ),
    );
  }
}

class _HamburgerIcon extends StatelessWidget {
  final Color color;
  const _HamburgerIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 2,
            decoration: ShapeDecoration(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Container(
            width: 16,
            height: 2,
            decoration: ShapeDecoration(
              color: color.withValues(alpha: 0.50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Container(
            width: 22,
            height: 2,
            decoration: ShapeDecoration(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TroSmartLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: ShapeDecoration(
            gradient: AppTheme.tealGradient,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Icon(Icons.home_rounded, size: 16, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Text(
          'TroSmart',
          style: TextStyle(
            color: AppTheme.accentTeal,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            height: 1.50,
          ),
        ),
      ],
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String label;
  final Color textColor;

  const _RoleBadge({required this.label, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: ShapeDecoration(
        color: AppTheme.accentTeal.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppTheme.accentTeal.withValues(alpha: 0.30),
          ),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppTheme.accentTeal,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple header with back button and title for detail screens.
class AppDetailHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;

  const AppDetailHeader({
    super.key,
    required this.title,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(color: AppTheme.bgWhite),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackTap ?? () => Navigator.maybePop(context),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back_ios_new, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTheme.headingMd.copyWith(
                color: Colors.black,
                letterSpacing: -0.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
