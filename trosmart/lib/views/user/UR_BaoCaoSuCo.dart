import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/common/incident_card.dart';

/// User Report Incident (Báo cáo sự cố) screen.
class UrBaoCaoSuCo extends StatelessWidget {
  const UrBaoCaoSuCo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgSlate,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            _UrHeader(),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page title
                    Text('Báo cáo sự cố', style: AppTheme.headingXl),
                    const SizedBox(height: 4),
                    Text(
                      'Gửi yêu cầu hỗ trợ đến chủ trọ',
                      style: AppTheme.bodySm,
                    ),
                    const SizedBox(height: 24),

                    // ── Report Form ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: AppTheme.cardDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thông tin sự cố',
                            style: AppTheme.titleMd.copyWith(
                              color: const Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _FormField(
                            label: 'Tiêu đề',
                            hintText: 'VD: Bóng đèn phòng ngủ bị cháy',
                          ),
                          const SizedBox(height: 16),
                          _FormField(
                            label: 'Mô tả chi tiết',
                            hintText:
                                'Mô tả chi tiết tình trạng sự cố...',
                            maxLines: 4,
                          ),
                          const SizedBox(height: 16),
                          _FormDropdown(
                            label: 'Loại sự cố',
                            value: 'Điện',
                            items: ['Điện', 'Nước', 'Cơ sở hạ tầng', 'Khác'],
                          ),
                          const SizedBox(height: 16),
                          _FormDropdown(
                            label: 'Mức độ ưu tiên',
                            value: 'Trung bình',
                            items: ['Thấp', 'Trung bình', 'Cao', 'Khẩn cấp'],
                          ),
                          const SizedBox(height: 20),
                          // Photo upload area
                          _PhotoUploadArea(),
                          const SizedBox(height: 20),
                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Submit report
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.deepPurple,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusLg,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Gửi báo cáo',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── History ──
                    Text(
                      'Lịch sử báo cáo',
                      style: AppTheme.titleMd.copyWith(
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Processing card
                    IncidentCard(
                      title: 'Đèn nhà tắm hỏng',
                      date: '01/03/2026',
                      statusBadge: StatusBadge.processing(),
                      footerTitle: 'Nhân viên đang đến...',
                      footerSubtitle: 'Dự kiến: ~30 phút nữa',
                      footerIcon: Icons.engineering_outlined,
                      footerColor: AppTheme.statusBlueBorder,
                    ),

                    const SizedBox(height: 16),

                    // Completed card
                    IncidentCard(
                      title: 'Ống nước bị rò rỉ',
                      date: '25/02/2026',
                      statusBadge: StatusBadge.completed(),
                      footerTitle: 'Đánh giá của bạn',
                      footerSubtitle: 'Cảm ơn bạn đã phản hồi!',
                      footerColor: AppTheme.statusTealBorder,
                      footerIcon: Icons.star_rounded,
                      footerTrailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                          (_) => const Icon(
                            Icons.star,
                            size: 12,
                            color: AppTheme.statusTeal,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // End of history
                    _EndOfHistory(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// User-side header with back button and title.
class _UrHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgWhite,
        border: Border(
          bottom: BorderSide(color: AppTheme.bgGray100),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back_ios_new, size: 20),
            ),
          ),
          const SizedBox(width: 8),
          // Online indicator
          Container(
            width: 8,
            height: 8,
            decoration: const ShapeDecoration(
              color: AppTheme.statusGreen,
              shape: OvalBorder(),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'TroSmart',
            style: AppTheme.headingMd.copyWith(
              color: const Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: ShapeDecoration(
              color: AppTheme.bgGray100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_outline, size: 12, color: AppTheme.textBody),
                const SizedBox(width: 8),
                Text('Guest', style: AppTheme.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Form text field.
class _FormField extends StatelessWidget {
  final String label;
  final String hintText;
  final int maxLines;

  const _FormField({
    required this.label,
    required this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTheme.bodyMd.copyWith(color: AppTheme.textMuted),
            filled: true,
            fillColor: AppTheme.bgLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              borderSide: BorderSide(color: AppTheme.bgGray200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              borderSide: BorderSide(color: AppTheme.bgGray200),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}

/// Form dropdown field.
class _FormDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;

  const _FormDropdown({
    required this.label,
    required this.value,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.bgLight,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppTheme.bgGray200),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(value, style: AppTheme.bodyMd),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Photo upload area placeholder.
class _PhotoUploadArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Open image picker
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.bgLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: AppTheme.bgGray200,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.camera_alt_outlined, size: 32, color: AppTheme.textMuted),
            const SizedBox(height: 8),
            Text(
              'Thêm hình ảnh',
              style: AppTheme.bodyMd.copyWith(color: AppTheme.textMuted),
            ),
            Text(
              'Chụp ảnh hoặc chọn từ thư viện',
              style: AppTheme.labelSm,
            ),
          ],
        ),
      ),
    );
  }
}

/// End-of-history divider.
class _EndOfHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: AppTheme.bgGray200),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Hết lịch sử',
            textAlign: TextAlign.center,
            style: AppTheme.caption.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: AppTheme.bgGray200),
        ),
      ],
    );
  }
}