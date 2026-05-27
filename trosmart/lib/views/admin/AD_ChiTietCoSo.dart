import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../logic/admin/co_so_service.dart';
import '../../models/admin/co_so_detail_model.dart';
import 'AD_XoaCoSo.dart';
import 'AD_SuaCoSo.dart';
import 'AD_ChiTietPhong.dart';
import 'phong_management_view.dart';

class CoSoDetailView extends StatefulWidget {
  final int maCoSo;

  const CoSoDetailView({
    super.key,
    required this.maCoSo,
  });

  @override
  State<CoSoDetailView> createState() => _CoSoDetailViewState();
}

class _CoSoDetailViewState extends State<CoSoDetailView> {
  final CoSoService _service = CoSoService();
  late Future<CoSoDetailModel> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = _service.getDetail(widget.maCoSo);
  }

  Future<void> _reload() async {
    setState(() {
      _futureDetail = _service.getDetail(widget.maCoSo);
    });
  }

  Future<void> _openPhongDetail(
    CoSoDetailModel coSo,
    PhongMiniModel room,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhongDetailView(
          maPhong: room.maPhong,
          tenCoSo: coSo.tenCoSo,
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      _reload();
    }
  }

  Future<void> _openPhongManagement(CoSoDetailModel coSo) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhongManagementView(
          maCoSo: coSo.maCoSo,
          tenCoSo: coSo.tenCoSo,
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: SafeArea(
        child: FutureBuilder<CoSoDetailModel>(
          future: _futureDetail,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF8A36B0),
                ),
              );
            }

            if (snapshot.hasError) {
              return _buildError(snapshot.error.toString());
            }

            if (!snapshot.hasData) {
              return _buildError('Không có dữ liệu cơ sở');
            }

            final coSo = snapshot.data!;

            return RefreshIndicator(
              onRefresh: _reload,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(coSo),
                    const SizedBox(height: 18),
                    _buildFacilityImageBox(coSo),
                    const SizedBox(height: 18),
                    _buildStatsCard(coSo),
                    const SizedBox(height: 18),
                    _sectionTitle('THÔNG TIN QUẢN LÝ'),
                    const SizedBox(height: 10),
                    _buildManagerCard(coSo),
                    const SizedBox(height: 18),
                    _sectionTitle('TIỆN ÍCH CƠ SỞ'),
                    const SizedBox(height: 10),
                    _buildTienIchBox(coSo),
                    const SizedBox(height: 18),
                    _buildRoomTitle(coSo),
                    const SizedBox(height: 10),
                    _buildRoomList(coSo),
                    const SizedBox(height: 18),
                    _sectionTitle('VỊ TRÍ TRÊN BẢN ĐỒ'),
                    const SizedBox(height: 10),
                    _buildMapBox(coSo),
                    const SizedBox(height: 18),
                    _buildActionButtons(coSo),
                    const SizedBox(height: 22),
                    _buildViewRoomsButton(coSo),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(CoSoDetailModel coSo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8E64B7),
            Color(0xFFA47BC4),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 6),
                Text(
                  'Quay lại',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            coSo.tenCoSo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            coSo.diaChi,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageByPath(
    String? path, {
    required Widget placeholder,
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
  }) {
    if (path == null || path.trim().isEmpty) {
      return placeholder;
    }

    final cleanPath = path.trim();

    if (cleanPath.startsWith('assets/')) {
      return Image.asset(
        cleanPath,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return placeholder;
        },
      );
    }

    return Image.network(
      cleanPath,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return placeholder;
      },
    );
  }

  Widget _buildFacilityImageBox(CoSoDetailModel coSo) {
    return Container(
      width: double.infinity,
      height: 190,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black.withOpacity(0.06),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildImageByPath(
            coSo.hinhAnhCoSo,
            height: 190,
            width: double.infinity,
            placeholder: _facilityPlaceholder(),
          ),
          _imageLabel('Ảnh cơ sở'),
        ],
      ),
    );
  }

  Widget _facilityPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF0E9F8),
            Color(0xFFE1D2F3),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.add_photo_alternate_outlined,
          color: Color(0xFF8A36B0),
          size: 42,
        ),
      ),
    );
  }

  Widget _imageLabel(String text) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.50),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(CoSoDetailModel coSo) {
    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: Colors.black.withOpacity(0.07),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _statItem(
              label: 'TỔNG PHÒNG',
              value: '${coSo.tongPhong}',
              valueColor: const Color(0xFF161622),
            ),
          ),
          _divider(),
          Expanded(
            child: _statItem(
              label: 'TRỐNG',
              value: '${coSo.phongTrong}'.padLeft(2, '0'),
              valueColor: const Color(0xFF2DBE60),
            ),
          ),
          _divider(),
          Expanded(
            child: _statItem(
              label: 'ĐÃ THUÊ',
              value: '${coSo.daThue}',
              valueColor: const Color(0xFF7B2CBF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black.withOpacity(0.32),
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 42,
      color: Colors.black.withOpacity(0.06),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF7B2CBF),
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildManagerCard(CoSoDetailModel coSo) {
    final managerName = (coSo.tenQuanLy != null && coSo.tenQuanLy!.isNotEmpty)
        ? coSo.tenQuanLy!
        : (coSo.maQuanLy == null
            ? 'Chưa gán quản lý'
            : 'Mã quản lý: ${coSo.maQuanLy}');

    final phone =
        (coSo.soDienThoaiQuanLy != null && coSo.soDienThoaiQuanLy!.isNotEmpty)
            ? coSo.soDienThoaiQuanLy!
            : 'Chưa có dữ liệu';

    final email =
        (coSo.emailQuanLy != null && coSo.emailQuanLy!.isNotEmpty)
            ? coSo.emailQuanLy!
            : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFF8A36B0).withOpacity(0.35),
        ),
      ),
      child: Column(
        children: [
          _infoRow(
            label: 'Loại hình:',
            value: coSo.loaiHinh.isEmpty ? 'Nhà trọ tự quản' : coSo.loaiHinh,
          ),
          const SizedBox(height: 14),
          _infoRow(
            label: 'Quản lý:',
            value: managerName,
          ),
          const SizedBox(height: 14),
          _infoRow(
            label: 'Liên hệ:',
            value: phone,
            valueColor: const Color(0xFF7B2CBF),
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 14),
            _infoRow(
              label: 'Email:',
              value: email,
              valueColor: const Color(0xFF7B2CBF),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTienIchBox(CoSoDetailModel coSo) {
    if (coSo.tienIches.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black.withOpacity(0.05),
          ),
        ),
        child: Text(
          'Cơ sở này chưa có tiện ích',
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: coSo.tienIches.map((item) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF2E9FA),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF8A36B0).withOpacity(0.18),
              ),
            ),
            child: Text(
              item.tenTienIch,
              style: const TextStyle(
                color: Color(0xFF7B2CBF),
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _infoRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 86,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black.withOpacity(0.48),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor ?? const Color(0xFF191622),
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomTitle(CoSoDetailModel coSo) {
    final total = coSo.phongs.length;
    final preview = total > 4 ? ' • Hiển thị 4 phòng đầu' : '';

    return Row(
      children: [
        Expanded(
          child: Text(
            'DANH SÁCH PHÒNG ($total)$preview',
            style: const TextStyle(
              color: Color(0xFF7B2CBF),
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const Icon(
          Icons.meeting_room_outlined,
          size: 18,
          color: Color(0xFF7B2CBF),
        ),
      ],
    );
  }

  Widget _buildRoomList(CoSoDetailModel coSo) {
    final rooms = coSo.phongs.take(4).toList();

    if (rooms.isEmpty) {
      return _emptyRoomBox();
    }

    return Column(
      children: rooms.map((room) {
        return _buildRoomPreviewCard(coSo, room);
      }).toList(),
    );
  }

  Widget _buildRoomPreviewCard(CoSoDetailModel coSo, PhongMiniModel room) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _openPhongDetail(coSo, room),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black.withOpacity(0.06),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.025),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: _roomMiniBgColor(room),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                room.coNguoi
                    ? Icons.person_rounded
                    : room.trong
                        ? Icons.meeting_room_outlined
                        : Icons.build_rounded,
                color: _roomMiniColor(room),
                size: 25,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phòng ${room.soPhong}',
                    style: const TextStyle(
                      color: Color(0xFF191622),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Chạm để xem chi tiết phòng',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.45),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            _roomStatusBadge(room),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF7B2CBF),
            ),
          ],
        ),
      ),
    );
  }

  Color _roomMiniColor(PhongMiniModel room) {
    if (room.coNguoi) return const Color(0xFF7B2CBF);
    if (room.trong) return const Color(0xFF2DBE60);
    return const Color(0xFFFF4D4F);
  }

  Color _roomMiniBgColor(PhongMiniModel room) {
    if (room.coNguoi) return const Color(0xFFF2E9FA);
    if (room.trong) return const Color(0xFFE9F8ED);
    return const Color(0xFFFFE3E3);
  }

  Widget _emptyRoomBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        'Cơ sở này chưa có phòng',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black.withOpacity(0.45),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _roomStatusBadge(PhongMiniModel room) {
    late final Color bgColor;
    late final Color textColor;
    late final String text;

    if (room.coNguoi) {
      bgColor = const Color(0xFFF2E9FA);
      textColor = const Color(0xFF7B2CBF);
      text = 'Đang thuê';
    } else if (room.trong) {
      bgColor = const Color(0xFFE9F8ED);
      textColor = const Color(0xFF2DBE60);
      text = 'Trống';
    } else {
      bgColor = const Color(0xFFFFE3E3);
      textColor = const Color(0xFFFF4D4F);
      text = 'Bảo trì';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildMapBox(CoSoDetailModel coSo) {
    if (coSo.latitude == null || coSo.longitude == null) {
      return _mapPlaceholder();
    }

    final point = LatLng(coSo.latitude!, coSo.longitude!);

    return Container(
      height: 220,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8F6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: point,
          initialZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: point,
                width: 44,
                height: 44,
                child: const Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFF8A36B0),
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mapPlaceholder() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEAE7F8),
            Color(0xFFDCD5F4),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map_outlined,
            color: Color(0xFF8A36B0),
            size: 34,
          ),
          SizedBox(height: 10),
          Text(
            'Chưa có tọa độ bản đồ',
            style: TextStyle(
              color: Color(0xFF7B2CBF),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(CoSoDetailModel coSo) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditCoSoView(
                    coSo: coSo,
                  ),
                ),
              );

              if (!mounted) return;
              if (result == true) {
                _reload();
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF7B2CBF),
              side: const BorderSide(
                color: Color(0xFF7B2CBF),
                width: 1.4,
              ),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: const Text(
              'Chỉnh sửa',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeleteCoSoView(
                    coSo: coSo,
                  ),
                ),
              );

              if (!mounted) return;
              if (result == true) {
                Navigator.pop(context, true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4D4F),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: const Text(
              'Xóa',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewRoomsButton(CoSoDetailModel coSo) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () => _openPhongManagement(coSo),
        icon: const Icon(Icons.meeting_room_rounded, size: 18),
        label: const Text(
          'Xem danh sách phòng',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7430A3),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 42,
              color: Color(0xFF8A36B0),
            ),
            const SizedBox(height: 12),
            const Text(
              'Không thể tải chi tiết cơ sở',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black.withOpacity(0.45),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _reload,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8A36B0),
                foregroundColor: Colors.white,
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}