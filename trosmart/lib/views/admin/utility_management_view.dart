import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../shared/app_colors.dart';
import '../../widgets/admin/invoice_header.dart';
import '../../widgets/admin/utility_summary_card.dart';
import '../../widgets/admin/room_utility_entry_card.dart';

import '../../models/co_so.dart';
import '../../models/phong.dart';
import '../../services/co_so_service.dart';

class UtilityManagementScreen extends StatefulWidget {
  const UtilityManagementScreen({super.key});

  @override
  State<UtilityManagementScreen> createState() => _UtilityManagementScreenState();
}

class _UtilityManagementScreenState extends State<UtilityManagementScreen> {
  final CoSoService _coSoService = CoSoService();
  List<CoSo> _coSoList = [];
  CoSo? _selectedCoSo;
  List<Phong> _phongList = [];
  bool _isLoading = true;
  bool _isLoadingRooms = false;

  @override
  void initState() {
    super.initState();
    _loadCoSoData();
  }

  Future<void> _loadCoSoData() async {
    try {
      final list = await _coSoService.getAllCoSo();
      setState(() {
        _coSoList = list;
        if (list.isNotEmpty) {
          _selectedCoSo = list.first;
          _loadPhongsData(_selectedCoSo!.maCoSo);
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Error loading CoSo: $e");
    }
  }

  Future<void> _loadPhongsData(int coSoId) async {
    setState(() {
      _isLoadingRooms = true;
    });
    try {
      final list = await _coSoService.getPhongsByCoSoId(coSoId);
      setState(() {
        _phongList = list;
        _isLoadingRooms = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingRooms = false;
      });
      debugPrint("Error loading Phongs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    
    return Column(
      children: [
        const InvoiceHeader(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildScreenTitle(),
              const SizedBox(height: 24),
              _buildActionBanner(),
              const SizedBox(height: 24),
              _buildPriceSummary(),
              const SizedBox(height: 24),
              _buildSearchAndFilters(),
              const SizedBox(height: 24),
              _buildRoomListHeader(),
              const SizedBox(height: 16),
              
              // Danh sách phòng từ API
              if (_isLoadingRooms)
                const Center(child: CircularProgressIndicator())
              else if (_phongList.isEmpty)
                const Center(child: Text('Không có phòng nào.'))
              else
                ..._phongList.map((phong) => RoomUtilityEntryCard(
                  roomName: phong.soPhong,
                  tenantName: "Khách thuê · Tầng ${phong.tang ?? 'Trệt'}",
                  isEmpty: phong.trangThai == "Trống",
                )),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScreenTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quản lý điện nước', 
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.adminDarkPurple, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            const Text('THÁNG 10 / 2024', 
              style: TextStyle(color: AppColors.adminDarkPurple, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ],
        ),
        const SizedBox(height: 8),
        const Text('Cập nhật chỉ số tiêu thụ hàng tháng từng phòng trọ.', 
          style: TextStyle(color: Color(0xFF050A0F), fontSize: 14)),
      ],
    );
  }

  Widget _buildActionBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        gradient: AppColors.adminHeaderGradient,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.save, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          const Expanded(child: Text('Lưu tất cả', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)),
            child: const Text('12/24', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        UtilitySummaryCard(icon: LucideIcons.zap, iconBgColor: Colors.amber, title: "Giá điện", value: "3.500đ", unit: "/ kWh"),
        UtilitySummaryCard(icon: LucideIcons.droplets, iconBgColor: Colors.blue, title: "Giá nước", value: "25.000đ", unit: "/ khối"),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Tìm phòng, khách thuê...',
            prefixIcon: const Icon(LucideIcons.search, size: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.building, size: 16),
              const SizedBox(width: 12),
              Expanded(
                child: _isLoading 
                  ? const Text('Đang tải danh sách cơ sở...', style: TextStyle(fontSize: 14))
                  : DropdownButtonHideUnderline(
                      child: DropdownButton<CoSo>(
                        isExpanded: true,
                        value: _selectedCoSo,
                        icon: const Icon(LucideIcons.chevronDown, size: 16),
                        hint: const Text('Chọn cơ sở', style: TextStyle(fontSize: 14)),
                        onChanged: (CoSo? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCoSo = newValue;
                            });
                            _loadPhongsData(newValue.maCoSo);
                          }
                        },
                        items: _coSoList.map<DropdownMenuItem<CoSo>>((CoSo value) {
                          return DropdownMenuItem<CoSo>(
                            value: value,
                            child: Text(value.tenCoSo, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                      ),
                    ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildRoomListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Danh sách phòng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54)),
        Text('${_phongList.length} phòng', style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}