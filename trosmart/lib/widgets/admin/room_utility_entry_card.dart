import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../shared/app_colors.dart';
import 'utility_index_field.dart';

class RoomUtilityEntryCard extends StatelessWidget {
  final String roomName;
  final String tenantName;
  final bool isSaved;
  final bool isEmpty;
  final String powerOld;
  final String powerNew;
  final String waterOld;
  final String waterNew;
  final String totalAmount;

  const RoomUtilityEntryCard({
    super.key,
    required this.roomName,
    required this.tenantName,
    this.isSaved = false,
    this.isEmpty = false,
    this.powerOld = "0",
    this.powerNew = "",
    this.waterOld = "0",
    this.waterNew = "",
    this.totalAmount = "—",
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEmpty ? 0.65 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.adminDarkPurple.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSaved ? AppColors.accentTeal.withOpacity(0.2) : Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            _buildHeader(),
            if (!isEmpty) ...[
              const SizedBox(height: 16),
              _buildUtilityInputRow(LucideIcons.zap, "Điện (kWh)", Colors.amber, powerOld, powerNew),
              const SizedBox(height: 12),
              _buildUtilityInputRow(LucideIcons.droplets, "Nước (m³)", Colors.blue, waterOld, waterNew),
              const Divider(color: Colors.white10, height: 24),
              _buildFooter(),
            ] else 
              _buildEmptyPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(roomName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                if (isSaved) _buildBadge("Đã lưu", AppColors.accentTeal),
                if (isEmpty) _buildBadge("Trống", Colors.grey),
              ],
            ),
            Text(tenantName, style: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 12)),
          ],
        ),
        _buildActionButton(),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        gradient: isSaved ? null : const LinearGradient(colors: [Color(0xFF2DDCB1), Color(0xFF1FAF90)]),
        color: isSaved ? Colors.white.withOpacity(0.05) : null,
        borderRadius: BorderRadius.circular(10),
        border: isSaved ? Border.all(color: Colors.white.withOpacity(0.1)) : null,
      ),
      child: Row(
        children: [
          Icon(isSaved ? LucideIcons.edit3 : LucideIcons.save, size: 14, color: isSaved ? Colors.grey : Colors.black),
          const SizedBox(width: 6),
          Text(isSaved ? 'Sửa' : 'Lưu', 
            style: TextStyle(color: isSaved ? Colors.grey : Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildUtilityInputRow(IconData icon, String title, Color color, String old, String newVal) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x99050A0F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color.withOpacity(0.8)),
              const SizedBox(width: 6),
              Text(title, style: TextStyle(color: color.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: UtilityIndexField(label: "Chỉ số cũ", value: old)),
              const SizedBox(width: 12),
              Expanded(child: UtilityIndexField(label: "Chỉ số mới", value: newVal.isEmpty ? "Nhập..." : newVal, isEditable: true)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Tổng cộng', style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 12)),
        Text(totalAmount, style: const TextStyle(color: AppColors.accentTeal, fontSize: 18, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildEmptyPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: const Color(0x66050A0F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: const Column(
        children: [
          Icon(LucideIcons.home, color: Colors.grey, size: 32),
          SizedBox(height: 8),
          Text('Phòng chưa có khách thuê', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}