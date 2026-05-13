import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

class UrHopDong extends StatelessWidget {
  const UrHopDong({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainTitle(),
                    const SizedBox(height: 24),
                    _buildContractProgressCard(),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      icon: Icons.calendar_today_outlined,
                      iconBg: const Color(0xFFEEF2FF),
                      iconTint: const Color(0xFF4F46E5),
                      label: 'NGÀY BẮT ĐẦU',
                      value: '01/07/2025',
                      tag: 'Thứ Ba',
                      tagBg: const Color(0xFFE0E7FF),
                      tagTint: const Color(0xFF4F46E5),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.verified_outlined,
                      iconBg: const Color(0xFFFFF1F2),
                      iconTint: const Color(0xFFE11D48),
                      label: 'NGÀY KẾT THÚC',
                      value: '30/06/2026',
                      tag: 'Thứ Ba',
                      tagBg: const Color(0xFFFFE4E6),
                      tagTint: const Color(0xFFE11D48),
                    ),
                    const SizedBox(height: 12),
                    _buildPriceCard(
                      icon: Icons.bolt,
                      iconBg: const Color(0xFFFFFBEB),
                      label: 'TIỀN THUÊ / THÁNG',
                      amount: '3.5M',
                      currency: 'VND',
                      currencyColor: const Color(0xFFD97706),
                      extraLabel: 'HẠN THANH TOÁN',
                      extraValue: 'Ngày 05',
                    ),
                    const SizedBox(height: 12),
                    _buildPriceCard(
                      icon: Icons.wallet_outlined,
                      iconBg: const Color(0x19B794F4),
                      label: 'TIỀN ĐẶT CỌC',
                      amount: '3.5M',
                      currency: 'VND',
                      currencyColor: AppTheme.deepPurple,
                      statusTag: 'Đã nộp',
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  // --- Top Bar ---
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu, color: Color(0xFF0F172A)),
          Row(
            children: [
              Container(
                width: 10, height: 10,
                decoration: const BoxDecoration(color: AppTheme.deepPurple, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              const Text('TroSmart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: const [
                Icon(Icons.person_outline, size: 16),
                SizedBox(width: 6),
                Text('Guest', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- Header Title ---
  Widget _buildMainTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('HỢP ĐỒNG THUÊ', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 4),
        const Text('HĐ-2025-P101', style: TextStyle(color: Color(0xFF0F172A), fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFFAF5FF), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFF3E8FF))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.circle, color: AppTheme.deepPurple, size: 8),
              SizedBox(width: 8),
              Text('ĐANG HIỆU LỰC', style: TextStyle(color: AppTheme.deepPurple, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
  }

  // --- Contract Progress Card ---
  Widget _buildContractProgressCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('MÃ HỢP ĐỒNG', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.bold)),
                  Text('HĐ-2025-P101', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const Icon(Icons.description_outlined, color: AppTheme.deepPurple),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Tiến độ hợp đồng', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12, fontWeight: FontWeight.bold)),
              Text('0 / 12 tháng', style: TextStyle(color: AppTheme.deepPurple, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: 0.05, backgroundColor: Colors.grey[300], color: AppTheme.deepPurple, minHeight: 6, borderRadius: BorderRadius.circular(10)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('01/07/2025', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.bold)),
              Text('30/06/2026', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  // --- General Info Card ---
  Widget _buildInfoCard({required IconData icon, required Color iconBg, required Color iconTint, required String label, required String value, required String tag, required Color tagBg, required Color tagTint}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6))),
      child: Row(
        children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconTint)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.bold)),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(6)),
            child: Text(tag, style: TextStyle(color: tagTint, fontSize: 10, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  // --- Price Card ---
  Widget _buildPriceCard({required IconData icon, required Color iconBg, required String label, required String amount, required String currency, required Color currencyColor, String? extraLabel, String? extraValue, String? statusTag}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6))),
      child: Row(
        children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: currencyColor)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Text(amount, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Text(currency, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: currencyColor)),
                  ],
                ),
              ],
            ),
          ),
          if (extraLabel != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(extraLabel, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 9, fontWeight: FontWeight.bold)),
                Text(extraValue!, style: const TextStyle(color: Color(0xFFD97706), fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          if (statusTag != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(6)),
              child: const Text('Đã nộp', style: TextStyle(color: Color(0xFF047857), fontSize: 10, fontWeight: FontWeight.bold)),
            )
        ],
      ),
    );
  }

  // --- Bottom Action Buttons ---
  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_outlined, color: Color(0xFF1F2937)),
            label: const Text('Tải hợp đồng', style: TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 56), side: const BorderSide(color: Color(0xFFF3F4F6)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.sync, color: Colors.white),
            label: const Text('Gia hạn online', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.deepPurple, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
          ),
        ],
      ),
    );
  }
}