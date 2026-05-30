import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/app_colors.dart';

import '../../widgets/admin/incident_management_widgets.dart';

import '../../models/su_co.dart';
import '../../services/su_co_service.dart';

class AD_SuCo extends StatefulWidget {
  const AD_SuCo({super.key});

  @override
  State<AD_SuCo> createState() => _AD_SuCoState();
}

class _AD_SuCoState extends State<AD_SuCo> {
  late Future<List<SuCo>> _futureSuCo;

  @override
  void initState() {
    super.initState();
    _loadSuCos();
  }

  void _loadSuCos() {
    setState(() {
      _futureSuCo = SuCoService().getAllSuCo();
    });
  }

  Future<void> _updateStatus(int id, String status) async {
    try {
      final success = await SuCoService().updateSuCoStatus(id, status);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã cập nhật trạng thái thành: $status')),
        );
        _loadSuCos(); // Tải lại danh sách
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thất bại')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quản lý sự cố',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Theo dõi và xử lý yêu cầu sửa chữa từ khách thuê',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              const IncidentStatsGrid(),
              const SizedBox(height: 24),
              const IncidentSearchAndFilter(),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách yêu cầu',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  Text(
                    '67 sự cố',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Danh sách thẻ từ API
              FutureBuilder<List<SuCo>>(
                future: _futureSuCo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Không có sự cố nào.'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final suCo = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: IncidentCard(
                          code: 'SC${suCo.maSuCo.toString().padLeft(3, '0')}',
                          title: suCo.tieuDe,
                          status: (suCo.trangThai?.toUpperCase()) ?? 'CHỜ XỬ LÝ',
                          type: 'KHÁC', // Dữ liệu mẫu vì model chưa có phân loại
                          room: 'Phòng ${suCo.maPhong}',
                          requester: 'Khách ${suCo.maKhach}',
                          date: suCo.ngayBao != null ? '${suCo.ngayBao!.day}/${suCo.ngayBao!.month}/${suCo.ngayBao!.year}' : '',
                          imagesCount: suCo.hinhAnh != null ? 1 : 0,
                          isUrgent: suCo.trangThai == 'Đang xử lý',
                          bgColor: AppColors.incidentBg1,
                          onAccept: () => _updateStatus(suCo.maSuCo, 'Đang xử lý'),
                          onReject: () => _updateStatus(suCo.maSuCo, 'Từ chối'),
                          onComplete: () => _updateStatus(suCo.maSuCo, 'Đã hoàn thành'),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 100), // Padding cho bottom nav
            ],
          ),
        ),
      ),
    );
  }
}
