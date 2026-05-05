import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionTitleAction extends StatelessWidget {
  const SectionTitleAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thu & Thuê',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF111827),
              ),
            ),
            const Text(
              'Quản lý hóa đơn & thanh toán',
              style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Tạo', style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2DDCB1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            shadowColor: const Color(0xFF2DDCB1).withOpacity(0.4),
          ),
        ),
      ],
    );
  }
}

class SummaryGrid extends StatelessWidget {
  const SummaryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: StatCard(icon: Icons.check, value: '13.9', label: 'Đã thu', color: Colors.tealAccent)),
        SizedBox(width: 12),
        Expanded(child: StatCard(icon: Icons.access_time, value: '10.6', label: 'Chờ thu', color: Colors.amberAccent)),
        SizedBox(width: 12),
        Expanded(child: StatCard(icon: Icons.warning_amber_rounded, value: '6.1', label: 'Quá hạn', color: Colors.redAccent)),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatCard({required this.icon, required this.value, required this.label, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8E78C2), Color(0xFF6E589E)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const TextSpan(text: ' tr', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white)),
              ],
            ),
          ),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.7))),
        ],
      ),
    );
  }
}

class SearchAndFilter extends StatelessWidget {
  const SearchAndFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black12),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Colors.black26),
                hintText: 'Tìm hóa đơn...',
                hintStyle: TextStyle(color: Colors.black26),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
          ),
          child: const Icon(Icons.filter_list, color: Colors.black45),
        ),
      ],
    );
  }
}

class InvoiceList extends StatelessWidget {
  const InvoiceList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        InvoiceCard(room: 'P.101', tenant: 'Nguyễn Văn A', amount: '3.500.000', deadline: '05/03/2026', status: 'paid'),
        InvoiceCard(room: 'P.102', tenant: 'Trần Thị B', amount: '4.200.000', deadline: '10/03/2026', status: 'pending'),
        InvoiceCard(room: 'P.201', tenant: 'Lê Minh C', amount: '3.800.000', deadline: '01/03/2026', status: 'overdue'),
      ],
    );
  }
}

class InvoiceCard extends StatelessWidget {
  final String room;
  final String tenant;
  final String amount;
  final String deadline;
  final String status;

  const InvoiceCard({required this.room, required this.tenant, required this.amount, required this.deadline, required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == 'paid' ? const Color(0xFF2DDCB1) : (status == 'pending' ? Colors.orange : Colors.redAccent);
    String statusText = status == 'paid' ? 'ĐÃ THANH TOÁN' : (status == 'pending' ? 'CHỜ THANH TOÁN' : 'QUÁ HẠN');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8E78C2), Color(0xFF6E589E)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border(left: BorderSide(color: statusColor, width: 4)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(room, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(tenant, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Text(statusText, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$amount đ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: status == 'overdue' ? Colors.redAccent : const Color(0xFF2DDCB1))),
              Text('Hạn: $deadline', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5))),
            ],
          ),
          if (status != 'paid') ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.outbound_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(status == 'overdue' ? 'Nhắc nhở khẩn' : 'Nhắc nhở', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}