import 'package:flutter/material.dart';
import '../../widgets/admin/admin_drawer.dart';

class AdLichCongViec extends StatelessWidget {
  const AdLichCongViec({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      drawer: const AdminDrawer(activeTitle: "Lịch & Công việc"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderTitle(context),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterTabs(),
                  const SizedBox(height: 20),
                  _buildSectionHeader('Công việc sắp tới', 'Tháng 3, 2024'),
                  const SizedBox(height: 12),
                  
                  // Danh sách công việc
                  _buildTaskCard('05', 'Th 03', 'Thu tiền P.101', '08:00 - 09:00', 'Thu tiền', Colors.red),
                  _buildTaskCard('08', 'Th 03', 'Sửa điện P.203', '10:30 - 12:00', 'Bảo trì', Colors.orange),
                  _buildTaskCard('12', 'Th 03', 'Gặp mặt chủ nhà', '14:00 - 15:30', 'Gặp mặt', Colors.green),
                  _buildTaskCard('15', 'Th 03', 'Thu tiền P.305', '09:00 - 10:00', 'Thu tiền', Colors.red),
                  
                  const SizedBox(height: 24),
                  _buildCalendarSection(),
                  const SizedBox(height: 24),
                  _buildLegendSection(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- AppBar chuẩn Admin ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.home_work_rounded, color: Color(0xFF2DDCB1), size: 24),
          const SizedBox(width: 8),
          const Text('TroSmart', style: TextStyle(color: Color(0xFF2DDCB1), fontWeight: FontWeight.bold, fontSize: 18)),
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
                color: const Color(0x142DDCB1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x4C2DDCB1)),
              ),
              child: const Text('Chủ trọ', style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ],
    );
  }

  // --- Header Tím đặc trưng ---
  Widget _buildHeaderTitle(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xCC6A3092), Color(0xFFA452B1)]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lịch & Công việc', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
              Row(
                children: [
                  Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                  const SizedBox(width: 12),
                  Icon(Icons.notifications_none, color: Colors.white.withOpacity(0.5)),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline, size: 18),
            label: const Text('+ Thêm sự kiện'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.15),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  // --- Tabs lọc ---
  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabItem('Tất cả', isSelected: true),
          _buildTabItem('Thu tiền'),
          _buildTabItem('Bảo trì'),
          _buildTabItem('Gặp mặt'),
          _buildTabItem('Khác'),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: isSelected ? const LinearGradient(colors: [Color(0xCC6A3092), Color(0xFFA452B1)]) : null,
        color: isSelected ? null : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black54, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(subtitle, style: const TextStyle(color: Color(0xCC6A3092), fontSize: 12)),
      ],
    );
  }

  // --- Card Công việc ---
  Widget _buildTaskCard(String day, String month, String title, String time, String tag, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xCC6A3092), Color(0xFFA452B1)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Text(day, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(month, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(time, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ],
            ),
          ),
          Icon(Icons.circle, color: statusColor, size: 10),
        ],
      ),
    );
  }

  // --- Lịch tháng màu tím ---
  Widget _buildCalendarSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xCC6A3092), Color(0xFFA452B1)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text('Tháng 3, 2024', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          // Ở đây Vinh có thể dùng thư viện TableCalendar, tui vẽ tĩnh theo ảnh
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['CN','T2','T3','T4','T5','T6','T7'].map((e) => Text(e, style: const TextStyle(color: Colors.white30, fontSize: 11))).toList(),
          ),
          const SizedBox(height: 12),
          _buildCalendarRow(['', '', '', '', '', '1', '2']),
          _buildCalendarRow(['3', '4', '5', '6', '7', '8', '9'], highlights: [5, 8]),
          _buildCalendarRow(['10', '11', '12', '13', '14', '15', '16'], highlights: [12, 15]),
          _buildCalendarRow(['17', '18', '19', '20', '21', '22', '23'], highlights: [20]),
          const SizedBox(height: 12),
          const Divider(color: Colors.white10),
          Text('6 công việc trong tháng', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCalendarRow(List<String> days, {List<int>? highlights}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((d) {
          bool isHighlighted = highlights?.contains(int.tryParse(d) ?? -1) ?? false;
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: isHighlighted ? BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)) : null,
            child: Text(d, style: TextStyle(color: isHighlighted ? const Color(0xFF2DDCB1) : Colors.white70, fontSize: 12)),
          );
        }).toList(),
      ),
    );
  }

  // --- Chú thích ---
 Widget _buildLegendSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Phần Danh mục công việc ---
        const Text(
          'DANH MỤC CÔNG VIỆC', 
          style: TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _legendItem('Thu tiền', Colors.red, isStatus: false),
            _legendItem('Bảo trì', Colors.orange, isStatus: false),
            _legendItem('Gặp mặt', Colors.green, isStatus: false),
          ],
        ),
        
        const SizedBox(height: 24),

        // --- Phần Trạng thái (Thêm mới theo image_3c1b52.png) ---
        const Text(
          'TRẠNG THÁI', 
          style: TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _legendItem('Quá hạn', Colors.red, isStatus: true),
            _legendItem('Đang xử lý', Colors.orange, isStatus: true),
            _legendItem('Hoàn thành', Colors.green, isStatus: true),
          ],
        ),
      ],
    );
  }

  // Hàm build chung cho cả Danh mục và Trạng thái
  Widget _legendItem(String label, Color color, {required bool isStatus}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, color: color, size: 10),
            const SizedBox(height: 6),
            Text(
              label, 
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87)
            ),
          ],
        ),
      ),
    );
  }

  

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xCC6A3092),
      currentIndex: 2, // Highlight icon Phòng/Lịch
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Trang chủ'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Hóa đơn'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Lịch'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Tài khoản'),
      ],
    );
  }
}