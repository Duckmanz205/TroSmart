import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:provider/provider.dart";
import 'package:trosmart/views/admin/AD_ThemHoaDon.dart';
import '../../logic/admin/invoice_controller.dart';
import '../../models/admin/invoice_model.dart';
import '../../views/admin/AD_DuyetThanhToan.dart';
import '../../views/admin/AD_ChiTietHoaDon.dart';
import '../../services/thong_bao_service.dart';
import '../../models/thong_bao.dart';

class SectionTitleAction extends StatelessWidget {
  const SectionTitleAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thu & Thuê',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Quản lý hóa đơn',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (routeCtx) => ChangeNotifierProvider.value(
                      value: context.read<InvoiceController>(),
                      child: const ApprovePaymentScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.fact_check_rounded, color: Colors.white, size: 14),
              label: const Text('Duyệt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6E589E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
            ),
            const SizedBox(width: 6),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddInvoiceScreen()));
                if (context.mounted) {
                  final controller = context.read<InvoiceController>();
                  controller.fetchInvoices(controller.selectedMonth, controller.selectedYear);
                }
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 14),
              label: const Text('Tạo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2DDCB1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                shadowColor: const Color(0xFF2DDCB1).withOpacity(0.3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SummaryGrid extends StatelessWidget {
  const SummaryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<InvoiceController>();

    return Row(
      children: [
        Expanded(child: StatCard(
          icon: Icons.check_circle_outline, 
          value: (controller.totalDaThu / 1000000).toStringAsFixed(1), 
          label: 'Đã thu (${controller.countDaThu})', 
          color: Colors.tealAccent,
        )),
        const SizedBox(width: 12),
        Expanded(child: StatCard(
          icon: Icons.access_time, 
          value: (controller.totalChoThu / 1000000).toStringAsFixed(1), 
          label: 'Chờ thu (${controller.countChoThu})', 
          color: Colors.amberAccent,
        )),
        const SizedBox(width: 12),
        Expanded(child: StatCard(
          icon: Icons.warning_amber_rounded, 
          value: (controller.totalQuaHan / 1000000).toStringAsFixed(1), 
          label: 'Quá hạn (${controller.countQuaHan})', 
          color: Colors.redAccent,
        )),
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

  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ';
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<InvoiceController>();

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(controller.errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => controller.fetchInvoices(controller.selectedMonth, controller.selectedYear),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (controller.invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              "Chưa có hóa đơn nào trong tháng ${controller.selectedMonth}/${controller.selectedYear}.",
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: controller.invoices.map((inv) {
        // Xác định trạng thái hiển thị
        String status;
        if (inv.trangThai == 'Đã thanh toán') {
          status = 'paid';
        } else if (inv.trangThai == 'Quá hạn') {
          status = 'overdue';
        } else {
          status = 'pending';
        }
        
        return InvoiceCard(
          invoice: inv,
          room: inv.tenPhong.isNotEmpty ? 'Phòng ${inv.tenPhong}' : 'Phòng ${inv.maPhong}',
          tenant: inv.tenKhachThue.isNotEmpty ? inv.tenKhachThue : 'Chưa xác định',
          amount: formatCurrency(inv.tongTien),
          deadline: inv.hanThanhToanDisplay, 
          status: status,
        );
      }).toList(),
    );
  }
}

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  final String room;
  final String tenant;
  final String amount;
  final String deadline;
  final String status;

  const InvoiceCard({
    required this.invoice,
    required this.room, 
    required this.tenant, 
    required this.amount, 
    required this.deadline, 
    required this.status, 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == 'paid' ? const Color(0xFF2DDCB1) : (status == 'overdue' ? Colors.redAccent : Colors.orange);
    String statusText = status == 'paid' ? 'ĐÃ THANH TOÁN' : (status == 'overdue' ? 'QUÁ HẠN' : 'CHỜ THANH TOÁN');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (routeContext) => ChangeNotifierProvider.value(
              value: context.read<InvoiceController>(),
              child: InvoiceDetailsScreen(invoice: invoice),
            ),
          ),
        );
      },
      child: Container(
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
              Expanded(
                child: Row(
                  children: [
                    Text(room, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(tenant, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Text(statusText, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Hiển thị tên cơ sở
          if (invoice.tenCoSo.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(invoice.tenCoSo, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: status == 'overdue' ? Colors.redAccent : const Color(0xFF2DDCB1))),
              Text('Hạn: $deadline', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5))),
            ],
          ),
          if (status != 'paid') ...[
            const SizedBox(height: 16),
            InkWell(
              onTap: invoice.maKhach == null || invoice.maKhach == 0
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Phòng chưa có khách thuê được gán hợp đồng hiệu lực!'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  : () async {
                      try {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đang gửi nhắc nhở đến người thuê...')),
                        );
                        
                        final success = await ThongBaoService().sendThongBao(
                          ThongBao(
                            maThongBao: 0,
                            maKhach: invoice.maKhach!,
                            tieuDe: status == 'overdue' 
                                ? 'Nhắc nhở đóng tiền phòng quá hạn 🚨' 
                                : 'Nhắc nhở thanh toán hóa đơn tiền phòng 💸',
                            noiDung: 'Hóa đơn tháng ${invoice.thang}/${invoice.nam} của phòng ${invoice.tenPhong} với số tiền $amount cần được thanh toán. Hạn chót: $deadline. Vui lòng kiểm tra và thanh toán sớm!',
                            daDoc: false,
                            ngayGui: DateTime.now(),
                            loaiThongBao: 'Hệ thống',
                          ),
                        );
                        
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã gửi nhắc nhở thành công!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gửi nhắc nhở thất bại. Vui lòng thử lại!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lỗi: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              borderRadius: BorderRadius.circular(16),
              child: Container(
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
            ),
          ],
        ],
      ),
    ),
    );
  }
}