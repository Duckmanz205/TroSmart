import 'package:flutter/material.dart';

import '../../logic/admin/phong_service.dart';
import '../../models/admin/phong_model.dart';
import 'AD_ThemPhong.dart';
import 'AD_ChiTietPhong.dart';

class PhongManagementView extends StatefulWidget {
  final int maCoSo;
  final String tenCoSo;

  const PhongManagementView({
    super.key,
    required this.maCoSo,
    required this.tenCoSo,
  });

  @override
  State<PhongManagementView> createState() => _PhongManagementViewState();
}

class _PhongManagementViewState extends State<PhongManagementView> {
  final PhongService _service = PhongService();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<PhongModel>> _futurePhongs;

  String _keyword = '';
  String _statusFilter = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _futurePhongs = _service.getByCoSo(widget.maCoSo);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() {
      _futurePhongs = _service.getByCoSo(widget.maCoSo);
    });
  }

  List<PhongModel> _applyFilter(List<PhongModel> list) {
    return list.where((item) {
      final keyword = _keyword.trim().toLowerCase();

      final matchTienIch = item.tienIches.any(
        (x) => x.toLowerCase().contains(keyword),
      );

      final matchKeyword = keyword.isEmpty ||
          item.soPhong.toLowerCase().contains(keyword) ||
          item.trangThai.toLowerCase().contains(keyword) ||
          (item.moTa?.toLowerCase().contains(keyword) ?? false) ||
          (item.tang?.toString().contains(keyword) ?? false) ||
          matchTienIch;

      final matchStatus =
          _statusFilter == 'Tất cả' || item.trangThai == _statusFilter;

      return matchKeyword && matchStatus;
    }).toList();
  }

  int _countStatus(List<PhongModel> list, String status) {
    return list.where((x) => x.trangThai == status).length;
  }

  Future<void> _openAddPhong() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddPhongView(
          maCoSo: widget.maCoSo,
          tenCoSo: widget.tenCoSo,
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      _reload();
    }
  }

  Future<void> _openPhongDetail(PhongModel room) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhongDetailView(
          maPhong: room.maPhong,
          tenCoSo: widget.tenCoSo,
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
        child: FutureBuilder<List<PhongModel>>(
          future: _futurePhongs,
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

            final data = snapshot.data ?? [];
            final filteredData = _applyFilter(data);

            return RefreshIndicator(
              onRefresh: _reload,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBackRow(),
                    const SizedBox(height: 14),
                    _buildOverviewText(),
                    _buildTitle(),
                    const SizedBox(height: 10),
                    _buildSubHeader(data.length),
                    const SizedBox(height: 14),
                    _buildStats(data),
                    const SizedBox(height: 14),
                    _buildFilterChips(),
                    const SizedBox(height: 12),
                    _buildSearchBox(),
                    const SizedBox(height: 14),
                    if (filteredData.isEmpty)
                      _buildEmpty()
                    else
                      _buildRoomGrid(filteredData),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackRow() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xFF191622),
          ),
          SizedBox(width: 6),
          Text(
            'Quay lại',
            style: TextStyle(
              color: Color(0xFF191622),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewText() {
    return const Text(
      'TỔNG QUAN',
      style: TextStyle(
        color: Color(0xFF7B2CBF),
        fontSize: 10,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Quản lý phòng',
      style: TextStyle(
        color: Color(0xFF151521),
        fontSize: 25,
        fontWeight: FontWeight.w900,
        height: 1.05,
      ),
    );
  }

  Widget _buildSubHeader(int total) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${widget.tenCoSo} — $total phòng',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.68),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 38,
          child: ElevatedButton.icon(
            onPressed: _openAddPhong,
            icon: const Icon(
              Icons.add_rounded,
              size: 15,
            ),
            label: const Text(
              'Thêm phòng',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7430A3),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(19),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStats(List<PhongModel> list) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            value: '${_countStatus(list, 'Đang thuê')}',
            label: 'Đang thuê',
            color: const Color(0xFF19D8B3),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            value: '${_countStatus(list, 'Trống')}',
            label: 'Còn trống',
            color: const Color(0xFFF5A623),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            value: '${_countStatus(list, 'Bảo trì')}',
            label: 'Bảo trì',
            color: const Color(0xFFFF4D4F),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF17151F).withValues(alpha: 0.65),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.62),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Tất cả', 'Đang thuê', 'Trống', 'Bảo trì'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final selected = _statusFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _statusFilter = filter;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF7430A3) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF7430A3)
                        : Colors.black.withValues(alpha: 0.22),
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF17151F),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBox() {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _keyword = value;
          });
        },
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Tìm phòng hoặc tiện ích...',
          hintStyle: TextStyle(
            color: Colors.black.withValues(alpha: 0.42),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.black.withValues(alpha: 0.55),
            size: 20,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.black.withValues(alpha: 0.42),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF7430A3),
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomGrid(List<PhongModel> rooms) {
    return GridView.builder(
      itemCount: rooms.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.64,
      ),
      itemBuilder: (context, index) {
        final room = rooms[index];

        return _RoomCard(
          room: room,
          onTap: () => _openPhongDetail(room),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.meeting_room_outlined,
            color: Color(0xFF7430A3),
            size: 40,
          ),
          SizedBox(height: 10),
          Text(
            'Không có phòng phù hợp',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              color: Color(0xFF7430A3),
              size: 44,
            ),
            const SizedBox(height: 12),
            const Text(
              'Không thể tải danh sách phòng',
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
                color: Colors.black.withValues(alpha: 0.48),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _reload,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7430A3),
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

class _RoomCard extends StatelessWidget {
  final PhongModel room;
  final VoidCallback? onTap;

  const _RoomCard({
    required this.room,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(room);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.72),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageBox(statusStyle),
            const SizedBox(height: 10),
            _buildTop(statusStyle),
            const SizedBox(height: 10),
            Text(
              _displayRoomName(room.soPhong),
              style: const TextStyle(
                color: Color(0xFF151521),
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              room.tang != null ? 'Tầng ${room.tang}' : 'Chưa có tầng',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.55),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _buildMetaText(room),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.52),
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildTienIchWrap(),
            const Spacer(),
            Text(
              _formatCurrency(room.giaThue),
              style: TextStyle(
                color: statusStyle.mainColor,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'VNĐ / tháng',
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.48),
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              (room.moTa != null && room.moTa!.trim().isNotEmpty)
                  ? room.moTa!
                  : 'Chưa có mô tả',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.48),
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageBox(_RoomStatusStyle style) {
    final imagePath = room.hinhAnhPhong?.trim();

    return Container(
      height: 86,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: (imagePath != null && imagePath.isNotEmpty)
          ? _buildImage(imagePath)
          : Icon(
              room.baoTri ? Icons.build_rounded : Icons.home_outlined,
              color: style.mainColor,
              size: 28,
            ),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Color(0xFF7430A3),
          ),
        ),
      );
    }

    return Image.network(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Color(0xFF7430A3),
        ),
      ),
    );
  }

  Widget _buildTop(_RoomStatusStyle style) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: style.bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            room.baoTri ? Icons.build_rounded : Icons.meeting_room_outlined,
            color: style.mainColor,
            size: 18,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: style.bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            room.trangThai,
            style: TextStyle(
              color: style.mainColor,
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTienIchWrap() {
    if (room.tienIches.isEmpty) {
      return Text(
        'Chưa có tiện ích',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black.withValues(alpha: 0.42),
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: room.tienIches.take(3).map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFF2E9FA),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF8A36B0).withValues(alpha: 0.18),
            ),
          ),
          child: Text(
            item,
            style: const TextStyle(
              color: Color(0xFF7B2CBF),
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _displayRoomName(String soPhong) {
    final value = soPhong.trim();

    if (value.toLowerCase().startsWith('p.')) {
      return value;
    }

    return 'P.$value';
  }

  String _buildMetaText(PhongModel room) {
    final parts = <String>[];

    if (room.dienTich != null) {
      parts.add('${room.dienTich!.toStringAsFixed(0)} m²');
    }

    if (room.soNguoiToiDa != null) {
      parts.add('Tối đa ${room.soNguoiToiDa} người');
    }

    if (parts.isEmpty) {
      return 'Chưa có thông tin thêm';
    }

    return parts.join(' • ');
  }

  String _formatCurrency(num value) {
    final text = value.toStringAsFixed(0);
    final buffer = StringBuffer();
    int count = 0;

    for (int i = text.length - 1; i >= 0; i--) {
      buffer.write(text[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }

    return buffer.toString().split('').reversed.join();
  }

  _RoomStatusStyle _statusStyle(PhongModel room) {
    if (room.trangThai == 'Đang thuê') {
      return const _RoomStatusStyle(
        mainColor: Color(0xFF19D8B3),
        bgColor: Color(0xFFE7FFF8),
      );
    }

    if (room.trangThai == 'Trống') {
      return const _RoomStatusStyle(
        mainColor: Color(0xFFF5A623),
        bgColor: Color(0xFFFFF3D9),
      );
    }

    return const _RoomStatusStyle(
      mainColor: Color(0xFFFF4D4F),
      bgColor: Color(0xFFFFE8E8),
    );
  }
}

class _RoomStatusStyle {
  final Color mainColor;
  final Color bgColor;

  const _RoomStatusStyle({
    required this.mainColor,
    required this.bgColor,
  });
}