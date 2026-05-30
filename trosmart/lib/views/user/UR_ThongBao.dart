import 'package:flutter/material.dart';
import '../../shared/app_theme.dart';
import '../../widgets/user/notification_widgets.dart';
import '../../services/thong_bao_service.dart';
import '../../models/thong_bao.dart';

/// User Notification (Thông báo) screen.
class UrThongBao extends StatefulWidget {
  final VoidCallback? onNavigateToPayment;
  const UrThongBao({super.key, this.onNavigateToPayment});

  @override
  State<UrThongBao> createState() => _UrThongBaoState();
}

class _UrThongBaoState extends State<UrThongBao> {
  late Future<List<ThongBao>> _futureThongBao;

  @override
  void initState() {
    super.initState();
    // Giả lập maKhach = 1 (sau này sẽ lấy từ Auth)
    _futureThongBao = ThongBaoService().getThongBaoForUser(1);
  }

  String _formatTimeAgo(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays} NGÀY\nTRƯỚC';
    if (diff.inHours > 0) return '${diff.inHours} GIỜ\nTRƯỚC';
    if (diff.inMinutes > 0) return '${diff.inMinutes} PHÚT\nTRƯỚC';
    return 'VỪA\nXONG';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgSlate,
      body: SafeArea(
        child: Column(
          children: [
            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Thông báo',
                      style: AppTheme.titleMd.copyWith(
                        color: AppTheme.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 1,
                          color: AppTheme.bgGray200,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Cập nhật mới nhất từ hệ thống',
                            style: AppTheme.bodyMd.copyWith(
                              fontStyle: FontStyle.italic,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Notification Cards ──
                    FutureBuilder<List<ThongBao>>(
                      future: _futureThongBao,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Lỗi: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Bạn chưa có thông báo nào.'));
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final thongBao = snapshot.data![index];
                            final isUrgent = thongBao.tieuDe.toLowerCase().contains('khẩn') || 
                                             thongBao.tieuDe.toLowerCase().contains('quá hạn');
                            
                            IconData icon = Icons.notifications_active_outlined;
                            Color themeColor = AppTheme.deepPurple;
                            
                            if (thongBao.tieuDe.toLowerCase().contains('thanh toán') || thongBao.tieuDe.toLowerCase().contains('tiền')) {
                              icon = Icons.payment_outlined;
                              themeColor = AppTheme.statusRed;
                            } else if (thongBao.tieuDe.toLowerCase().contains('sự cố')) {
                              icon = Icons.build_circle_outlined;
                              themeColor = AppTheme.statusYellow;
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: NotificationCard(
                                title: thongBao.tieuDe,
                                description: thongBao.noiDung ?? '',
                                timeAgo: _formatTimeAgo(thongBao.ngayGui),
                                themeColor: themeColor,
                                icon: icon,
                                isUrgent: isUrgent,
                                actionLabel: isUrgent ? 'XEM CHI TIẾT' : null,
                                onActionTap: isUrgent ? widget.onNavigateToPayment : null,
                              ),
                            );
                          },
                        );
                      },
                    ),
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