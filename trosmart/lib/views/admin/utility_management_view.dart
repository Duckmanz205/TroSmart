import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../shared/app_colors.dart';
import '../../widgets/admin/invoice_header.dart';
import '../../widgets/admin/utility_summary_card.dart';
import '../../widgets/admin/room_utility_entry_card.dart';
import '../../widgets/common/admin/custom_bottom_navigation.dart';

class UtilityManagementScreen extends StatelessWidget {
  const UtilityManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const InvoiceHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildScreenTitle(),
                const SizedBox(height: 24),
                _buildActionBanner(),
                const SizedBox(height: 24),
                _buildPriceSummary(),
                const SizedBox(height: 24),
                _buildSearchAndFilters(),
                const SizedBox(height: 24),
                _buildRoomListHeader(),
                const SizedBox(height: 16),
                
                // Danh sách phòng mẫu
                const RoomUtilityEntryCard(
                  roomName: "Phòng 101",
                  tenantName: "Nguyễn Văn An · Tầng 1",
                  powerOld: "1250",
                  waterOld: "340",
                ),
                const RoomUtilityEntryCard(
                  roomName: "Phòng 201",
                  tenantName: "Lê Minh Tuấn · Tầng 2",
                  isSaved: true,
                  powerOld: "3400",
                  powerNew: "3472",
                  waterOld: "340",
                  waterNew: "348",
                  totalAmount: "427.500đ",
                ),
                const RoomUtilityEntryCard(
                  roomName: "Phòng 202",
                  tenantName: "Chưa có khách thuê · Tầng 2",
                  isEmpty: true,
                ),
              ],
            ),
          ),
          CustomBottomNav(),
        ],
      ),
    );
  }

  Widget _buildScreenTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quản lý điện nước', 
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.adminDarkPurple, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            const Text('THÁNG 10 / 2024', 
              style: TextStyle(color: AppColors.adminDarkPurple, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ],
        ),
        const SizedBox(height: 8),
        const Text('Cập nhật chỉ số tiêu thụ hàng tháng từng phòng trọ.', 
          style: TextStyle(color: Color(0xFF050A0F), fontSize: 14)),
      ],
    );
  }

  Widget _buildActionBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        gradient: AppColors.adminHeaderGradient,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.save, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          const Expanded(child: Text('Lưu tất cả', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)),
            child: const Text('12/24', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        UtilitySummaryCard(icon: LucideIcons.zap, iconBgColor: Colors.amber, title: "Giá điện", value: "3.500đ", unit: "/ kWh"),
        UtilitySummaryCard(icon: LucideIcons.droplets, iconBgColor: Colors.blue, title: "Giá nước", value: "25.000đ", unit: "/ khối"),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Tìm phòng, khách thuê...',
            prefixIcon: const Icon(LucideIcons.search, size: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Icon(LucideIcons.building, size: 16),
              SizedBox(width: 12),
              Expanded(child: Text('Tất cả cơ sở (3)', style: TextStyle(fontSize: 14))),
              Icon(LucideIcons.chevronDown, size: 16),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildRoomListHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Danh sách phòng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
        Text('24 phòng', style: TextStyle(fontSize: 12)),
      ],
    );
  }
}