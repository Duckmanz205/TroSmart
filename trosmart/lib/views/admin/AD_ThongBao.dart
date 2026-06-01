import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/app_colors.dart';
import '../../widgets/common/admin/custom_app_bar.dart';

import '../../models/thong_bao.dart';
import '../../services/thong_bao_service.dart';

class AD_ThongBao extends StatefulWidget {
  const AD_ThongBao({super.key});

  @override
  State<AD_ThongBao> createState() => _AD_ThongBaoState();
}

class _AD_ThongBaoState extends State<AD_ThongBao> {
  late Future<List<ThongBao>> _futureThongBao;

  @override
  void initState() {
    super.initState();
    _loadThongBaos();
  }

  void _loadThongBaos() {
    setState(() {
      _futureThongBao = ThongBaoService().getAllThongBao();
    });
  }

  void _showCreateDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String targetType = 'Cá nhân';
    int? selectedMaKhach;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Tạo thông báo mới', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: targetType,
                      decoration: const InputDecoration(labelText: 'Gửi đến', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Cá nhân', child: Text('Cá nhân (Một phòng)')),
                        DropdownMenuItem(value: 'Cả cơ sở', child: Text('Cả cơ sở (Tất cả phòng)')),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => targetType = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Tiêu đề', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: contentController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Nội dung', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    if (targetType == 'Cá nhân') ...[
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: ThongBaoService().getDanhSachKhach(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Text('Không tải được danh sách khách thuê.', style: TextStyle(color: Colors.red));
                          }
                          final List<Map<String, dynamic>> khachList = snapshot.data!;
                          
                          // Mặc định chọn người đầu tiên
                          if (selectedMaKhach == null || !khachList.any((k) => k['maKhach'] == selectedMaKhach)) {
                            // Cần delay setState nếu thực hiện ngay trong build phase
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                selectedMaKhach = khachList.first['maKhach'];
                              });
                            });
                          }

                          return DropdownButtonFormField<int>(
                            value: selectedMaKhach ?? khachList.first['maKhach'],
                            isExpanded: true,
                            decoration: const InputDecoration(labelText: 'Chọn Khách / Phòng', border: OutlineInputBorder()),
                            items: khachList.map((khach) {
                              return DropdownMenuItem<int>(
                                value: khach['maKhach'],
                                child: Text('${khach['hoTen']} - P.${khach['soPhong']}'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) setState(() => selectedMaKhach = value);
                            },
                          );
                        },
                      ),
                    ] else ...[
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Chọn cơ sở', border: OutlineInputBorder()),
                        items: const [
                          DropdownMenuItem(value: '1', child: Text('Cơ sở 1')),
                          DropdownMenuItem(value: '2', child: Text('Cơ sở 2')),
                        ],
                        onChanged: (value) {},
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D28D9)),
                  onPressed: () async {
                    if (titleController.text.isEmpty || contentController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng nhập đủ thông tin!')),
                      );
                      return;
                    }
                    
                    if (targetType == 'Cá nhân' && selectedMaKhach == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng đợi load danh sách khách!')),
                      );
                      return;
                    }

                    // If "Cả cơ sở", logic to send to all would go here.
                    final newTb = ThongBao(
                      maThongBao: 0,
                      maKhach: targetType == 'Cá nhân' ? selectedMaKhach! : 1,
                      tieuDe: titleController.text,
                      noiDung: contentController.text,
                      loaiThongBao: 'Hệ thống',
                      daDoc: false,
                    );

                    try {
                      final success = await ThongBaoService().sendThongBao(newTb);
                      if (success) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã gửi thông báo thành công!')),
                        );
                        _loadThongBaos();
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi: $e')),
                      );
                    }
                  },
                  child: const Text('Gửi', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thông báo',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Quản lý và gửi thông báo cho khách thuê',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showCreateDialog,
                    icon: const Icon(Icons.add, size: 20, color: Colors.white,),
                    label: Text(
                      'Tạo mới', 
                      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D28D9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            
            // Search and Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm thông báo...',
                          hintStyle: GoogleFonts.inter(color: Colors.grey),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Icon(Icons.filter_list, color: Color(0xFF6D28D9)),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            Expanded(
              child: FutureBuilder<List<ThongBao>>(
                future: _futureThongBao,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Không có thông báo nào.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final tb = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildNotificationCard(
                          title: tb.tieuDe,
                          content: tb.noiDung ?? '',
                          time: tb.ngayGui != null ? '${tb.ngayGui!.hour}:${tb.ngayGui!.minute}, ${tb.ngayGui!.day}/${tb.ngayGui!.month}/${tb.ngayGui!.year}' : '',
                          type: 'Thông báo',
                          typeColor: Colors.blue,
                          status: tb.daDoc ? 'Đã xem' : 'Chưa xem',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String content,
    required String time,
    required String type,
    required Color typeColor,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  type,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: typeColor,
                  ),
                ),
              ),
              Text(
                status,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: status == 'Đã gửi' ? Colors.green : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
