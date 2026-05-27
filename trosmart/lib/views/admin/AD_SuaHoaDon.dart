import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/admin/invoice_controller.dart';
import '../../models/admin/invoice_model.dart';
import '../../widgets/admin/add_invoice_widgets.dart';

class EditInvoiceScreen extends StatefulWidget {
  final InvoiceModel invoice;
  const EditInvoiceScreen({super.key, required this.invoice});

  @override
  State<EditInvoiceScreen> createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
  late TextEditingController _dienMoiCtrl;
  late TextEditingController _nuocMoiCtrl;
  late TextEditingController _phuPhiCtrl;
  late TextEditingController _tenPhuPhiCtrl;
  bool sendNotify = false;

  @override
  void initState() {
    super.initState();
    _dienMoiCtrl = TextEditingController(text: widget.invoice.soDienMoi.toInt().toString());
    _nuocMoiCtrl = TextEditingController(text: widget.invoice.soNuocMoi.toInt().toString());
    _phuPhiCtrl = TextEditingController(text: widget.invoice.phuPhi > 0 ? widget.invoice.phuPhi.toStringAsFixed(0) : '');
    _tenPhuPhiCtrl = TextEditingController(text: widget.invoice.moTaPhuPhi ?? '');
  }

  @override
  void dispose() {
    _dienMoiCtrl.dispose();
    _nuocMoiCtrl.dispose();
    _phuPhiCtrl.dispose();
    _tenPhuPhiCtrl.dispose();
    super.dispose();
  }

  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ';
  }

  double get _calculatedTotal {
    final dienMoi = double.tryParse(_dienMoiCtrl.text) ?? widget.invoice.soDienMoi;
    final nuocMoi = double.tryParse(_nuocMoiCtrl.text) ?? widget.invoice.soNuocMoi;
    final phuPhi = double.tryParse(_phuPhiCtrl.text) ?? 0;
    
    final tienDien = (dienMoi - widget.invoice.soDienCu) * widget.invoice.donGiaDien;
    final tienNuoc = (nuocMoi - widget.invoice.soNuocCu) * widget.invoice.donGiaNuoc;
    return widget.invoice.tienPhong + tienDien + tienNuoc + phuPhi;
  }

  @override
  Widget build(BuildContext context) {
    final inv = widget.invoice;

    return ChangeNotifierProvider(
      create: (_) => InvoiceController(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Stack(
          children: [
            const HeaderSection(),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Title
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chỉnh sửa hóa đơn',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Mã: #INV-${inv.maHoaDon} | Phòng ${inv.tenPhong}',
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Form Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: StatefulBuilder(
                        builder: (context, setInnerState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Phòng (ReadOnly)
                              const FormLabel(label: 'PHÒNG'),
                              const SizedBox(height: 8),
                              FeeDisplay(text: 'Phòng ${inv.tenPhong} - ${inv.tenCoSo}'),

                              const SizedBox(height: 20),

                              // Tháng/Năm (ReadOnly)
                              const FormLabel(label: 'KỲ HÓA ĐƠN'),
                              const SizedBox(height: 8),
                              FeeDisplay(text: 'Tháng ${inv.thang}/${inv.nam}'),

                              const SizedBox(height: 24),
                              FormLabel(label: 'CHỈ SỐ ĐIỆN', subLabel: '(⚡ ${formatCurrency(inv.donGiaDien)}/kWh)'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: ReadingInput(label: 'Cũ: ${inv.soDienCu.toInt()}', value: inv.soDienCu.toInt().toString(), isReadOnly: true)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ReadingInput(
                                      label: 'Mới *',
                                      value: _dienMoiCtrl.text,
                                      onChanged: (val) => setInnerState(() => _dienMoiCtrl.text = val),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),
                              FormLabel(label: 'CHỈ SỐ NƯỚC', subLabel: '(💧 ${formatCurrency(inv.donGiaNuoc)}/m3)'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: ReadingInput(label: 'Cũ: ${inv.soNuocCu.toInt()}', value: inv.soNuocCu.toInt().toString(), isReadOnly: true)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ReadingInput(
                                      label: 'Mới *',
                                      value: _nuocMoiCtrl.text,
                                      onChanged: (val) => setInnerState(() => _nuocMoiCtrl.text = val),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),
                              const FormLabel(label: 'TIỀN PHÒNG'),
                              const SizedBox(height: 8),
                              FeeDisplay(text: 'Phòng: ${formatCurrency(inv.tienPhong)}'),

                              const SizedBox(height: 16),
                              const FormLabel(label: 'PHÍ PHÁT SINH'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _tenPhuPhiCtrl,
                                decoration: const InputDecoration(
                                  hintText: 'Tên chi phí (VD: Sửa máy lạnh...)',
                                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _phuPhiCtrl,
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setInnerState(() {}),
                                decoration: const InputDecoration(
                                  hintText: 'Thành tiền (VNĐ)',
                                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                                  prefixIcon: Icon(Icons.attach_money, color: Color(0xFF6A3092)),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Tổng cộng
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F0FA),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'TỔNG CỘNG THANH TOÁN',
                                      style: TextStyle(
                                        color: Color(0xFF6A3092),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      formatCurrency(_calculatedTotal),
                                      style: const TextStyle(
                                        color: Color(0xFF6A3092),
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      '(Bao gồm: Phòng, Điện, Nước, Phụ phí)',
                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Notify toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Gửi thông báo cập nhật cho khách',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          // TODO: gọi API update invoice (cần thêm endpoint PUT /api/Invoice/{id})
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chức năng cập nhật hóa đơn đang phát triển...')),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A3092),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Lưu thay đổi',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
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
