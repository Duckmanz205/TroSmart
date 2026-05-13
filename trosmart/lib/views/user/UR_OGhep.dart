import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

class UrOGhep extends StatelessWidget {
  const UrOGhep({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề trang
            Text('Ở ghép', style: AppTheme.titleMd.copyWith(fontSize: 32, color: AppTheme.deepPurple)),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text('Room P101 (2 người)', style: AppTheme.bodySm.copyWith(color: AppTheme.textSecondary)),
              ],
            ),
            const SizedBox(height: 32),

            // Card Tiến độ thu tiền
            _buildProgressCard(),
            const SizedBox(height: 32),

            // Danh sách thành viên
            Row(
              children: [
                Icon(Icons.group_outlined, size: 20, color: AppTheme.deepPurple),
                const SizedBox(width: 8),
                Text('Thành viên phòng', style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            _buildMemberCard('Trần Thị Bình', 'Chủ phòng', 'Đã trả', '2.125.000đ', isPaid: true),
            const SizedBox(height: 12),
            _buildMemberCard('Lê Văn Minh', 'Ở ghép', 'Chưa trả', '2.125.000đ', isPaid: false),
            
            const SizedBox(height: 32),

            // Card Chi tiết thanh toán
            _buildPaymentDetailCard(),
            
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Hệ thống tính toán tự động dựa trên hợp đồng thuê phòng',
                textAlign: TextAlign.center,
                style: AppTheme.bodySm.copyWith(color: AppTheme.textSecondary, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: const Icon(Icons.menu, color: Color(0xFF0F172A)),
      title: Text('TroSmart', style: AppTheme.titleMd.copyWith(color: AppTheme.deepPurple, fontStyle: FontStyle.italic)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.bgGray200,
            child: const Icon(Icons.person_outline, color: AppTheme.textPrimary),
          ),
        )
      ],
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.bgGray200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressInfo('Tiến độ thu tiền', '50%'),
              _buildProgressInfo('Đã thu: 2.125.000đ', 'Còn lại: 2.125.000đ', alignRight: true),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.5,
            backgroundColor: AppTheme.bgGray200,
            color: AppTheme.deepPurple,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('KHỞI TẠO', style: AppTheme.bodySm.copyWith(fontSize: 10, letterSpacing: 1)),
              Text('HOÀN TẤT', style: AppTheme.bodySm.copyWith(fontSize: 10, letterSpacing: 1)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProgressInfo(String label, String value, {bool alignRight = false}) {
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.bodySm.copyWith(color: AppTheme.textSecondary)),
        Text(value, style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.bold, color: AppTheme.deepPurple)),
      ],
    );
  }

  Widget _buildMemberCard(String name, String role, String status, String amount, {required bool isPaid}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isPaid ? AppTheme.bgGray200 : AppTheme.deepPurple.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.bgGray200, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.person_outline, size: 24, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.bold)),
                Text(role, style: AppTheme.bodySm.copyWith(color: AppTheme.textSecondary, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isPaid ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status, style: TextStyle(color: isPaid ? Colors.green : Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 4),
              Text(amount, style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPaymentDetailCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFFF3F0F8), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CHI TIẾT THANH TOÁN', style: AppTheme.bodySm.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          _buildDetailRow('Tổng hóa đơn tháng này', '4.250.000đ'),
          _buildDetailRow('Chia mỗi người', '2.125.000đ', isPurple: true),
          const Divider(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.campaign_outlined),
            label: const Text('Nhắc Minh thanh toán'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.deepPurple.withOpacity(0.4),
              foregroundColor: const Color(0xFF21005D),
              minimumSize: const Size(double.infinity, 56),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isPurple = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTheme.bodyMd),
          Text(value, style: AppTheme.bodyMd.copyWith(
            fontWeight: isPurple ? FontWeight.w900 : FontWeight.bold,
            color: isPurple ? AppTheme.deepPurple : AppTheme.textPrimary,
            decoration: isPurple ? TextDecoration.underline : null,
          )),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.deepPurple,
      unselectedItemColor: AppTheme.textSecondary,
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],
    );
  }
}