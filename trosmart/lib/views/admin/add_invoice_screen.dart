import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/admin/add_invoice_widgets.dart';
import '../../logic/admin/invoice_controller.dart';

class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({super.key});

  @override
  State<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  bool sendNotify = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvoiceController(),
      child: Scaffold(
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
                  Consumer<InvoiceController>(
                    builder: (context, controller, child) {
                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: controller.isLoading || controller.selectedRoomId == null
                              ? null
                              : () async {
                                  final success = await controller.createInvoice(
                                    maPhong: controller.selectedRoomId!,
                                    thang: DateTime.now().month,
                                    nam: DateTime.now().year,
                                    soDienCu: controller.soDienCu,
                                    soDienMoi: controller.soDienMoi,
                                    soNuocCu: controller.soNuocCu,
                                    soNuocMoi: controller.soNuocMoi,
                                    donGiaDien: controller.donGiaDien,
                                    donGiaNuoc: controller.donGiaNuoc,
                                    phuPhi: controller.phuPhi,
                                  );

                                  if (mounted) {
                                    if (success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Tạo hóa đơn thành công!')),
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(controller.errorMessage ?? 'Có lỗi xảy ra'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A3092),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                          ),
                          child: controller.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Lưu & Xuất hóa đơn',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ),
          

        ],
      ),
    ),
    );
  }
}
