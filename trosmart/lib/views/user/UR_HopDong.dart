import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../shared/app_theme.dart';
import 'UR_KyHopDongOnline.dart';

class UrHopDong extends StatefulWidget {
  final int maHopDong; // Nhận động từ màn hình tổng quan/tài khoản

  const UrHopDong({super.key, required this.maHopDong});

  @override
  State<UrHopDong> createState() => _UrHopDongState();
}

class _UrHopDongState extends State<UrHopDong> {
  Map<String, dynamic>? _contract;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChiTietHopDong();
  }

  // 🌐 LẤY DỮ LIỆU ĐỘNG TỪ TẦNG SERVICE C# (THÔNG QUA DTOS/HOPDONGRENDERDTO)
  Future<void> _fetchChiTietHopDong() async {
    try {
      setState(() => _isLoading = true);
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5137/api/HopDong/${widget.maHopDong}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _contract = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception("Không thể tải thông tin hợp đồng.");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Lỗi nạp dữ liệu hợp đồng khách thuê: $e");
    }
  }

  // Hàm chuyển đổi định dạng chuỗi ngày (DateOnly) sang định dạng Việt Nam an toàn
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      DateTime parsed = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(parsed);
    } catch (_) {
      return dateStr;
    }
  }

  // Hàm chuyển đổi thứ tự ngày trong tuần (Thứ mấy) không phụ thuộc locale hệ thống
  String _getDayOfWeekTag(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      DateTime parsed = DateTime.parse(dateStr);
      switch (parsed.weekday) {
        case 1: return "Thứ Hai";
        case 2: return "Thứ Ba";
        case 3: return "Thứ Tư";
        case 4: return "Thứ Năm";
        case 5: return "Thứ Sáu";
        case 6: return "Thứ Bảy";
        default: return "Chủ Nhật";
      }
    } catch (_) {
      return "N/A";
    }
  }

  // Hàm tính số tháng tiến độ dựa trên ngày bắt đầu và ngày hiện tại
  double _calculateProgress(String? startStr, String? endStr) {
    if (startStr == null || endStr == null) return 0.0;
    try {
      DateTime start = DateTime.parse(startStr);
      DateTime end = DateTime.parse(endStr);
      DateTime now = DateTime.now();

      if (now.isBefore(start)) return 0.0;
      if (now.isAfter(end)) return 1.0;

      int totalDays = end.difference(start).inDays;
      int passedDays = now.difference(start).inDays;

      if (totalDays <= 0) return 0.0;
      return (passedDays / totalDays).clamp(0.0, 1.0);
    } catch (_) {
      return 0.0;
    }
  }

  // Hàm tính số tháng đã ở thực tế
  int _getPassedMonths(String? startStr) {
    if (startStr == null) return 0;
    try {
      DateTime start = DateTime.parse(startStr);
      DateTime now = DateTime.now();
      if (now.isBefore(start)) return 0;
      
      int months = (now.year - start.year) * 12 + now.month - start.month;
      return months < 0 ? 0 : months;
    } catch (_) {
      return 0;
    }
  }

  // Hàm rút gọn hiển thị tiền dạng triệu (M)
  String _formatCurrency(dynamic amount) {
    if (amount == null) return "0 VND";
    final format = NumberFormat("#,##0", "vi_VN");
    return "${format.format(amount)} VND";
  }

  String _formatAmountToM(dynamic amount) {
    if (amount == null) return "0";
    try {
      double val = double.parse(amount.toString());
      double m = val / 1000000;
      return m % 1 == 0 ? m.toInt().toString() : m.toStringAsFixed(1);
    } catch (_) {
      return amount.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: AppTheme.deepPurple)),
      );
    }

    if (_contract == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('Không tìm thấy dữ liệu hợp đồng mã #${widget.maHopDong}', 
            style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
        ),
      );
    }

    String trangThai = _contract!['trangThai']?.toString().trim() ?? "Chờ khách ký";
    bool daKy = trangThai == "Đang hiệu lực";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainTitle(_contract!['maHopDong'], trangThai),
                    const SizedBox(height: 24),
                    _buildContractProgressCard(_contract!['maHopDong'], _contract!['ngayBatDau'], _contract!['ngayKetThuc']),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      icon: Icons.calendar_today_outlined,
                      iconBg: const Color(0xFFEEF2FF),
                      iconTint: const Color(0xFF4F46E5),
                      label: 'NGÀY BẮT ĐẦU',
                      value: _formatDate(_contract!['ngayBatDau']),
                      tag: _getDayOfWeekTag(_contract!['ngayBatDau']),
                      tagBg: const Color(0xFFE0E7FF),
                      tagTint: const Color(0xFF4F46E5),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.verified_outlined,
                      iconBg: const Color(0xFFFFF1F2),
                      iconTint: const Color(0xFFE11D48),
                      label: 'NGÀY KẾT THÚC',
                      value: _formatDate(_contract!['ngayKetThuc']),
                      tag: _getDayOfWeekTag(_contract!['ngayKetThuc']),
                      tagBg: const Color(0xFFFFE4E6),
                      tagTint: const Color(0xFFE11D48),
                    ),
                    const SizedBox(height: 12),
                    _buildPriceCard(
                      icon: Icons.bolt,
                      iconBg: const Color(0xFFFFFBEB),
                      label: 'TIỀN THUÊ / THÁNG (PHÒNG ${_contract!['soPhong']})',
                      amount: _formatAmountToM(_contract!['giaThue']),
                      currency: 'M',
                      currencyColor: const Color(0xFFD97706),
                      extraLabel: 'HẠN THANH TOÁN',
                      extraValue: 'Ngày 05',
                    ),
                    const SizedBox(height: 12),
                    _buildPriceCard(
                      icon: Icons.wallet_outlined,
                      iconBg: const Color(0xFFF5F3FF),
                      label: 'TIỀN ĐẶT CỌC BẢO LƯU',
                      amount: _formatAmountToM(_contract!['tienCoc']),
                      currency: 'M',
                      currencyColor: AppTheme.deepPurple,
                      statusTag: daKy ? 'Đã nộp' : 'Chờ đối chiếu',
                    ),
                    const SizedBox(height: 24),
                    
                    // Điều khoản & Quy định bổ sung tăng tính học thuật đồ án
                    const Text('📜 ĐIỀU KHOẢN & QUY ĐỊNH', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6))),
                      child: const Text(
                        'Điều 1: Trách nhiệm bên thuê phòng trọ HUIT\n'
                        '1.1. Thanh toán tiền phòng đúng hạn thỏa thuận ngày 05 mỗi tháng.\n'
                        '1.2. Giữ gìn vệ sinh chung, nghiêm chỉnh chấp hành quy định an ninh cơ sở.',
                        style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF334155)),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Minh chứng chữ ký kéo từ Supabase Storage nếu đã ký thành công
                    if (daKy && _contract!['urlChuKySupabase'] != null && _contract!['urlChuKySupabase'].toString().isNotEmpty) ...[
                      const Text('CHỮ KÝ ĐIỆN TỬ ĐÃ XÁC THỰC', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      const SizedBox(height: 8),
                      Container(
                        height: 120, width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFFF9FAFB),
                        ),
                        child: Image.network(_contract!['urlChuKySupabase'], fit: BoxFit.contain),
                      )
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(daKy),
          ],
        ),
      ),
    );
  }

  // --- Header Title ---
  Widget _buildMainTitle(int id, String status) {
    bool isLive = status == "Đang hiệu lực";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('HỢP ĐỒNG THUÊ KHÁCH HÀNG', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text('HĐ-2026-P${_contract!['soPhong']}', style: const TextStyle(color: Color(0xFF0F172A), fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isLive ? const Color(0xFFFAF5FF) : const Color(0xFFFFF7ED), 
            borderRadius: BorderRadius.circular(20), 
            border: Border.all(color: isLive ? const Color(0xFFF3E8FF) : const Color(0xFFFFEDD5))
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, color: isLive ? AppTheme.deepPurple : Colors.orange, size: 8),
              const SizedBox(width: 8),
              Text(status.toUpperCase(), style: TextStyle(color: isLive ? AppTheme.deepPurple : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
  }

  // --- Contract Progress Card ---
  Widget _buildContractProgressCard(int id, String? start, String? end) {
    double progressValue = _calculateProgress(start, end);
    int passedMonths = _getPassedMonths(start);

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
                children: [
                  const Text('CƠ SỞ HIỂN THỊ', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.bold)),
                  Text('${_contract!['tenCoSo']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const Icon(Icons.description_outlined, color: AppTheme.deepPurple),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tiến độ thực tế', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12, fontWeight: FontWeight.bold)),
              Text('$passedMonths / 12 tháng', style: const TextStyle(color: AppTheme.deepPurple, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progressValue, backgroundColor: Colors.grey[300], color: AppTheme.deepPurple, minHeight: 6, borderRadius: BorderRadius.circular(10)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDate(start), style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.bold)),
              Text(_formatDate(end), style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 10, fontWeight: FontWeight.bold)),
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
              child: Text(statusTag, style: const TextStyle(color: Color(0xFF047857), fontSize: 10, fontWeight: FontWeight.bold)),
            )
        ],
      ),
    );
  }

  // --- Bottom Action Buttons (ĐỒNG BỘ FLOW ĐIỀU HƯỚNG KÝ ONLINE) ---
  Widget _buildBottomButtons(bool daKy) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFF3F4F6)))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton.icon(
            onPressed: () {
              // Thao tác tải PDF dự phòng mở rộng
            },
            icon: const Icon(Icons.download_outlined, color: Color(0xFF1F2937)),
            label: const Text('Tải hợp đồng (PDF)', style: TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 56), side: const BorderSide(color: Color(0xFFF3F4F6)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          ),
          const SizedBox(height: 12),
          
          // 🌟 NÚT CHUYỂN TRANG THEO FLOW ÔNG YÊU CẦU
          ElevatedButton.icon(
            icon: Icon(daKy ? Icons.lock_outline : Icons.border_color_outlined, color: Colors.white),
            label: Text(
              daKy ? 'HỢP ĐỒNG ĐANG CÓ HIỆU LỰC' : 'TIẾN HÀNH KÝ ONLINE NGAY', 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: daKy ? Colors.grey.shade400 : AppTheme.deepPurple, 
              minimumSize: const Size(double.infinity, 56), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
              elevation: 0
            ),
            onPressed: daKy ? null : () async {
              // ➔ CHƯA KÝ: Thỏa mãn bấm nút mới mở toàn màn hình trang vẽ chữ ký UrKyHopDongOnline của ông
              bool? success = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UrKyHopDongOnline(
                    maHopDong: widget.maHopDong,
                    maKhach: int.tryParse((
                      _contract!['MaKhach'] ?? _contract!['maKhach'] ?? _contract!['MAKHACH'] ?? _contract!['ma_khach'] ?? 1
                    ).toString()) ?? 1,
                  ),
                ),
              );
              
              // Nếu từ màn hình ký số online bấm xác nhận thành công và back về -> Kích hoạt tải lại dữ liệu cập nhật trạng thái mới liền
              if (success == true) {
                _fetchChiTietHopDong();
              }
            },
          ),
        ],
      ),
    );
  }
}