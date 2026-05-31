import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/app_theme.dart';
import '../../shared/api_config.dart';
import 'package:intl/intl.dart';

class UrOGhep extends StatefulWidget {
  // Giả định truyền mã phòng cố định hoặc từ màn hình đăng nhập lưu lại vào đây
  final int? maPhong; 

  const UrOGhep({super.key, this.maPhong});

  @override
  State<UrOGhep> createState() => _UrOGhepState();
}

class _UrOGhepState extends State<UrOGhep> {
  bool _isLoading = true;
  Map<String, dynamic>? _oGhepData;
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  void initState() {
    super.initState();
    _fetchDataOGhep();
  }

  // --- HÀM TẢI DỮ LIỆU ĐỘNG TỪ API BACKEND ---
  Future<void> _fetchDataOGhep() async {
    
    int idPhongThucTe = widget.maPhong ?? 2; 

    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/OGhep/chi-tiet/$idPhongThucTe'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _oGhepData = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Lỗi tải dữ liệu ở ghép: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatMoney(dynamic amount) {
    if (amount == null) return "0đ";
    return NumberFormat.simpleCurrency(locale: 'vi_VN', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: AppTheme.deepPurple)),
      );
    }

    if (_oGhepData == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Chưa có thông tin ở ghép cho phòng này.'),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _fetchDataOGhep, child: const Text('Thử lại')),
            ],
          ),
        ),
      );
    }

    // Đọc dữ liệu động bóc tách từ JSON
    final soPhong = _oGhepData!['soPhong'] ?? 'Trống';
    final tenCoSo = _oGhepData!['tenCoSo'] ?? 'Chưa rõ cơ sở';
    final soNguoiO = _oGhepData!['soNguoiO'] ?? 0;
    final progressValue = (_oGhepData!['phanTramTienDo'] ?? 0.0).toDouble();
    final List<dynamic> thanhViens = _oGhepData!['thanhViens'] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchDataOGhep,
        color: AppTheme.deepPurple,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề trang động
              Text('Ở ghép', style: AppTheme.titleMd.copyWith(fontSize: 32, color: AppTheme.deepPurple)),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text('Phòng $soPhong ($soNguoiO người) - $tenCoSo', style: AppTheme.bodySm.copyWith(color: AppTheme.textSecondary)),
                ],
              ),
              const SizedBox(height: 24),

              // Card Tiến độ thu tiền động
              _buildProgressCard(),
              const SizedBox(height: 24),

              // Danh sách thành viên liên kết DB
              Row(
                children: [
                  Icon(Icons.group_outlined, size: 20, color: AppTheme.deepPurple),
                  const SizedBox(width: 8),
                  Text('Thành viên phòng', style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              
              // Tạo danh sách thẻ thành viên động bằng ListView builder
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: thanhViens.length,
                itemBuilder: (context, index) {
                  final tv = thanhViens[index];
                  bool isPaid = tv['trangThaiThanhToan'] == 'Đã trả';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildMemberCard(
                      tv['hoTen'] ?? 'Khách thuê',
                      tv['vaiTro'] ?? 'Thành viên',
                      tv['trangThaiThanhToan'] ?? 'Chưa rõ',
                      _formatMoney(tv['conPhaiTra'] ?? 0),
                      isPaid: isPaid,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 16),

              // Card Chi tiết thanh toán chia đều tự động
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
      ),
    );
  }

  Widget _buildProgressCard() {
    final progressValue = (_oGhepData!['phanTramTienDo'] ?? 0.0).toDouble();
    final progressPercentStr = "${(progressValue * 100).toStringAsFixed(0)}%";
    final daThuStr = _formatMoney(_oGhepData!['daThu']);
    final conLaiStr = _formatMoney(_oGhepData!['conLai']);

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
              _buildProgressInfo('Tiến độ thu tiền', progressPercentStr),
              _buildProgressInfo('Đã thu: $daThuStr', 'Còn lại: $conLaiStr', alignRight: true),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progressValue,
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
    final tongHoaDonStr = _formatMoney(_oGhepData!['tongHoaDon']);
    final tienChiaDeuStr = _formatMoney(_oGhepData!['tienChiaDeu']);
    
    // Tìm xem trong phòng có ai chưa thanh toán để hiển thị nút nhắc nhở động
    String tenNguoiChuaTra = "";
    final List<dynamic> thanhViens = _oGhepData!['thanhViens'] ?? [];
    for (var tv in thanhViens) {
      if (tv['trangThaiThanhToan'] == 'Chưa trả' && tv['vaiTro'] != 'Chủ phòng') {
        tenNguoiChuaTra = tv['hoTen'] ?? '';
        break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFFF3F0F8), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CHI TIẾT THANH TOÁN', style: AppTheme.bodySm.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          _buildDetailRow('Tổng hóa đơn tháng này', tongHoaDonStr),
          _buildDetailRow('Chia mỗi người', tienChiaDeuStr, isPurple: true),
          
          if (tenNguoiChuaTra.isNotEmpty) ...[
            const Divider(height: 32),
            ElevatedButton.icon(
              // Logic xử lý thông báo nhắc nhở ở đây
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã gửi thông báo nhắc nhở đến $tenNguoiChuaTra!'), backgroundColor: Colors.green),
                );
              },
              icon: const Icon(Icons.campaign_outlined),
              label: Text('Nhắc $tenNguoiChuaTra thanh toán'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.deepPurple.withOpacity(0.4),
                foregroundColor: const Color(0xFF21005D),
                minimumSize: const Size(double.infinity, 56),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )
          ]
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
}