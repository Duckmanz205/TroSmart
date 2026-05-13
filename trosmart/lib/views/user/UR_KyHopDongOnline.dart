import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';

class UrKyHopDongOnline extends StatefulWidget {
  const UrKyHopDongOnline({super.key});

  @override
  State<UrKyHopDongOnline> createState() => _UrKyHopDongOnlineState();
}

class _UrKyHopDongOnlineState extends State<UrKyHopDongOnline> {
  bool _agreed = false;
  final List<Offset?> _signaturePoints = [];
  bool _hasSigned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgSlate,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(Icons.people_alt_outlined, 'THÔNG TIN CÁC BÊN'),
                  _buildPartyCard('BÊN CHO THUÊ', 'Nguyễn Văn A', '012345678901', '0901 234 567', '123 Đường ABC, Phường 4, Quận Tân Bình, TP.HCM'),
                  const SizedBox(height: 12),
                  _buildPartyCard('BÊN THUÊ', 'Bùi Minh Khoa', '098765432109', '0988 777 666', '456 Đường XYZ, Phường 10, Quận 3, TP.HCM'),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle(Icons.home_outlined, 'THÔNG TIN PHÒNG THUÊ'),
                  _buildRoomCard(),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle(Icons.attach_money, 'GIÁ THUÊ & DỊCH VỤ'),
                  _buildPriceCard(),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle(Icons.calendar_today_outlined, 'THỜI HẠN HỢP ĐỒNG'),
                  _buildDurationCard(),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle(Icons.article_outlined, 'ĐIỀU KHOẢN & QUY ĐỊNH'),
                  _buildTermsCard(),
                  
                  const SizedBox(height: 24),
                  _buildSignatureSection(),
                  
                  const SizedBox(height: 20),
                  _buildAgreeCheckbox(),
                ],
              ),
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 15, left: 20, right: 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: AppTheme.deepPurple),
          ),
          const SizedBox(width: 15),
          Text('Hợp đồng thuê nhà', style: AppTheme.titleMd.copyWith(color: AppTheme.deepPurple, fontWeight: FontWeight.bold)),
          const Spacer(),
          const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://placeholder.com/user_avatar')),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.deepPurple, size: 22),
          const SizedBox(width: 8),
          Text(title, style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  // ─── Cards ───────────────────────────────────────────────────────────────
  Widget _buildPartyCard(String label, String name, String cccd, String phone, String address) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppTheme.deepPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(label, style: const TextStyle(color: AppTheme.deepPurple, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          _buildInfoText('Họ và tên', name, isBold: true),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildInfoText('Số CCCD', cccd, isBold: true)),
              Expanded(child: _buildInfoText('Điện thoại', phone, isBold: true)),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoText('Địa chỉ thường trú', address, isBold: true),
        ],
      ),
    );
  }

  Widget _buildInfoText(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        Text(value, style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildRoomCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoText('Số phòng', 'P101', isBold: true),
              _buildInfoText('Diện tích', '25 m²', isBold: true),
            ],
          ),
          const Divider(height: 24),
          const Align(alignment: Alignment.centerLeft, child: Text('TRANG THIẾT BỊ ĐI KÈM', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.bold))),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2, childAspectRatio: 4,
            children: ['Máy lạnh', 'Giường ngủ', 'Tủ quần áo', 'Máy nước nóng'].map((e) => Row(children: [const Icon(Icons.check_circle, size: 12, color: AppTheme.deepPurple), const SizedBox(width: 4), Text(e, style: const TextStyle(fontSize: 12))])).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildPriceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoText('Giá thuê tháng', '3.500.000 VND', isBold: true),
              _buildInfoText('Tiền đặt cọc', '3.500.000 VND', isBold: true),
            ],
          ),
          const Divider(height: 24),
          _buildServiceRow(Icons.bolt, 'Tiền điện', '3.500 VND/kWh', Colors.blue),
          _buildServiceRow(Icons.water_drop, 'Tiền nước', '100.000 VND/người', Colors.cyan),
          _buildServiceRow(Icons.wifi, 'Internet', '50.000 VND/tháng', Colors.purple),
        ],
      ),
    );
  }

  Widget _buildServiceRow(IconData icon, String name, String price, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [Icon(icon, size: 16, color: color), const SizedBox(width: 8), Text(name, style: const TextStyle(fontSize: 13))]),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildDurationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Thời hạn thuê', style: TextStyle(fontSize: 13)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppTheme.deepPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text('12 Tháng', style: TextStyle(color: AppTheme.deepPurple, fontWeight: FontWeight.bold, fontSize: 12))),
          ]),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _buildInfoText('NGÀY BẮT ĐẦU', '01/11/2023', isBold: true),
            const Icon(Icons.arrow_forward, size: 16, color: AppTheme.textSecondary),
            _buildInfoText('NGÀY KẾT THÚC', '01/11/2024', isBold: true),
          ]),
        ],
      ),
    );
  }

  Widget _buildTermsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: const Text('Điều 1: Trách nhiệm bên thuê\n\n1.1. Thanh toán tiền phòng đúng hạn...\n1.2. Giữ gìn vệ sinh chung...', style: TextStyle(fontSize: 12, height: 1.5)),
    );
  }

  Widget _buildSignatureSection() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _buildSectionTitle(Icons.edit_note, 'CHỮ KÝ SỐ'),
          TextButton(onPressed: () => setState(() { _signaturePoints.clear(); _hasSigned = false; }), child: const Text('XÓA CHỮ KÝ', style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold))),
        ]),
        Container(
          height: 180, width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.bgGray200, width: 2)),
          child: GestureDetector(
            onPanUpdate: (d) => setState(() { _signaturePoints.add(d.localPosition); _hasSigned = true; }),
            onPanEnd: (_) => setState(() => _signaturePoints.add(null)),
            child: CustomPaint(painter: _SignaturePainter(_signaturePoints)),
          ),
        ),
      ],
    );
  }

  Widget _buildAgreeCheckbox() {
    return Row(children: [
      Checkbox(value: _agreed, activeColor: AppTheme.deepPurple, onChanged: (v) => setState(() => _agreed = v!)),
      const Expanded(child: Text('Tôi đã đọc, hiểu và đồng ý với tất cả điều khoản...', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary))),
    ]);
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFF1F5F9)))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.download_outlined, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _agreed && _hasSigned ? () {} : null,
              icon: const Icon(Icons.verified_user_outlined, size: 18),
              label: const Text('Xác nhận và Ký tên', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.deepPurple, foregroundColor: Colors.white, minimumSize: const Size(0, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  _SignaturePainter(this.points);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppTheme.deepPurple..strokeWidth = 3.0..strokeCap = StrokeCap.round;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) canvas.drawLine(points[i]!, points[i + 1]!, paint);
    }
  }
  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) => true;
}