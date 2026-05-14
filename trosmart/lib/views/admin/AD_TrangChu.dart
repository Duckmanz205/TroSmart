import 'package:flutter/material.dart';
import '../../widgets/admin/admin_drawer.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050A0F), // Dark mode background
      drawer: const AdminDrawer(),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100), // Spacing for BottomNav
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(),
            _buildStatsGrid(),
            const SizedBox(height: 24),
            _buildRevenueChart(),
            const SizedBox(height: 24),
            _buildAlertsSection(),
            const SizedBox(height: 24),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.95),
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF2DDCB1), Color(0xFF1AAB87)]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.home, color: Color(0xFF050A0F), size: 16),
          ),
          const SizedBox(width: 8),
          const Text(
            "TroSmart",
            style: TextStyle(color: Color(0xFF2DDCB1), fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0x142DDCB1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x4D2DDCB1)),
            ),
            child: Row(
              children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF2DDCB1), shape: BoxShape.circle)),
                const SizedBox(width: 6),
                const Text("Chủ trọ", style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPageHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Dashboard", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
              SizedBox(height: 4),
              Text("Tổng quan hoạt động nhà trọ", style: TextStyle(fontSize: 13, color: Colors.white70)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x142DDCB1),
              border: Border.all(color: const Color(0x332DDCB1)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text("Tháng", style: TextStyle(fontSize: 10, color: Colors.white54)),
                SizedBox(height: 2),
                Text("03/2026", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2DDCB1))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1, // Tỷ lệ tạo độ cao cho thẻ
        children: [
          _buildStatCard(
            title: "Doanh thu tháng",
            value: "89.5",
            unit: "tr",
            icon: Icons.monetization_on,
            iconColor: const Color(0xFF2DDCB1),
            badge: "+12%",
          ),
          _buildStatCard(
            title: "Tổng phòng",
            value: "48",
            unit: "3 cơ sở",
            icon: Icons.meeting_room,
            iconColor: const Color(0xFF2DDCB1),
            isSecondaryUnit: true,
          ),
          _buildStatCard(
            title: "Tỷ lệ lấp đầy",
            value: "92",
            unit: "%",
            icon: Icons.pie_chart,
            iconColor: const Color(0xFF2DDCB1),
            badge: "+3%",
            hasProgress: true,
          ),
          _buildStatCard(
            title: "Sự cố",
            value: "5",
            unit: "Cần xử lý",
            icon: Icons.build,
            iconColor: const Color(0xFFFF5757),
            isSecondaryUnit: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title, required String value, required String unit,
    required IconData icon, required Color iconColor, String? badge,
    bool isSecondaryUnit = false, bool hasProgress = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xCC6A3092),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          // Gradient phủ ngoài
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [const Color(0x592DDCB1), const Color(0x0D2DDCB1), const Color(0x14040404)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                      child: Icon(icon, color: iconColor, size: 18),
                    ),
                    if (badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                        child: Text(badge, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: iconColor)),
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1)),
                        const SizedBox(width: 4),
                        if (!isSecondaryUnit)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(unit, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(title, style: const TextStyle(fontSize: 11, color: Colors.white54)),
                    if (isSecondaryUnit) ...[
                      const SizedBox(height: 4),
                      Text(unit, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: iconColor)),
                    ],
                    if (hasProgress) ...[
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: 0.92, backgroundColor: Colors.white10, color: iconColor, minHeight: 3),
                    ]
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xCC6A3092), borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Doanh thu 12 tháng", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("triệu VNĐ", style: TextStyle(fontSize: 11, color: Colors.white54)),
                ],
              ),
              Row(
                children: [
                  _buildYearFilter("2026", isActive: true),
                  const SizedBox(width: 8),
                  _buildYearFilter("2025", isActive: false),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          // Chart Placeholder
          Container(
            height: 160,
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
            alignment: Alignment.center,
            child: const Icon(Icons.bar_chart, color: Colors.white54, size: 48),
          )
        ],
      ),
    );
  }

  Widget _buildYearFilter(String year, {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0x262DDCB1) : Colors.transparent,
        border: Border.all(color: isActive ? const Color(0x4D2DDCB1) : Colors.white10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(year, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? const Color(0xFF2DDCB1) : Colors.white54)),
    );
  }

  Widget _buildAlertsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Color(0xFFF5A623), size: 20),
              const SizedBox(width: 8),
              const Text("Cảnh báo", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0x26F5A623), borderRadius: BorderRadius.circular(12)),
                child: const Text("3 mục", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFF5A623))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAlertCard("Hóa đơn quá hạn", "P.201, P.305 chưa thanh toán", "2 giờ trước", Icons.payment, const Color(0xFFF5A623)),
          const SizedBox(height: 12),
          _buildAlertCard("Hợp đồng sắp hết hạn", "4 hợp đồng hết hạn trong 7 ngày", "5 giờ trước", Icons.description, const Color(0xFF4A9EFF)),
          const SizedBox(height: 12),
          _buildAlertCard("Sự cố điện tầng 3", "Cơ sở Quận 7 – Đang xử lý", "1 ngày trước", Icons.flash_on, const Color(0xFFFF5757)),
        ],
      ),
    );
  }

  Widget _buildAlertCard(String title, String subtitle, String time, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xCC6A3092),
        borderRadius: BorderRadius.circular(14),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)))),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Icon(icon, color: color, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.white54)),
                        ],
                      ),
                    ),
                    Text(time, style: const TextStyle(fontSize: 10, color: Colors.white30)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Hoạt động gần đây", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              Text("Xem tất cả →", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF2DDCB1))),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(color: const Color(0xCC6A3092), borderRadius: BorderRadius.circular(18)),
            child: Column(
              children: [
                _buildTimelineItem("Thanh toán tiền phòng", "Nguyễn Văn A – P.102 – 3.500.000đ", "5 phút trước", Icons.attach_money, const Color(0xFF2DDCB1), isFirst: true),
                _buildTimelineItem("Hợp đồng mới ký kết", "Trần Thị B – P.305 – 12 tháng", "1 giờ trước", Icons.history_edu, const Color(0xFF4A9EFF)),
                _buildTimelineItem("Báo cáo sự cố mới", "P.401 – Rò rỉ nước – Đang xử lý", "3 giờ trước", Icons.warning, const Color(0xFFFF5757)),
                _buildTimelineItem("Khách thuê mới check-in", "Lê Minh C – P.203 – Cơ sở Q.7", "Hôm qua", Icons.person_add, const Color(0xFF2DDCB1)),
                _buildTimelineItem("Ghi nhận điện tháng 3", "Tổng 48 phòng – 14.520 kWh", "2 ngày trước", Icons.bolt, const Color(0xFFF5A623), isLast: true),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, String time, IconData icon, Color color, {bool isFirst = false, bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(width: 16),
          Column(
            children: [
              Container(width: 1, height: isFirst ? 0 : 10, color: Colors.white24),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withOpacity(0.12), border: Border.all(color: color.withOpacity(0.3)), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 14),
              ),
              Expanded(child: Container(width: 1, color: isLast ? Colors.transparent : Colors.white24)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 16, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(time, style: const TextStyle(fontSize: 10, color: Colors.white30)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.white54)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}