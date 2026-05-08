import 'package:flutter/material.dart';
import 'package:trosmart/widgets/common/admin/custom_bottom_navigation.dart';
import '../../widgets/admin/add_invoice_widgets.dart';

class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({super.key});

  @override
  State<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  bool sendNotify = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Header Gradient
          const HeaderSection(),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const PageTitleSection(),
                  const SizedBox(height: 20),
                  const InvoiceFormCard(),
                  const SizedBox(height: 30),
                  
                  // Notify Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Gửi thông báo cho khách ngay',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Switch(
                        value: sendNotify,
                        onChanged: (val) => setState(() => sendNotify = val),
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFF6A3092),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Primary Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A3092),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Lưu & Xuất hóa đơn',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ),
          
          // Bottom Navigation
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNav(), // Tái sử dụng BottomNav chung của app
          ),
        ],
      ),
    );
  }
}