import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../shared/app_colors.dart';
import '../../widgets/admin/invoice_header.dart';
import '../../widgets/admin/invoice_summary_header.dart';
import '../../widgets/admin/invoice_detail_row.dart';

class InvoiceDetailScreen extends StatelessWidget {
  const InvoiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Column(
        children: [
          const InvoiceHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text(
                  'Chi tiết hóa đơn',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.adminDarkPurple,
                  ),
                ),
                const Text(
                  'Tháng 04/2026 | Mã: #INV-40204',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 24),

                const InvoiceSummaryHeader(
                  amount: '4.982.000 đ',
                  status: 'CHỜ TRẢ',
                ),
                const Divider(height: 48),

                const InvoiceDetailRow(
                  title: 'Tiền phòng (P.402)',
                  price: '4.500.000đ',
                  isBold: true,
                ),
                const InvoiceDetailRow(
                  title: '⚡ Điện (92 kWh x 3.500)',
                  subtitle: 'Số cũ: 1250 - Số mới: 1342',
                  price: '322.000đ',
                ),
                const InvoiceDetailRow(
                  title: '💧 Nước (8 m3 x 20.000)',
                  subtitle: 'Số cũ: 430 - Số mới: 438',
                  price: '160.000đ',
                ),
                const InvoiceDetailRow(
                  title: '🌐 Wifi & Rác',
                  price: '0đ (Free)',
                ),

                const SizedBox(height: 40),
                _buildQRCard(),

                const SizedBox(height: 32),
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.qrCode,
            size: 64,
            color: AppColors.adminDarkPurple,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quét QR chuyển khoản',
                style: TextStyle(
                  color: AppColors.adminDarkPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'VietinBank: 102xxxxxxxxx',
                style: TextStyle(
                  color: Colors.grey[600] ?? Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(LucideIcons.send, size: 18),
            label: const Text('Gửi Zalo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.adminDarkPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(LucideIcons.edit3, size: 18),
            label: const Text('Sửa'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.adminDarkPurple,
              side: const BorderSide(color: AppColors.adminDarkPurple),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}