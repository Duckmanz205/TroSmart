import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../shared/app_colors.dart';

class PageTitleSection extends StatelessWidget {
  const PageTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quản lý điện nước',
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.darkAccent,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.adminDarkPurple,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'THÁNG 10 / 2024',
              style: TextStyle(
                color: AppColors.adminDarkPurple,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Cập nhật chỉ số tiêu thụ hàng tháng từng phòng trọ.',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }
}

class SaveAllButton extends StatelessWidget {
  const SaveAllButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.utilityPurpleLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.adminDarkPurple.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.save, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Lưu tất cả',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.utilityPurpleDark.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '12/24',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UtilityStatsGrid extends StatelessWidget {
  const UtilityStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _buildStatCard('Giá điện', '3.500đ', '/ kWh', LucideIcons.zap, Colors.yellow[400]!),
        _buildStatCard('Giá nước', '25.000đ', '/ khối', LucideIcons.droplet, Colors.blue[300]!),
        _buildStatCard('Đã nhập', '12 phòng', '/ 24 phòng', LucideIcons.checkCircle, AppColors.accentTeal),
        _buildStatCard('Kỳ thu', 'T10/2024', '', LucideIcons.calendar, AppColors.accentTeal, isPicker: true),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String unit, IconData icon, Color iconColor, {bool isPicker = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.utilityPurpleLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (unit.isNotEmpty)
                      Text(
                        ' $unit',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 9,
                        ),
                      ),
                    if (isPicker)
                      const Icon(LucideIcons.chevronDown, color: AppColors.accentTeal, size: 12),
                  ],
                ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UtilityFilterSection extends StatelessWidget {
  const UtilityFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Tìm phòng, khách thuê...',
            prefixIcon: const Icon(LucideIcons.search, color: Colors.grey, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.utilityBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.utilityBorder),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.utilityBorder),
          ),
          child: const Row(
            children: [
              Icon(LucideIcons.mapPin, color: Colors.grey, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tất cả cơ sở (3)',
                  style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkAccent),
                ),
              ),
              Icon(LucideIcons.chevronDown, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class RoomListHeader extends StatelessWidget {
  const RoomListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Danh sách phòng',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          '24 phòng',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

enum RoomStatus { inputting, calculated, saved, vacant }

class RoomUtilityCard extends StatelessWidget {
  final String roomName;
  final String tenant;
  final RoomStatus status;
  final String? totalAmount;

  const RoomUtilityCard({
    super.key,
    required this.roomName,
    required this.tenant,
    required this.status,
    this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor = status == RoomStatus.vacant ? Colors.grey[400]! : AppColors.utilityPurpleLight;
    
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          if (status != RoomStatus.vacant)
            BoxShadow(
              color: AppColors.adminDarkPurple.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        roomName,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      if (status == RoomStatus.saved) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentTeal.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.accentTeal.withOpacity(0.3)),
                          ),
                          child: const Row(
                            children: [
                              Icon(LucideIcons.check, color: AppColors.accentTeal, size: 10),
                              SizedBox(width: 4),
                              Text('Đã lưu', style: TextStyle(color: AppColors.accentTeal, fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                      if (status == RoomStatus.vacant) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('Trống', style: TextStyle(color: Colors.white70, fontSize: 10)),
                        ),
                      ]
                    ],
                  ),
                  Text(
                    tenant,
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                  ),
                ],
              ),
              if (status != RoomStatus.vacant)
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(status == RoomStatus.saved ? LucideIcons.edit2 : LucideIcons.save, size: 14),
                  label: Text(status == RoomStatus.saved ? 'Sửa' : 'Lưu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: status == RoomStatus.saved ? Colors.white.withOpacity(0.1) : AppColors.accentTeal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (status == RoomStatus.vacant)
            _buildVacantPlaceholder()
          else
            _buildReadingInputs(),
          if (status != RoomStatus.vacant) ...[
            const Divider(color: Colors.white12),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tổng cộng', style: TextStyle(color: Colors.white70, fontSize: 14)),
                Text(
                  totalAmount ?? '— đ',
                  style: TextStyle(
                    color: totalAmount != null ? AppColors.accentTeal : Colors.white38,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReadingInputs() {
    return Row(
      children: [
        Expanded(
          child: _buildInputBox(
            'Điện (kWh)',
            LucideIcons.zap,
            Colors.yellow[400]!,
            '1250',
            status == RoomStatus.inputting ? null : '2165',
            consumption: status != RoomStatus.inputting ? '65 kWh' : null,
            cost: status != RoomStatus.inputting ? '227.500đ' : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInputBox(
            'Nước (m³)',
            LucideIcons.droplet,
            Colors.blue[300]!,
            '340',
            status == RoomStatus.inputting ? null : '348',
            consumption: status != RoomStatus.inputting ? '8 m³' : null,
            cost: status != RoomStatus.inputting ? '200.000đ' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildInputBox(String title, IconData icon, Color iconColor, String oldVal, String? newVal, {String? consumption, String? cost}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.utilityDarkCard.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 14),
              const SizedBox(width: 4),
              Text(title, style: TextStyle(color: iconColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text('Chỉ số cũ', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
            child: Text(oldVal, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ),
          const SizedBox(height: 8),
          Text('Chỉ số mới', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(8),
              border: newVal != null ? Border.all(color: AppColors.accentTeal.withOpacity(0.3)) : null,
            ),
            child: Text(
              newVal ?? 'Nhập...',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: newVal != null ? Colors.white : Colors.white24,
                fontSize: 13,
                fontWeight: newVal != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (consumption != null) ...[
            const SizedBox(height: 8),
            const Divider(color: Colors.white10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tiêu thụ', style: TextStyle(color: Colors.white38, fontSize: 10)),
                Text(consumption, style: TextStyle(color: iconColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Chi phí', style: TextStyle(color: Colors.white38, fontSize: 10)),
                Text(cost!, style: TextStyle(color: iconColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildVacantPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10, style: BorderStyle.none),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
            child: const Icon(LucideIcons.doorClosed, color: Colors.white38, size: 32),
          ),
          const SizedBox(height: 12),
          const Text('Phòng chưa có khách thuê', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const Text('Không cần nhập chỉ số', style: TextStyle(color: Colors.white30, fontSize: 12)),
        ],
      ),
    );
  }
}