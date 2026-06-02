import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../shared/app_theme.dart';

class UrKyHopDongOnline extends StatefulWidget {
  final int maHopDong; // Nhận động từ màn hình danh sách/chi tiết
  final int maKhach;   // Nhận từ thông tin đăng nhập tài khoản khách

  const UrKyHopDongOnline({
    super.key, 
    required this.maHopDong, 
    required this.maKhach
  });

  @override
  State<UrKyHopDongOnline> createState() => _UrKyHopDongOnlineState();
}

class _UrKyHopDongOnlineState extends State<UrKyHopDongOnline> {
  // Key chiến lược dùng để chụp màn hình vùng nét vẽ CustomPaint xuất sang hình ảnh PNG
  final GlobalKey _globalKey = GlobalKey(); 

  bool _agreed = false;
  final List<Offset?> _signaturePoints = [];
  bool _hasSigned = false;

  // Quản lý trạng thái nạp dữ liệu
  Map<String, dynamic>? _contractData;
  bool _isLoadingData = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchChiTietHopDong();
  }

  // 🌐 1. LẤY CHI TIẾT DỮ LIỆU HỢP ĐỒNG ĐỘNG TỪ BACKEND C#
  Future<void> _fetchChiTietHopDong() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5137/api/HopDong/${widget.maHopDong}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _contractData = jsonDecode(response.body);
          _isLoadingData = false;
        });
      } else {
        throw Exception('Không thể lấy chi tiết hợp đồng nháp từ hệ thống.');
      }
    } catch (e) {
      setState(() => _isLoadingData = false);
      debugPrint("Lỗi nạp hợp đồng: $e");
    }
  }

  //  2. XỬ LÝ CHUYỂN ĐỔI BỨC VẼ THÀNH BYTES VÀ ĐẨY LÊN STORAGE SUPABASE
  Future<String?> _uploadSignatureToSupabase() async {
    try {
      // Mẹo chụp lại vùng RepaintBoundary để xuất thành dữ liệu ảnh PNG
      final RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      final Uint8List imageBytes = byteData.buffer.asUint8List();

      final supabase = Supabase.instance.client;
      final String fileName = 'sig_${widget.maKhach}_${DateTime.now().millisecondsSinceEpoch}.png';

      // Đẩy mảng Byte lên bucket mang tên 'contracts' trên Supabase Storage
      await supabase.storage.from('contracts').uploadBinary(
        fileName,
        imageBytes,
        fileOptions: const FileOptions(contentType: 'image/png'),
      );

      // Trả link URL công khai về để lưu trữ dữ liệu
      return supabase.storage.from('contracts').getPublicUrl(fileName);
    } catch (e) {
      debugPrint("Lỗi upload chữ ký lên Supabase: $e");
      return null;
    }
  }

  // 🔐 XỬ LÝ TIẾN TRÌNH KÝ SỐ BẢO MẬT SHA-256 XUỐNG SERVER
  Future<void> _handleSignContract() async {
    if (!_agreed || !_hasSigned) return;

    setState(() => _isSubmitting = true);

    try {
      // Đẩy ảnh lên đám mây nhận link
      String? publicUrl = await _uploadSignatureToSupabase();
      if (publicUrl == null) throw Exception("Đẩy bằng chứng chữ ký lên Supabase thất bại.");

      // Khóa công khai định danh giả lập thiết bị di động phục vụ thuật toán xác thực
      String devicePublicKey = "HUIT_MOBILE_SIGNATURE_KEY_RSA2048_KH_${widget.maKhach}";

      // Bắn lệnh POST sang route chuẩn Controller mới nâng cao mã băm
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5137/api/HopDong/${widget.maHopDong}/ky'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "urlChuKySupabase": publicUrl,
          "devicePublicKey": devicePublicKey
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ký số hợp đồng thành công! Phòng đã được đưa vào trạng thái Đang thuê.'), backgroundColor: Colors.green),
          );
          Navigator.pop(context, true); // Trở về màn hình trước và kích hoạt refresh lại danh sách
        }
      } else {
        throw Exception("Server phản hồi lỗi code: ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi thực thi ký hợp đồng điện tử: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // Hàm định dạng hiển thị tiền tệ
  String _formatCurrency(dynamic number) {
    if (number == null) return "0 VND";
    final format = NumberFormat("#,##0", "vi_VN");
    return "${format.format(number)} VND";
  }

  // Hàm chuyển đổi chuỗi ngày từ API C# sang dạng dd/MM/yyyy an toàn không lỗi locale
  String _formatDateStr(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "Chưa cập nhật";
    try {
      DateTime dt = DateTime.parse(dateStr);
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return const Scaffold(
        backgroundColor: AppTheme.bgSlate,
        body: Center(child: CircularProgressIndicator(color: AppTheme.deepPurple)),
      );
    }

    if (_contractData == null) {
      return Scaffold(
        backgroundColor: AppTheme.bgSlate,
        appBar: AppBar(title: const Text('Hợp đồng thuê nhà')),
        body: const Center(child: Text('Không tìm thấy thông tin chi tiết của hợp đồng này.', style: TextStyle(fontStyle: FontStyle.italic))),
      );
    }

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
                  _buildPartyCard('BÊN CHO THUÊ (CHỦ TRỌ)', 'Nguyễn Văn A', '079099123456', '0901 234 567', '123 Đường ABC, Quận Tân Bình, TP.HCM'),
                  const SizedBox(height: 12),
                  // Đổ động thông tin của khách thuê thực tế đang mở hợp đồng
                  _buildPartyCard('BÊN THUÊ (KHÁCH HÀNG)', _contractData!['tenKhach'], _contractData!['cccd'], _contractData!['sdt'], 'Địa chỉ thường trú hệ thống khách thuê'),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle(Icons.home_outlined, 'THÔNG TIN PHÒNG THUÊ'),
                  _buildRoomCard(_contractData!['soPhong'], _contractData!['tenCoSo']),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle(Icons.attach_money, 'GIÁ THUÊ & DỊCH VỤ'),
                  _buildPriceCard(_contractData!['giaThue'], _contractData!['tienCoc']),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle(Icons.calendar_today_outlined, 'THỜI HẠN HỢP ĐỒNG'),
                  _buildDurationCard(_contractData!['ngayBatDau'], _contractData!['ngayKetThuc']),
                  
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
          Text('Hợp đồng số #00${_contractData!['maHopDong']}', style: AppTheme.titleMd.copyWith(color: AppTheme.deepPurple, fontWeight: FontWeight.bold)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(12)),
            child: Text(_contractData!['trangThai'].toString().toUpperCase(), style: TextStyle(color: Colors.amber.shade900, fontSize: 10, fontWeight: FontWeight.bold)),
          )
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

  Widget _buildRoomCard(String soPhong, String tenCoSo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoText('Số phòng', soPhong, isBold: true),
              _buildInfoText('Cơ sở trọ hiển thị', tenCoSo, isBold: true),
            ],
          ),
          const Divider(height: 24),
          const Align(alignment: Alignment.centerLeft, child: Text('TRANG THIẾT BỊ ĐI KÈM MẶC ĐỊNH', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.bold))),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2, childAspectRatio: 4,
            children: ['Máy lạnh', 'Giường ngủ', 'Tủ quần áo', 'Bếp điện'].map((e) => Row(children: [const Icon(Icons.check_circle, size: 12, color: AppTheme.deepPurple), const SizedBox(width: 4), Text(e, style: const TextStyle(fontSize: 12))])).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildPriceCard(dynamic giaThue, dynamic tienCoc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoText('Giá thuê tháng', _formatCurrency(giaThue), isBold: true),
              _buildInfoText('Tiền đặt cọc phòng', _formatCurrency(tienCoc), isBold: true),
            ],
          ),
          const Divider(height: 24),
          _buildServiceRow(Icons.bolt, 'Tiền điện hệ thống', '3.500 VND/kWh', Colors.blue),
          _buildServiceRow(Icons.water_drop, 'Tiền nước cơ sở', '20.000 VND/m³', Colors.cyan),
          _buildServiceRow(Icons.wifi, 'Internet cáp quang', '50.000 VND/tháng', Colors.purple),
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

  Widget _buildDurationCard(String ngayBD, String ngayKT) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              const Text('Thời hạn thuê', style: TextStyle(fontSize: 13)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppTheme.deepPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text('Theo Phụ Lục', style: TextStyle(color: AppTheme.deepPurple, fontWeight: FontWeight.bold, fontSize: 12))),
            ]
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              _buildInfoText('NGÀY BẮT ĐẦU', _formatDateStr(ngayBD), isBold: true),
              const Icon(Icons.arrow_forward, size: 16, color: AppTheme.textSecondary),
              _buildInfoText('NGÀY KẾT THÚC', _formatDateStr(ngayKT), isBold: true),
            ]
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: const Text(
        'Điều 1: Trách nhiệm bên thuê phòng trọ HUIT\n\n'
        '1.1. Thanh toán tiền phòng đúng hạn thỏa thuận ngày 05 mỗi tháng.\n'
        '1.2. Giữ gìn vệ sinh chung, nghiêm chỉnh chấp hành quy định an ninh cơ sở.', 
        style: TextStyle(fontSize: 12, height: 1.5)
      ),
    );
  }

  Widget _buildSignatureSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
            _buildSectionTitle(Icons.edit_note, 'KHUNG KÝ SỐ ĐIỆN TỬ'),
            TextButton(
              onPressed: () => setState(() { _signaturePoints.clear(); _hasSigned = false; }), 
              child: const Text('XÓA VẼ LẠI', style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold))
            ),
          ]
        ),
        
        // 🌟 CHIẾN THUẬT QUAN TRỌNG: Bọc khung vẽ trong RepaintBoundary để xuất bytes hình ảnh
        RepaintBoundary(
          key: _globalKey,
          child: Container(
            height: 180, 
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.bgGray200, width: 2)),
            child: GestureDetector(
              onPanUpdate: (d) => setState(() { _signaturePoints.add(d.localPosition); _hasSigned = true; }),
              onPanEnd: (_) => setState(() => _signaturePoints.add(null)),
              child: CustomPaint(painter: _SignaturePainter(_signaturePoints)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgreeCheckbox() {
    return Row(
      children: [
        Checkbox(value: _agreed, activeColor: AppTheme.deepPurple, onChanged: (v) => setState(() => _agreed = v!)),
        const Expanded(child: Text('Tôi đã đọc kĩ, cam kết hiểu và đồng ý hoàn toàn với các điều khoản pháp lý số của hợp đồng này.', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary))),
      ]
    );
  }

  Widget _buildBottomAction() {
    bool canPress = _agreed && _hasSigned && !_isSubmitting;
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
              onPressed: canPress ? _handleSignContract : null,
              icon: _isSubmitting 
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.verified_user_outlined, size: 18),
              label: Text(_isSubmitting ? 'ĐANG KÝ SỐ & UPLOAD...' : 'Xác nhận và Ký tên số', style: const TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.deepPurple, 
                foregroundColor: Colors.white, 
                minimumSize: const Size(0, 52), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
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
    final paint = Paint()..color = AppTheme.deepPurple..strokeWidth = 3.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) canvas.drawLine(points[i]!, points[i + 1]!, paint);
    }
  }
  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) => true;
}