import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/app_colors.dart';
import '../../shared/api_constants.dart';
import '../../models/su_co.dart';
import '../../services/su_co_service.dart';
import '../../logic/auth/auth_service.dart';

/// --- TIÊU ĐỀ TRANG VÀ NÚT TẠO YÊU CẦU ---
class ActionHeader extends StatelessWidget {
  const ActionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Báo cáo sự cố',
                style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text('Issue Reporting', style: TextStyle(color: Colors.grey)),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/user/create-issue');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.userPurpleLight, AppColors.userPurple],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.userPurple.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.add, color: Colors.white, size: 20),
                  SizedBox(width: 4),
                  Text(
                    'Tạo yêu cầu',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewRequestForm extends StatefulWidget {
  final VoidCallback? onSubmitSuccess;
  const NewRequestForm({super.key, this.onSubmitSuccess});

  @override
  State<NewRequestForm> createState() => _NewRequestFormState();
}

class _NewRequestFormState extends State<NewRequestForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _isSubmitting = false;

  int? _maKhach;
  int? _maPhong;
  bool _isLoadingInfo = true;

  @override
  void initState() {
    super.initState();
    _loadUserContractInfo();
  }

  Future<void> _loadUserContractInfo() async {
    try {
      final authService = AuthService();
      _maKhach = await authService.getMaKhach();
      if (_maKhach != null) {
        final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/HopDong'));
        if (response.statusCode == 200) {
          final List<dynamic> contracts = jsonDecode(response.body);
          for (var hd in contracts) {
            var dynamicMaKhach = hd['MaKhach'] ?? hd['maKhach'] ?? hd['MAKHACH'] ?? hd['ma_khach'];
            if (dynamicMaKhach != null && dynamicMaKhach.toString() == _maKhach.toString()) {
              var rawMaPhong = hd['MaPhong'] ?? hd['maPhong'] ?? 0;
              _maPhong = int.tryParse(rawMaPhong.toString()) ?? 0;
              break;
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Lỗi tải thông tin phòng từ hợp đồng: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingInfo = false;
        });
      }
    }
  }

  Future<void> _submitRequest() async {
    if (_maKhach == null || _maPhong == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy thông tin phòng thuê của bạn để báo cáo sự cố!')),
      );
      return;
    }

    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ tiêu đề và mô tả sự cố')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final suCo = SuCo(
        maSuCo: 0, // Backend tự tạo
        maPhong: _maPhong!,
        maKhach: _maKhach!,
        tieuDe: _titleController.text,
        moTa: _descController.text,
      );

      final success = await SuCoService().sendSuCo(suCo);
      if (success) {
        _titleController.clear();
        _descController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gửi báo cáo thành công!')),
        );
        if (widget.onSubmitSuccess != null) {
          widget.onSubmitSuccess!();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.userBorder),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.userTealLightBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star, color: AppColors.tealDark, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New Request',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Text('Yêu cầu mới',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildLabel('MÔ TẢ SỰ CỐ'),
          _buildInput('VD: đèn trong nhà tắm bị hỏng', _titleController),
          const SizedBox(height: 20),
          _buildLabel('CHI TIẾT'),
          _buildInput('Mô tả chi tiết hơn...', _descController, maxLines: 4),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.camera_alt_outlined, size: 18),
                label: const Text('Chụp hình'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.tealDark,
                  side: const BorderSide(color: AppColors.userTeal),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      _titleController.clear();
                      _descController.clear();
                    },
                    child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.userPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: _isSubmitting 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Gửi'),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
      ),
    );
  }

  Widget _buildInput(String hint, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        filled: true,
        fillColor: AppColors.userBgLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}

/// --- VẠCH PHÂN CÁCH LỊCH SỬ ---
class HistoryDivider extends StatelessWidget {
  const HistoryDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.userBorder,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Lịch sử sự cố',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class IssueHistoryList extends StatefulWidget {
  const IssueHistoryList({super.key});

  @override
  State<IssueHistoryList> createState() => _IssueHistoryListState();
}

class _IssueHistoryListState extends State<IssueHistoryList> {
  List<SuCo>? _suCos;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserSuCos();
  }

  Future<void> _loadUserSuCos() async {
    try {
      final authService = AuthService();
      final maKhach = await authService.getMaKhach();
      if (maKhach != null) {
        final list = await SuCoService().getSuCoForUser(maKhach);
        if (mounted) {
          setState(() {
            _suCos = list;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _suCos = [];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (_errorMessage != null) {
      return Center(child: Text('Lỗi tải dữ liệu: $_errorMessage'));
    } else if (_suCos == null || _suCos!.isEmpty) {
      return const Center(child: Text('Bạn chưa báo cáo sự cố nào.'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _suCos!.map((suCo) {
          final isCompleted = (suCo.trangThai ?? '').toLowerCase() == 'đã hoàn thành';
          final color = isCompleted ? AppColors.tealDark : Colors.blue;
          final dateStr = suCo.ngayBao != null ? '${suCo.ngayBao!.day}/${suCo.ngayBao!.month}/${suCo.ngayBao!.year}' : '';
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: HistoryCard(
              title: suCo.tieuDe,
              date: dateStr,
              status: suCo.trangThai ?? 'Chờ xử lý',
              statusColor: color,
              child: isCompleted ? const CompletedStatusDetails() : const ProcessingStatusDetails(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final Color statusColor;
  final Widget child;

  const HistoryCard({
    super.key,
    required this.title,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.userBorder),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 4)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(status == 'Hoàn thành' ? Icons.check : Icons.person_outline,
                        size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                          color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class ProcessingStatusDetails extends StatelessWidget {
  const ProcessingStatusDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.userBgLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.userBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nhân viên đang đến...',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  Text('Dự kiến: ~30 phút nữa',
                      style: TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ],
          ),
          const Icon(Icons.more_horiz, color: Colors.grey),
        ],
      ),
    );
  }
}

class CompletedStatusDetails extends StatelessWidget {
  const CompletedStatusDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.userTealBorder.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.userTealBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star, color: AppColors.tealDark, size: 18),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Đánh giá của bạn',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.tealDark)),
                  Text('Cảm ơn bạn đã phản hồi!',
                      style: TextStyle(color: AppColors.userTeal, fontSize: 11)),
                ],
              ),
            ],
          ),
          Row(
            children: List.generate(
                5, (index) => const Icon(Icons.star, color: AppColors.userStarGold, size: 14)),
          )
        ],
      ),
    );
  }
}

class FooterIndicator extends StatelessWidget {
  const FooterIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 40, height: 1, color: Colors.grey.shade200),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'HẾT LỊCH SỬ',
            style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        Container(width: 40, height: 1, color: Colors.grey.shade200),
      ],
    );
  }
}