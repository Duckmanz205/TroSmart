import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BillBanner extends StatelessWidget {
  const BillBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha:0.03), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Hóa đơn tháng 03/2024", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    // 2. Dùng FittedBox để số tiền tự co giãn nếu quá dài
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text("4.250.000đ", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFB794F4).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFB794F4).withValues(alpha:0.2)),
                ),
                child: const Text("CHƯA THANH TOÁN", style: TextStyle(color: Color(0xFFB794F4), fontSize: 10, fontWeight: FontWeight.w900)),
              )
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.scanLine),
                  label: const Text("Scan QR"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB794F4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.fileText),
                  label: const Text("PDF Bill"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFB794F4)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 0.5, endIndent: 10)),
        Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.5)),
        const Expanded(child: Divider(thickness: 0.5, indent: 10)),
      ],
    );
  }
}

class BillDetailList extends StatelessWidget {
  const BillDetailList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha:0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha:0.1)),
      ),
      child: const Column(
        children: [
          _DetailTile(icon: LucideIcons.home, label: "Tiền nhà", value: "3.500.000đ"),
          _DetailTile(icon: LucideIcons.zap, label: "Tiền điện (125 kWh)", value: "437.500đ"),
          _DetailTile(icon: LucideIcons.droplets, label: "Tiền nước", value: "80.000đ"),
          _DetailTile(icon: LucideIcons.wifi, label: "Mạng Internet", value: "150.000đ"),
          _DetailTile(icon: LucideIcons.settings, label: "Dịch vụ khác", value: "82.500đ", isLast: true),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;
  const _DetailTile({required this.icon, required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.withValues(alpha:0.1), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

class SharedCostSection extends StatelessWidget {
  const SharedCostSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Icon(LucideIcons.users, size: 16, color: Colors.grey),
            SizedBox(width: 8),
            Text("Chia sẻ chi phí", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _PartnerCard(name: "Bình (Tôi)", amount: "2.125.000đ", status: "ĐÃ SẴN SÀNG", isMe: true),
            const SizedBox(width: 16),
            _PartnerCard(name: "Sarah", amount: "2.125.000đ", status: "ĐANG CHỜ", isMe: false),
          ],
        )
      ],
    );
  }
}

class _PartnerCard extends StatelessWidget {
  final String name;
  final String amount;
  final String status;
  final bool isMe;
  const _PartnerCard({required this.name, required this.amount, required this.status, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withValues(alpha:0.05)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.02), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 10, child: Text(name[0], style: const TextStyle(fontSize: 10))),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Text(amount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: isMe ? const Color(0xFFB794F4) : null)),
            const SizedBox(height: 4),
            Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isMe ? const Color(0xFFB794F4).withValues(alpha:0.5) : Colors.grey.withValues(alpha:0.5))),
          ],
        ),
      ),
    );
  }
}

class PaymentHistoryItem extends StatelessWidget {
  final String month;
  final String amount;
  final String date;
  const PaymentHistoryItem({super.key, required this.month, required this.amount, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha:0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.green.withValues(alpha:0.1), shape: BoxShape.circle),
                child: const Icon(LucideIcons.checkCircle2, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tháng $month", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text("$date • Đã quyết toán", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              )
            ],
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
        ],
      ),
    );
  }
}