import 'package:flutter/material.dart';
import 'package:trosmart/views/admin/AD_AddHopDong.dart';
import 'package:trosmart/views/admin/AD_DetailHopDong.dart';
import '../../shared/app_theme.dart';
import '../../widgets/admin/admin_drawer.dart';

class AdQLHopDong extends StatelessWidget {
  const AdQLHopDong({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      drawer: const AdminDrawer(activeTitle: "Hợp đồng"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildStatusGrid(),
                  const SizedBox(height: 24),
                  _buildSearchAndFilter(),
                  const SizedBox(height: 24),
                  _buildListHeader(),
                  const SizedBox(height: 12),

                  // Danh sách hợp đồng
                  _buildContractCard(
                    context: context,
                    id: 'HD-2023-001',
                    name: 'Nguyễn Văn An',
                    room: 'Phòng 101 - Cơ sở 1 - Quận 7',
                    phone: '0901 234 567',
                    date: '01/01/2023 - 31/12/2023',
                    price: '3.500.000đ',
                    deposit: '3.500.000đ',
                    status: 'ĐANG HIỆU LỰC',
                    statusColor: const Color(0xFF2DDCB1),
                  ),

                  _buildContractCard(
                    context: context,
                    id: 'HD-2023-045',
                    name: 'Trần Thị Bích',
                    room: 'Phòng 205 - Cơ sở 2 - Quận 1',
                    phone: '0988 765 432',
                    date: '15/11/2022 - 15/11/2023',
                    price: '4.200.000đ',
                    deposit: '5.000.000đ',
                    status: 'SẮP HẾT HẠN',
                    statusColor: const Color(0xFFFBBF24),
                  ),

                  _buildContractCard(
                    context: context,
                    id: 'HD-2023-089',
                    name: 'Lê Hoàng Nam',
                    room: 'Phòng 302 - Cơ sở 1 - Quận 7',
                    phone: '0912 345 678',
                    date: '01/12/2023 - 01/12/2024',
                    price: '3.800.000đ',
                    deposit: '3.800.000đ',
                    status: 'CHỜ KÝ',
                    statusColor: const Color(0xFF60A5FA),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- AppBar chuẩn TroSmart ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA161D2), Color(0xFF64417F)],
          ),
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.home_work_rounded,
            color: Color(0xFF2DDCB1),
            size: 24,
          ),
          const SizedBox(width: 8),
          const Text(
            'TroSmart',
            style: TextStyle(
              color: Color(0xFF2DDCB1),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x4C2DDCB1)),
              ),
              child: const Text(
                'Chủ trọ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Tiêu đề & Nút Tạo mới ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quản lý hợp đồng',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const Text(
            'Quản lý tất cả hợp đồng thuê phòng của bạn.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Lệnh chuyển trang
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdAddHopDong()),
              );
            },
            icon: const Icon(Icons.add, size: 20),
            label: const Text(
              'Tạo hợp đồng mới',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.deepPurple,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Grid thống kê trạng thái ---
  Widget _buildStatusGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _statusItem(
          'Đang hiệu lực',
          '42',
          const Color(0x192DDCB1),
          const Color(0xFF2DDCB1),
        ),
        _statusItem(
          'Sắp hết hạn',
          '05',
          const Color(0x19FBBF24),
          const Color(0xFFFBBF24),
        ),
        _statusItem(
          'Chờ ký',
          '03',
          const Color(0x1960A5FA),
          const Color(0xFF60A5FA),
        ),
        _statusItem(
          'Đã hết hạn',
          '12',
          const Color(0x19F87171),
          const Color(0xFFF87171),
        ),
      ],
    );
  }

  Widget _statusItem(String label, String count, Color bg, Color tint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.deepPurple.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.description_outlined, color: tint, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
              Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Ô tìm kiếm & Lọc ---
  Widget _buildSearchAndFilter() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Tìm theo tên, mã HD, phòng...',
            prefixIcon: const Icon(Icons.search, size: 20),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.filter_list, size: 18),
                  SizedBox(width: 8),
                  Text('Tất cả trạng thái'),
                ],
              ),
              Icon(Icons.keyboard_arrow_down, size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Danh sách hợp đồng',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text('62 hợp đồng', style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  // --- Card Hợp đồng ---
  Widget _buildContractCard({
    required BuildContext context, // Thêm context để điều hướng
    required String id,
    required String name,
    required String room,
    required String phone,
    required String date,
    required String price,
    required String deposit,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.deepPurple.withOpacity(
          0.85,
        ), // Tăng độ đậm chút cho dễ đọc
        borderRadius: BorderRadius.circular(24), // Bo góc mềm mại hơn
        boxShadow: [
          BoxShadow(
            color: AppTheme.deepPurple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          // KHI NHẤN VÀO THẺ -> XEM CHI TIẾT
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdDetailHopDong()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: ID và Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      id,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withOpacity(0.5),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: statusColor, size: 6),
                          const SizedBox(width: 6),
                          Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tên khách thuê
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Thông tin chi tiết
                _infoLine(Icons.door_back_door_outlined, room),
                _infoLine(Icons.phone_iphone_rounded, phone),
                _infoLine(Icons.event_available_outlined, date),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Colors.white12, height: 1),
                ),

                // Giá tiền và Tiền cọc
                Row(
                  children: [
                    Expanded(child: _buildPriceInfo('THUÊ', price)),
                    Container(width: 1, height: 30, color: Colors.white10),
                    Expanded(child: _buildPriceInfo('CỌC', deposit)),
                  ],
                ),

                const SizedBox(height: 20),

                // Thanh hành động (Sửa, Tải, Xóa)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _actionButton(Icons.edit_note_rounded, "Sửa", () {
                      // Logic sửa ở đây
                    }),
                    const SizedBox(width: 12),
                    _actionButton(Icons.file_download_outlined, "Tải", () {
                      // Logic tải PDF ở đây
                    }),
                    const SizedBox(width: 12),
                    _actionButton(Icons.delete_sweep_outlined, "Xóa", () {
                      // Logic xóa ở đây
                    }, isDelete: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget hỗ trợ hiển thị giá tiền
  Widget _buildPriceInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  // Widget hỗ trợ các nút chức năng nhỏ gọn
  Widget _actionButton(
    IconData icon,
    String tooltip,
    VoidCallback onTap, {
    bool isDelete = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDelete
                ? Colors.redAccent.withOpacity(0.1)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDelete ? Colors.redAccent : Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _infoLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white60, size: 14),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }


  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.deepPurple,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'Hóa đơn',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description),
          label: 'Hợp đồng',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Tài khoản',
        ),
      ],
    );
  }
}
