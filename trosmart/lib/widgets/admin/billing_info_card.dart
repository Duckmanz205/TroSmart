import 'package:flutter/material.dart';
import '../../shared/app_colors.dart';

class BillingInfoCard extends StatelessWidget {
  final String title;
  final String oldVal;
  final String newVal;

  const BillingInfoCard({
    super.key,
    required this.title,
    required this.oldVal,
    required this.newVal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.adminDarkPurple,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildIndexCol(
                  'Cũ: $oldVal',
                  oldVal,
                  Colors.grey,
                ),
              ),
              Expanded(
                child: _buildIndexCol(
                  'Mới *',
                  newVal,
                  AppColors.adminDarkPurple,
                  isBold: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndexCol(
    String label,
    String value,
    Color labelColor, {
    bool isBold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: labelColor, fontSize: 10),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold
                ? AppColors.textDark
                : Colors.grey[700] ?? Colors.grey, // fix null-safety
          ),
        ),
      ],
    );
  }
}