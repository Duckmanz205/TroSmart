import 'package:flutter/material.dart';
import '../../widgets/user/user_drawer.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: const UserDrawer(), // Gắn Drawer vào đây
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            _buildPaymentHeroCard(),
            const SizedBox(height: 32),
            _buildOverviewBento(),
            const SizedBox(height: 32),
            _buildNotificationsSection(),
            const SizedBox(height: 40), // Spacing cho Bottom Nav
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: const Color(0xFFE5E7EB), height: 1.0),
      ),
      leading: Builder( // Cần Builder để mở Drawer
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF6750A4)),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const Text(
        "TroSmart",
        style: TextStyle(color: Color(0xFF6750A4), fontSize: 24, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 24),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0x336750A4)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade300, // Thay bằng NetworkImage khi có link avatar
          ),
          child: const Icon(Icons.person, color: Colors.white),
        )
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Hôm nay của bạn thế nào?", style: TextStyle(fontSize: 16, color: Color(0xFF6B5E8C))),
            const SizedBox(width: 8),
            Expanded(child: Container(height: 1, decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFD1D5DB), style: BorderStyle.solid))))),
          ],
        ),
        const SizedBox(height: 3),
        const Text("Xin chào, Bình!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF6750A4))),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(width: 10, height: 10, color: const Color(0xFF6750A4)),
            const SizedBox(width: 8),
            const Text("TỔNG QUAN TIỀN NHÀ", style: TextStyle(fontSize: 16, letterSpacing: 1.6, color: Color(0xFF49454F))),
          ],
        )
      ],
    );
  }

  Widget _buildPaymentHeroCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Stack(
        children: [
          // Gradient nền thẻ
          Positioned.fill(
            child: Container(decoration: BoxDecoration(color: const Color(0xFFB794F4).withOpacity(0.05))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Tổng tiền cần trả", style: TextStyle(fontSize: 16, color: Color(0xFF49454F))),
                      SizedBox(height: 4),
                      Text("3.500k", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF1C1B1F))),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0x1A6750A4), borderRadius: BorderRadius.circular(12)),
                    child: const Text("HẠN: 05/10", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6750A4))),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Tiến độ thanh toán", style: TextStyle(fontSize: 11, color: Color(0xFF49454F))),
                  Text("0%", style: TextStyle(fontSize: 11, color: Color(0xFF49454F))), // Text mẫu
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: 0.1, // Thay đổi tùy theo logic
                  backgroundColor: const Color(0xFFE6E1E5),
                  color: const Color(0xFF6750A4),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 5,
                    shadowColor: const Color(0x406750A4),
                  ),
                  icon: const Icon(Icons.payment, color: Colors.white, size: 16),
                  label: const Text("Thanh toán", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewBento() {
    return Column(
      children: [
        Row(
          children: [
            const Text("Tổng quan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1C1B1F))),
            const SizedBox(width: 12),
            Container(width: 12, height: 12, color: const Color(0xFF6750A4)),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.4,
          children: [
            _buildBentoItem("Tiền thuê", "3.500k", Icons.home, const Color(0xFF6750A4)),
            _buildBentoItem("Điện nước", "750k", Icons.water_drop, const Color(0xFF625B71)),
            _buildBentoItem("Tiền cọc", "7.000k", Icons.monetization_on, const Color(0xFF616114)),
            _buildBentoItem("Hợp đồng", "12 tháng", Icons.description, const Color(0xFF6B5E8C)),
          ],
        ),
      ],
    );
  }

  Widget _buildBentoItem(String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: iconColor, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, color: Color(0xFF49454F))),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1C1B1F))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Thông báo mới", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1C1B1F))),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip("Nhắc thanh toán", isActive: true),
              const SizedBox(width: 8),
              _buildFilterChip("Cảnh báo"),
              const SizedBox(width: 8),
              _buildFilterChip("Tin nhắn"),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildNotificationCard(
          icon: Icons.payment,
          iconBg: const Color(0x1A6750A4),
          iconColor: const Color(0xFF6750A4),
          title: "Nhắc nhở đóng tiền nhà tháng 10",
          subtitle: "Vui lòng thanh toán trước ngày 05/10 để tránh phát sinh phí chậm.",
          time: "2 giờ trước",
        ),
        const SizedBox(height: 16),
        _buildNotificationCard(
          icon: Icons.power_off,
          iconBg: const Color(0xFFE6E1E5),
          iconColor: const Color(0xFF49454F),
          title: "Lịch bảo trì hệ thống điện",
          subtitle: "Tòa nhà sẽ tạm ngắt điện từ 08:00 đến 10:00 sáng mai.",
          time: "1 ngày trước",
          opacity: 0.7,
        ),
      ],
    );
  }

  Widget _buildFilterChip(String text, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6750A4) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isActive ? null : Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: isActive ? const [BoxShadow(color: Color(0x336750A4), blurRadius: 6, offset: Offset(0, 2))] : null,
      ),
      child: Text(text, style: TextStyle(fontSize: 14, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? Colors.white : const Color(0xFF49454F))),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon, required Color iconBg, required Color iconColor,
    required String title, required String subtitle, required String time,
    double opacity = 1.0,
  }) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black.withOpacity(0.08)),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(4)),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1C1B1F))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF49454F))),
                  const SizedBox(height: 4),
                  Text(time, style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Color(0xFF6B5E8C))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}