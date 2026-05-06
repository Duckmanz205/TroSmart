import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/app_colors.dart';

// --- Component: Header Gradient ---
class InvoiceDetailHeader extends StatelessWidget {
  const InvoiceDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 40, left: 16, right: 16),
      decoration: const BoxDecoration(
        gradient: AppColors.adminHeaderGradient, // Tận dụng gradient có sẵn
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.menu, color: Colors.white),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.accentTeal,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.home, size: 16, color: AppColors.darkAccent),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'TroSmart',
                    style: GoogleFonts.inter(
                      color: AppColors.accentTeal,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 3, backgroundColor: AppColors.accentTeal),
                    const SizedBox(width: 6),
                    Text('Chủ trọ', style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.chevron_left, color: Colors.white, size: 30),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chi tiết hóa đơn',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Tháng 04/2026 | Mã: #INV-40204',
                    style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Component: Thẻ Tóm tắt ---
class InvoiceSummaryCard extends StatelessWidget {
  const InvoiceSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TỔNG THANH TOÁN', style: GoogleFonts.inter(color: AppColors.textLight, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('4.982.000 đ', style: GoogleFonts.inter(color: AppColors.adminDarkPurple, fontSize: 28, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warningLightBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 3, backgroundColor: AppColors.statusOrange),
                    const SizedBox(width: 6),
                    Text('CHỜ TRẢ', style: GoogleFonts.inter(color: AppColors.statusOrange, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Component: Thẻ Chi tiết phí ---
class InvoiceDetailsCard extends StatelessWidget {
  const InvoiceDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Column(
        children: const [
          InvoiceDetailRow(title: 'Tiền phòng (P.402)', amount: '4.500.000đ', isBold: true),
          Divider(height: 30, color: AppColors.backgroundGray),
          InvoiceDetailRow(icon: Icons.bolt, iconColor: Colors.yellow, title: 'Điện (92 kWh x 3.500)', subtitle: 'Số cũ: 1250 - Số mới: 1342', amount: '322.000đ'),
          SizedBox(height: 16),
          InvoiceDetailRow(icon: Icons.water_drop, iconColor: Colors.blue, title: 'Nước (8 m3 x 20.000)', subtitle: 'Số cũ: 430 - Số mới: 438', amount: '160.000đ'),
          SizedBox(height: 16),
          InvoiceDetailRow(icon: Icons.language, iconColor: Colors.lightBlueAccent, title: 'Wifi & Rác', amount: '0đ (Free)'),
          SizedBox(height: 16),
          InvoiceDetailRow(icon: Icons.build, iconColor: Colors.grey, title: 'Sửa khóa cửa', amount: 'không có'),
        ],
      ),
    );
  }
}

class InvoiceDetailRow extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final String amount;
  final bool isBold;

  const InvoiceDetailRow({
    super.key,
    this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    required this.amount,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 12),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
                if (subtitle != null) Text(subtitle!, style: GoogleFonts.inter(color: AppColors.textLight, fontSize: 11)),
              ],
            ),
          ],
        ),
        Text(amount, style: GoogleFonts.inter(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
      ],
    );
  }
}

// --- Component: Thẻ chuyển khoản ---
class BankTransferCard extends StatelessWidget {
  const BankTransferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.purpleLightBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.purpleBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.qr_code_2, size: 50, color: AppColors.darkAccent),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quét QR chuyển khoản', style: GoogleFonts.inter(color: AppColors.adminDarkPurple, fontWeight: FontWeight.bold, fontSize: 13)),
              Text('Ngân hàng: VietinBank', style: GoogleFonts.inter(color: AppColors.textLight, fontSize: 11)),
              Text('STK: 102xxxxxxxxx', style: GoogleFonts.inter(color: AppColors.textLight, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Component: Các nút hành động ---
class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.adminDarkPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Gửi lại (Zalo)', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.adminDarkPurple, width: 2),
              foregroundColor: AppColors.adminDarkPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Sửa dữ liệu', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}