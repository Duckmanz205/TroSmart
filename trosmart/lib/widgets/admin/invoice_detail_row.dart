import 'package:flutter/material.dart';
import '../../shared/app_colors.dart';

class InvoiceDetailRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String price;
  final bool isBold;

  const InvoiceDetailRow({
    super.key, 
    required this.title, 
    this.subtitle, 
    required this.price, 
    this.isBold = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(
                fontSize: isBold ? 15 : 14, 
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: AppColors.textDark
              )),
              if (subtitle != null)
                Text(subtitle!, style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
            ],
          ),
          Text(price, style: TextStyle(
            fontSize: isBold ? 15 : 14, 
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: AppColors.textDark
          )),
        ],
      ),
    );
  }
}