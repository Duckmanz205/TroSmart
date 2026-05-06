import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';
import '../../widgets/common/app_header.dart';

/// Admin Incident Management (Sự cố) screen.
class AdSuCo extends StatelessWidget {
  const AdSuCo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            const AppGradientHeader(
              roleLabel: 'Chủ trọ',
              isDarkText: true,
            ),

            // ── Page Title ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text('Quản lý sự cố', style: AppTheme.headingXl),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Theo dõi và xử lý sự cố từ người thuê',
                style: AppTheme.bodySm,
              ),
            ),

            const SizedBox(height: 16),

            // ── Stats Cards ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _StatCard(
                    label: 'Tổng sự cố',
                    value: '67',
                    icon: Icons.report_outlined,
                    color: AppTheme.deepPurple,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'Chờ xử lý',
                    value: '12',
                    icon: Icons.schedule_rounded,
                    color: AppTheme.statusOrange,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    label: 'Đang xử lý',
                    value: '8',
                    icon: Icons.autorenew_rounded,
                    color: AppTheme.statusBlue,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Filters ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _FilterChip(label: 'Tất cả', isSelected: true),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Trạng thái'),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Ưu tiên'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Section header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách yêu cầu',
                    style: AppTheme.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withValues(alpha: 0.90),
                    ),
                  ),
                  Text(
                    '67 sự cố',
                    style: AppTheme.caption,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Incident List ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _AdminIncidentCard(
                    code: 'SC089',
                    title: 'Rò rỉ nước phòng tắm',
                    room: 'P.101 - Cơ sở 1',
                    time: '2 giờ trước',
                    statusLabel: 'MỚI',
                    statusColor: AppTheme.statusRed,
                    categoryLabel: 'NƯỚC',
                    priorityLabel: 'KHẨN',
                    priorityColor: AppTheme.statusRed,
                    isHighlight: true,
                  ),
                  const SizedBox(height: 16),
                  _AdminIncidentCard(
                    code: 'SC088',
                    title: 'Chập điện aptomat phòng khách',
                    room: 'P.305 - Cơ sở 2',
                    time: '5 giờ trước',
                    statusLabel: 'ĐANG XỬ LÝ',
                    statusColor: const Color(0xFF3B82F6),
                    categoryLabel: 'ĐIỆN',
                  ),
                  const SizedBox(height: 16),
                  _AdminIncidentCard(
                    code: 'SC087',
                    title: 'Khóa cửa bị kẹt',
                    room: 'P.202 - Cơ sở 1',
                    time: '1 ngày trước',
                    statusLabel: 'HOÀN THÀNH',
                    statusColor: AppTheme.statusGreen,
                    categoryLabel: 'CƠ SỞ HẠ TẦNG',
                  ),
                  const SizedBox(height: 16),
                  _AdminIncidentCard(
                    code: 'SC086',
                    title: 'Wifi yếu tầng 3',
                    room: 'P.301 - Cơ sở 2',
                    time: '2 ngày trước',
                    statusLabel: 'ĐANG XỬ LÝ',
                    statusColor: const Color(0xFF3B82F6),
                    categoryLabel: 'MẠNG',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single stat card in the summary row.
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: color.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: color.withValues(alpha: 0.20)),
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTheme.headingLg.copyWith(color: color),
            ),
            Text(label, style: AppTheme.labelSm),
          ],
        ),
      ),
    );
  }
}

/// Filter chip toggle.
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _FilterChip({
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: ShapeDecoration(
          color: isSelected
              ? AppTheme.deepPurple
              : Colors.black.withValues(alpha: 0.03),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected
                  ? AppTheme.deepPurple
                  : Colors.white.withValues(alpha: 0.08),
            ),
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTheme.bodyMd.copyWith(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Admin-style incident card with gradient background.
class _AdminIncidentCard extends StatelessWidget {
  final String code;
  final String title;
  final String room;
  final String time;
  final String statusLabel;
  final Color statusColor;
  final String categoryLabel;
  final String? priorityLabel;
  final Color? priorityColor;
  final bool isHighlight;
  final VoidCallback? onTap;

  const _AdminIncidentCard({
    required this.code,
    required this.title,
    required this.room,
    required this.time,
    required this.statusLabel,
    required this.statusColor,
    required this.categoryLabel,
    this.priorityLabel,
    this.priorityColor,
    this.isHighlight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: isHighlight ? null : AppTheme.deepPurple.withValues(alpha: 0.80),
          gradient: isHighlight
              ? const LinearGradient(
                  begin: Alignment(0.29, -0.29),
                  end: Alignment(0.71, 1.29),
                  colors: [Color(0xE5A452B1), Color(0xCC6A3092)],
                )
              : null,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isHighlight
                  ? AppTheme.deepPurple.withValues(alpha: 0.80)
                  : Colors.white.withValues(alpha: 0.04),
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          shadows: isHighlight
              ? [
                  BoxShadow(
                    color: AppTheme.statusRed.withValues(alpha: 0.15),
                    blurRadius: 15,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Code + Status + Category
            Row(
              children: [
                Text(
                  code,
                  style: AppTheme.captionBold.copyWith(
                    color: Colors.white.withValues(alpha: 0.60),
                  ),
                ),
                const SizedBox(width: 8),
                _MiniTag(
                  label: statusLabel,
                  color: statusColor,
                ),
                const Spacer(),
                _MiniTag(
                  label: categoryLabel,
                  color: const Color(0xFFA0AEC0),
                  isMuted: true,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              title,
              style: AppTheme.titleMd.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            // Room + Time
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 14, color: Colors.white.withValues(alpha: 0.60)),
                const SizedBox(width: 8),
                Text(
                  room,
                  style: AppTheme.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.60),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time,
                    size: 14, color: Colors.white.withValues(alpha: 0.60)),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: AppTheme.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.60),
                  ),
                ),
                if (priorityLabel != null) ...[
                  const Spacer(),
                  _MiniTag(
                    label: priorityLabel!,
                    color: priorityColor ?? AppTheme.statusRed,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Small tag badge for status/category labels.
class _MiniTag extends StatelessWidget {
  final String label;
  final Color color;
  final bool isMuted;

  const _MiniTag({
    required this.label,
    required this.color,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: ShapeDecoration(
        color: isMuted
            ? Colors.white.withValues(alpha: 0.05)
            : color.withValues(alpha: 0.10),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isMuted
                ? Colors.white.withValues(alpha: 0.10)
                : color.withValues(alpha: 0.20),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          height: 1.50,
          letterSpacing: 0.50,
        ),
      ),
    );
  }
}