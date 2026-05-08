import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

/// Incident/report card used in AD_SuCo and UR_BaoCaoSuCo screens.
class IncidentCard extends StatelessWidget {
  final String title;
  final String date;
  final Widget statusBadge;
  final String? footerTitle;
  final String? footerSubtitle;
  final IconData? footerIcon;
  final Color? footerColor;
  final Widget? footerTrailing;
  final VoidCallback? onTap;

  const IncidentCard({
    super.key,
    required this.title,
    required this.date,
    required this.statusBadge,
    this.footerTitle,
    this.footerSubtitle,
    this.footerIcon,
    this.footerColor,
    this.footerTrailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.titleMd.copyWith(
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                statusBadge,
              ],
            ),
            const SizedBox(height: 8),
            // Date
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: AppTheme.textMuted,
                ),
                const SizedBox(width: 8),
                Text(date, style: AppTheme.caption),
              ],
            ),
            // Footer section
            if (footerTitle != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: ShapeDecoration(
                  color: (footerColor ?? AppTheme.statusBlueBg)
                      .withValues(alpha: 0.30),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: (footerColor ?? AppTheme.statusBlueBorder)
                          .withValues(alpha: 0.50),
                    ),
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusLg),
                  ),
                ),
                child: Row(
                  children: [
                    if (footerIcon != null)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: ShapeDecoration(
                          color: (footerColor ?? AppTheme.statusBlueBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusMd,
                            ),
                          ),
                        ),
                        child: Icon(
                          footerIcon,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    if (footerIcon != null)
                      const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            footerTitle!,
                            style: AppTheme.bodyMd.copyWith(
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                          ),
                          if (footerSubtitle != null)
                            Text(
                              footerSubtitle!,
                              style: AppTheme.labelSm,
                            ),
                        ],
                      ),
                    ),
                    if (footerTrailing != null) footerTrailing!,
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
