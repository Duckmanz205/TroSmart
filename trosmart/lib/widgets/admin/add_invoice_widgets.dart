import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 160,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8C3EBE), Color(0xFF7A28A8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}

class PageTitleSection extends StatelessWidget {
  const PageTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lập hóa đơn tháng',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Tháng 04/2026 - Cơ sở Quận 7',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class InvoiceFormCard extends StatelessWidget {
  const InvoiceFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormLabel(label: 'ĐỐI TƯỢNG THANH TOÁN'),
          const SizedBox(height: 8),
          const CustomDropdown(text: 'Phòng P.402 - Nguyễn Văn A'),
          
          const SizedBox(height: 24),
          const FormLabel(label: 'CHỈ SỐ ĐIỆN', subLabel: '(⚡ 3.500đ/kWh)'),
          const SizedBox(height: 8),
          const Row(
            children: [
              Expanded(child: ReadingInput(label: 'Cũ: 1250', value: '1250', isReadOnly: true)),
              SizedBox(width: 12),
              Expanded(child: ReadingInput(label: 'Mới *', value: '1342')),
            ],
          ),
          
          const SizedBox(height: 24),
          const FormLabel(label: 'CHỈ SỐ NƯỚC', subLabel: '(💧 20.000đ/m3)'),
          const SizedBox(height: 8),
          const Row(
            children: [
              Expanded(child: ReadingInput(label: 'Cũ: 430', value: '430', isReadOnly: true)),
              SizedBox(width: 12),
              Expanded(child: ReadingInput(label: 'Mới *', value: '438')),
            ],
          ),
          
          const SizedBox(height: 24),
          const FormLabel(label: 'TIỀN PHÒNG & DỊCH VỤ CỐ ĐỊNH'),
          const SizedBox(height: 12),
          const FeeDisplay(text: 'Phòng: 4.500.000 | Wifi: 100.000'),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Phí phát sinh (sửa đồ, vi phạm...)',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          
          const SizedBox(height: 24),
          const SummaryCard(),
        ],
      ),
    );
  }
}

class FormLabel extends StatelessWidget {
  final String label;
  final String? subLabel;
  const FormLabel({super.key, required this.label, this.subLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6A3092),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        if (subLabel != null)
          Text(
            ' $subLabel',
            style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500),
          ),
      ],
    );
  }
}

class ReadingInput extends StatelessWidget {
  final String label;
  final String value;
  final bool isReadOnly;

  const ReadingInput({
    super.key,
    required this.label,
    required this.value,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isReadOnly ? const Color(0xFFF8F9FA) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isReadOnly ? Colors.transparent : const Color(0xFF6A3092),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isReadOnly ? Colors.grey : const Color(0xFF6A3092),
              fontWeight: isReadOnly ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isReadOnly ? FontWeight.w500 : FontWeight.bold,
              color: isReadOnly ? Colors.grey : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0FA),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Text(
            'TỔNG CỘNG THANH TOÁN',
            style: TextStyle(
              color: Color(0xFF6A3092),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '4.982.000 đ',
            style: TextStyle(
              color: Color(0xFF6A3092),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            '(Bao gồm: Phòng, Điện, Nước, Wifi)',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String text;
  const CustomDropdown({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6A3092)),
        ],
      ),
    );
  }
}

class FeeDisplay extends StatelessWidget {
  final String text;
  const FeeDisplay({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black54)),
    );
  }
}