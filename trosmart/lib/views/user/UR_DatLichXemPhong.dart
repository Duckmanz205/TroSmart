import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../shared/app_theme.dart';
import '../../views/user/UR_HoanTatDatLich.dart';

class UrDatLichXemPhong extends StatefulWidget {
  final int? maPhong;    // Nhận từ trang Chi tiết phòng xem
  final int maKhach;     // Nhận từ tài khoản đang đăng nhập (Ví dụ: khach1 là 1)
  final String soPhong;  // Tên hiển thị phòng (Ví dụ: "A101")
  final String tenCoSo;  // Tên cơ sở trọ (Ví dụ: "KTX Sinh Viên A")

  const UrDatLichXemPhong({
    super.key,
    this.maPhong,
    required this.maKhach,
    this.soPhong = "Chưa chọn",
    this.tenCoSo = "Chưa rõ cơ sở",
  });

  @override
  State<UrDatLichXemPhong> createState() => _UrDatLichXemPhongState();
}

class _UrDatLichXemPhongState extends State<UrDatLichXemPhong> {
  final _formKey = GlobalKey<FormState>();
  
  // Các bộ điều khiển Input dữ liệu
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // Biến lưu trạng thái thời gian chọn động
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  // Danh sách lịch hẹn động bốc từ DB lên
  List<dynamic> _appointments = [];
  bool _isLoadingForm = false;
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    //  KHỞI ĐỘNG LUỒNG ĐỘNG: Gọi đồng thời dữ liệu Profile Khách và Lịch sử từ Server
    _fetchThongTinKhach();
    _fetchLichSuHen();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  //  LẤY THÔNG TIN TÀI KHOẢN ĐANG ĐĂNG NHẬP (LẤY TÊN + SĐT TỪ DATABASE)
  Future<void> _fetchThongTinKhach() async {
    try {
      // Gọi lên API lấy thông tin chi tiết của Khách thuê theo ID (Kiểm tra lại đúng tên Controller C# của nhóm nhé)
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5137/api/KhachThue/${widget.maKhach}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Điền dữ liệu bốc từ DB đổ thẳng vô Form. Người dùng vẫn xóa đi nhập lại thoải mái.
          _nameController.text = data['hoTenKhach'] ?? data['hoTen'] ?? "";
          _phoneController.text = data['sdtKhach'] ?? data['sdt'] ?? "";
        });
      }
    } catch (e) {
      debugPrint("Lỗi không lấy được profile Khách thuê từ DB: $e");
    }
  }

 
  Future<void> _fetchLichSuHen() async {
    try {
      setState(() => _isLoadingHistory = true);
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5137/api/LichHen/lich-su/${widget.maKhach}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _appointments = jsonDecode(response.body);
          _isLoadingHistory = false;
        });
      } else {
        setState(() => _isLoadingHistory = false);
      }
    } catch (e) {
      setState(() => _isLoadingHistory = false);
      debugPrint("Lỗi không lấy được lịch sử đặt lịch: $e");
    }
  }

  //  GỬI DỮ LIỆU ĐẶT LỊCH LÊN BACKEND C#
  Future<void> _handleConfirmBooking() async {
    if (widget.maPhong == null || widget.maPhong == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn một phòng cụ thể để đặt lịch!'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoadingForm = true);

    // Hợp nhất ngày và giờ đã chọn thành cấu trúc DateTime chuẩn
    final DateTime targetDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    //  BODY REQUEST CHUẨN: Đồng bộ với cấu trúc [JsonIgnore] bọc dưới Backend C#
    final Map<String, dynamic> requestBody = {
      "maKhach": widget.maKhach,
      "hoTenKhach": _nameController.text.trim(),
      "sdtKhach": _phoneController.text.trim(), // Trường chuẩn, bỏ biến trùng SDTKhach phụ gây lỗi 500
      "maPhong": widget.maPhong,
      "thoiGianHen": targetDateTime.toIso8601String(),
      "ghiChu": _noteController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5137/api/LichHen'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Làm sạch ghi chú sau khi đặt thành công
        _noteController.clear();
        _fetchLichSuHen(); // Refresh lại danh sách lịch hẹn hiển thị phía dưới

        // Chuyển sang trang hoàn tất đặt lịch phân hệ của mình
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UrHoanTatDatLich(
                maKhach: widget.maKhach,
                soPhong: widget.soPhong,
                tenCoSo: widget.tenCoSo,
                thoiGianHenFormatted: "${_selectedTime.format(context)} - ${DateFormat('dd/MM/yyyy').format(_selectedDate)}",
              ),
            ),
          );
        }
      } else {
        throw Exception('Server phản hồi mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đặt lịch thất bại: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingForm = false);
    }
  }

  // HÀM CHỌN NGÀY ĐỘNG
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  // HÀM CHỌN GIỜ ĐỘNG
  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  // ĐỊNH MÀU SẮC TRẠNG THÁI THEO CONFIG
  Color _getStatusColor(String status) {
    switch (status) {
      case "CHỜ XÁC NHẬN": return const Color(0xFFD97706);
      case "ĐÃ XÁC NHẬN": return const Color(0xFF2563EB);
      case "ĐÃ XEM": return const Color(0xFF059669);
      case "ĐÃ HUỶ": return const Color(0xFF64748B);
      default: return Colors.grey;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case "CHỜ XÁC NHẬN": return const Color(0xFFFEF3C7);
      case "ĐÃ XÁC NHẬN": return const Color(0xFFDBEAFE);
      case "ĐÃ XEM": return const Color(0xFFD1FAE5);
      case "ĐÃ HUỶ": return const Color(0xFFF1F5F9);
      default: return const Color(0xFFF1F5F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgSlate,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      
                      // --- PHẦN 1: ĐẶT LỊCH MỚI ---
                      _buildSectionTitle(Icons.calendar_today_outlined, 'Đặt lịch mới'),
                      const SizedBox(height: 16),
                      _buildRoomPreviewCard(),
                      const SizedBox(height: 20),
                      
                      _buildInputField('Họ và tên', Icons.person_outline, 'Nhập họ tên của bạn', controller: _nameController),
                      _buildInputField('Số điện thoại', Icons.phone_outlined, '090 123 4567', controller: _phoneController, isPhone: true),
                      
                      // Ô Ngày xem (Click để mở Calendar)
                      _buildClickableField('Ngày xem', Icons.calendar_month_outlined, DateFormat('dd/MM/yyyy').format(_selectedDate), onTap: _pickDate),
                      
                      // Ô Khung giờ (Click để mở TimePicker)
                      _buildClickableField('Khung giờ', Icons.access_time_outlined, _selectedTime.format(context), isDropdown: true, onTap: _pickTime),
                      
                      _buildNoteField(),
                      const SizedBox(height: 24),
                      
                      _isLoadingForm 
                          ? const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(color: AppTheme.deepPurple)))
                          : _buildConfirmButton(context),

                      const SizedBox(height: 32),

                      // --- PHẦN 2: LỊCH HẸN CỦA BẠN ---
                      _buildSectionTitle(Icons.list_alt_outlined, 'Lịch hẹn của bạn', badge: _appointments.length.toString()),
                      const SizedBox(height: 16),
                      
                      _isLoadingHistory
                          ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator(color: AppTheme.deepPurple)))
                          : _appointments.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(child: Text('Ông chưa có lịch hẹn nào dưới DB cả.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _appointments.length,
                                  itemBuilder: (context, index) {
                                    final item = _appointments[index];
                                    DateTime thoiGian = DateTime.parse(item['thoiGianHen']);
                                    String upperStatus = item['trangThai'].toString().toUpperCase();
                                    bool isCanceled = upperStatus == "ĐÃ HUỶ";

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      key: ValueKey(item['maLichHen']),
                                      child: _buildAppointmentCard(
                                        title: 'Phòng ${item['soPhong']}',
                                        subtitle: item['tenCoSo'] ?? 'Chưa rõ cơ sở',
                                        date: DateFormat('dd/MM/yyyy').format(thoiGian),
                                        time: DateFormat('HH:mm').format(thoiGian),
                                        status: upperStatus,
                                        statusColor: _getStatusColor(upperStatus),
                                        statusBg: _getStatusBgColor(upperStatus),
                                        hasCancel: upperStatus == "CHỜ XÁC NHẬN" || upperStatus == "ĐÃ XÁC NHẬN",
                                        opacity: isCanceled ? 0.6 : 1.0,
                                      ),
                                    );
                                  },
                                ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS THÀNH PHẦN ---

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, size: 18),
              ),
              const SizedBox(width: 8),
              Text('Đặt lịch xem phòng', 
                style: AppTheme.titleMd.copyWith(color: AppTheme.deepPurple, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Sắp xếp thời gian đến xem trực tiếp', 
            style: AppTheme.bodySm.copyWith(color: AppTheme.textSecondary, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, {String? badge}) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.deepPurple, size: 20),
        const SizedBox(width: 8),
        Text(title, style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.bold)),
        const Spacer(),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(12)),
            child: Text(badge, style: AppTheme.bodySm.copyWith(fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Widget _buildRoomPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: AppTheme.bgGray200, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.bed_outlined, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phòng số: ${widget.soPhong}', style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.bold)),
              Text(widget.tenCoSo, style: AppTheme.bodySm.copyWith(color: AppTheme.textSecondary)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInputField(String label, IconData icon, String hint, {required TextEditingController controller, bool isPhone = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(children: [Icon(icon, size: 14, color: AppTheme.textSecondary), const SizedBox(width: 4), Text(label, style: AppTheme.bodySm.copyWith(fontWeight: FontWeight.bold))]),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
          style: AppTheme.bodyMd,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTheme.bodyMd.copyWith(color: AppTheme.textSecondary.withOpacity(0.6)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.bgGray200), borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppTheme.deepPurple), borderRadius: BorderRadius.circular(12)),
            errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(12)),
            focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(12)),
          ),
          validator: (v) => v == null || v.trim().isEmpty ? 'Trường này không được bỏ trống nha Thái' : null,
        ),
      ],
    );
  }

  Widget _buildClickableField(String label, IconData icon, String value, {bool isDropdown = false, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(children: [Icon(icon, size: 14, color: AppTheme.textSecondary), const SizedBox(width: 4), Text(label, style: AppTheme.bodySm.copyWith(fontWeight: FontWeight.bold))]),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppTheme.bgGray200), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: AppTheme.bodyMd.copyWith(color: Colors.black)),
                if (isDropdown) const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(children: [Icon(Icons.chat_bubble_outline, size: 14, color: AppTheme.textSecondary), const SizedBox(width: 4), Text('Ghi chú thêm', style: AppTheme.bodySm.copyWith(fontWeight: FontWeight.bold))]),
        const SizedBox(height: 8),
        TextFormField(
          controller: _noteController,
          maxLines: 3,
          style: AppTheme.bodySm,
          decoration: InputDecoration(
            hintText: 'Ví dụ: Tôi muốn xem thêm phòng ở tầng cao...',
            hintStyle: AppTheme.bodySm.copyWith(color: AppTheme.textSecondary.withOpacity(0.6)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.bgGray200), borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppTheme.deepPurple), borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: _handleConfirmBooking,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Xác nhận đặt lịch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard({
    required String title, required String subtitle, required String date, 
    String? time, required String status, required Color statusColor, 
    required Color statusBg, required bool hasCancel, double opacity = 1.0
  }) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: AppTheme.bodySm.copyWith(color: AppTheme.textSecondary)),
                ]),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
                  child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(children: [
              Icon(Icons.calendar_today, size: 13, color: AppTheme.textSecondary), const SizedBox(width: 4), Text(date, style: AppTheme.bodySm),
              if (time != null) ...[
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 13, color: AppTheme.textSecondary), const SizedBox(width: 4), Text(time, style: AppTheme.bodySm),
              ]
            ]),
            if (hasCancel) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight, 
                child: GestureDetector(
                  onTap: () {
                    // Xử lý sự kiện hủy nếu cần thiết
                  },
                  child: const Text('✕ Hủy lịch', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold))
                )
              ),
            ]
          ],
        ),
      ),
    );
  }
}