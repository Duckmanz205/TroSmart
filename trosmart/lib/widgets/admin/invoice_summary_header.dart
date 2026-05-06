import 'package:flutter/material.dart';
import '../../shared/app_colors.dart';

class InvoiceSummaryHeader extends StatelessWidget {
  final String amount;
  final String? status;
  final bool isEntry; // True nếu ở màn hình nhập, False nếu ở màn hình chi tiết

  const InvoiceSummaryHeader({
    super.key, 
    required this.amount, 
    this.status, 
    this.isEntry = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isEntry ? 'TỔNG CỘNG THANH TOÁN' : 'TỔNG THANH TOÁN', 
          style: const TextStyle(color: AppColors.adminDarkPurple, fontSize: 13)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(amount, style: const TextStyle(
              color: AppColors.adminDarkPurple, 
              fontSize: 32, 
              fontWeight: FontWeight.bold
            )),
            if (status != null)
              Text('● $status', style: const TextStyle(
                color: AppColors.statusOrange, 
                fontSize: 11, 
                fontWeight: FontWeight.bold
              )),
          ],
        ),
        if (isEntry)
          const Text('(Bao gồm: Phòng, Điện, Nước, Wifi)', 
            style: TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}