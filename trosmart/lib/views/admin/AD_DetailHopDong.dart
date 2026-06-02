import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:trosmart/views/admin/AD_EditHopDong.dart'; // 🌟 Import trang Edit
import 'package:trosmart/views/admin/AD_GiaHanHopDong.dart'; // 🌟 Import trang Gia hạn
import '../../shared/app_theme.dart';

class AdDetailHopDong extends StatefulWidget {
  final int maHopDong;
  const AdDetailHopDong({super.key, required this.maHopDong});

  @override
  State<AdDetailHopDong> createState() => _AdDetailHopDongState();
}

class _AdDetailHopDongState extends State<AdDetailHopDong> {
  bool _isLoading = true;
  Map<String, dynamic>? _contractData;

  @override
  void initState() {
    super.initState();
    _fetchContractDetail();
  }

  Future<void> _fetchContractDetail() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5137/api/HopDong/${widget.maHopDong}'));
      if (response.statusCode == 200) {
        setState(() {
          _contractData = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception("Lỗi tải chi tiết");
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red));
      }
    }
  }

  //  NÚT SỬA BÊN TRONG TRANG CHI TIẾT
  Future<void> _handleEdit() async {
    if (_contractData?['trangThai'] == 'Đang hiệu lực' || _contractData?['trangThai'] == 'Đã ký') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Hợp đồng đã ký kết, không thể sửa!'), backgroundColor: Colors.orange
      ));
      return;
    }

    bool? isEdited = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdEditHopDong(maHopDong: widget.maHopDong)),
    );

    if (isEdited == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cập nhật thành công!'), backgroundColor: Colors.green));
      setState(() => _isLoading = true);
      _fetchContractDetail(); // Load lại dữ liệu mới nhất
    }
  }

  // 🌟 NÚT GIA HẠN HỢP ĐỒNG
  Future<void> _handleGiaHan() async {
    bool? isExtended = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdGiaHanHopDong(maHopDong: widget.maHopDong)),
    );

    if (isExtended == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gia hạn hợp đồng thành công!'), backgroundColor: Colors.green));
      setState(() => _isLoading = true);
      _fetchContractDetail(); // Load lại dữ liệu mới nhất
    }
  }

  // 🌟 KIỂM TRA HỢP ĐỒNG CÓ PHẢI LÀ SẮP HẾT HOẶC ĐÃ HẾT KHÔNG
  bool _isContractExpiredOrNearExpiry() {
    if (_contractData?['ngayKetThuc'] == null) return false;
    
    try {
      DateTime endDate = DateTime.parse(_contractData!['ngayKetThuc'].toString());
      DateTime today = DateTime.now();
      Duration difference = endDate.difference(today);
      
      // Nếu hợp đồng đã hết (hôm nay sau ngày kết thúc) hoặc sắp hết (trong 30 ngày)
      return difference.inDays <= 30; // 30 ngày là "sắp hết"
    } catch (e) {
      return false;
    }
  }

  // 🌟 LẤY THÔNG TIN TRẠNG THÁI HỢP ĐỒNG CHO NÚT GIA HẠN
  String _getGiaHanButtonStatus() {
    if (_contractData?['ngayKetThuc'] == null) {
      return 'Không có dữ liệu ngày hết hạn';
    }
    
    try {
      DateTime endDate = DateTime.parse(_contractData!['ngayKetThuc'].toString());
      DateTime today = DateTime.now();
      Duration difference = endDate.difference(today);
      
      if (difference.inDays <= 0) {
        return 'Hợp đồng đã hết hạn';
      } else if (difference.inDays <= 30) {
        return 'Hợp đồng sắp hết hạn (${difference.inDays} ngày)';
      } else {
        return 'Hợp đồng còn ${difference.inDays} ngày';
      }
    } catch (e) {
      return 'Không thể xác định trạng thái';
    }
  }

  Future<void> _handleDelete() async {
    //  CHẶN NGAY TỪ ĐẦU NẾU ĐANG CÓ HIỆU LỰC
    if (_contractData?['trangThai'] == 'Đang hiệu lực' || _contractData?['trangThai'] == 'Đã ký') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Hợp đồng đang có hiệu lực pháp lý, tuyệt đối không được xóa!'), 
        backgroundColor: Colors.orange
      ));
      return;
    }

    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa hợp đồng này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa', style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (!confirm) return;

    try {
      final response = await http.delete(Uri.parse('http://10.0.2.2:5137/api/HopDong/${widget.maHopDong}'));
      if (response.statusCode == 200 || response.statusCode == 204) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa hợp đồng'), backgroundColor: Colors.green));
          Navigator.pop(context, true); // Pop về danh sách và báo hiệu reload
        }
      } else {
        throw Exception("Lỗi khóa ngoại");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red));
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "N/A";
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(dateStr));
    } catch (_) { return "N/A"; }
  }

  String _formatCurrency(dynamic number) {
    if (number == null) return "0đ";
    return "${NumberFormat("#,##0", "vi_VN").format(number)}đ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.deepPurple, size: 20),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text('HD-2026-00${widget.maHopDong}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.deepPurple))
          : _contractData == null
              ? const Center(child: Text("Không tìm thấy dữ liệu hợp đồng"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // THÔNG TIN TRẠNG THÁI
                      _buildSectionTitle('Trạng Thái'),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                        child: Text(
                          _contractData!['trangThai'] ?? "N/A",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _contractData!['trangThai'] == 'Đang hiệu lực' ? Colors.green : Colors.orange),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // THÔNG TIN KHÁCH & PHÒNG
                      _buildSectionTitle('Bên Thuê (Khách)'),
                      _buildInfoCard([
                        _buildInfoRow('Họ tên:', _contractData!['tenKhach'] ?? "N/A"),
                        _buildInfoRow('SĐT:', _contractData!['sdt'] ?? "N/A"),
                        _buildInfoRow('CCCD:', _contractData!['cccd'] ?? "N/A"),
                        const Divider(),
                        _buildInfoRow('Phòng:', 'Phòng ${_contractData!['soPhong']} - ${_contractData!['tenCoSo']}'),
                      ]),
                      const SizedBox(height: 20),

                      // THÔNG TIN TÀI CHÍNH & THỜI HẠN
                      _buildSectionTitle('Điều Khoản Cơ Bản'),
                      _buildInfoCard([
                        _buildInfoRow('Giá thuê:', _formatCurrency(_contractData!['giaThue'])),
                        _buildInfoRow('Tiền cọc:', _formatCurrency(_contractData!['tienCoc'])),
                        const Divider(),
                        _buildInfoRow('Ngày bắt đầu:', _formatDate(_contractData!['ngayBatDau'])),
                        _buildInfoRow('Ngày kết thúc:', _formatDate(_contractData!['ngayKetThuc'])),
                      ]),
                      const SizedBox(height: 20),

                      // MINH CHỨNG CHỮ KÝ (NẾU CÓ)
                      if (_contractData!['urlChuKySupabase'] != null && _contractData!['urlChuKySupabase'].toString().isNotEmpty) ...[
                        _buildSectionTitle('Minh Chứng Ký Số'),
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _contractData!['urlChuKySupabase'],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Center(child: Text("Lỗi tải ảnh minh chứng")),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
      // THANH CÔNG CỤ XỬ LÝ (SỬA / XÓA / GIA HẠN) BÊN TRONG CHI TIẾT
      bottomNavigationBar: _isLoading || _contractData == null
          ? null
          : Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // NÚT GIA HẠN (LUÔN HIỂN THỊ, NHƯNG DISABLE NẾU KHÔNG PHẢI HỢP ĐỒNG SẮP HẾT HOẶC ĐÃ HẾT)
                  ElevatedButton(
                    onPressed: _isContractExpiredOrNearExpiry() ? _handleGiaHan : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isContractExpiredOrNearExpiry() ? Colors.blue : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: const Size(double.infinity, 0),
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: Text(
                      _getGiaHanButtonStatus(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isContractExpiredOrNearExpiry() ? Colors.white : Colors.grey.shade500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // NÚT EDIT VÀ XÓA
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _handleDelete,
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text('Xóa bỏ', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), side: const BorderSide(color: Colors.red)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _handleEdit,
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text('Sửa HĐ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.deepPurple, padding: const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 13)),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          Flexible(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}