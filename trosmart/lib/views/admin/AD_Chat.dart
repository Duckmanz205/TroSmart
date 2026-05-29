import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../shared/app_theme.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/common/app_search_field.dart';
import '../../widgets/chat_widgets.dart';
import '../../logic/admin/chat_controller.dart';
import 'AD_ChiTietChat.dart';

class AdChat extends StatefulWidget {
  const AdChat({super.key});

  @override
  State<AdChat> createState() => _AdChatState();
}

class _AdChatState extends State<AdChat> {
  final ChatController _chatController = ChatController();

  @override
  void initState() {
    super.initState();
    _chatController.fetchRecentChats(1);
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final DateTime date = DateTime.parse(dateStr).toLocal();
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _chatController,
      child: Scaffold(
        backgroundColor: AppTheme.bgWhite,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppGradientHeader(roleLabel: 'Chủ trọ'),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text('Tin nhắn', style: AppTheme.headingXl),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: AppSearchField(hintText: 'Tìm kiếm người thuê...'),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Consumer<ChatController>(
                  builder: (context, controller, child) {
                    if (controller.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.errorMessage != null) {
                      return Center(
                        child: Text(
                          'Lỗi: ${controller.errorMessage}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    if (controller.recentChats.isEmpty) {
                      return const Center(
                        child: Text('Chưa có đoạn chat nào.'),
                      );
                    }
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: controller.recentChats.length,
                      separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
                      itemBuilder: (context, index) {
                        final chat = controller.recentChats[index];
                        final name = chat['tenKhach'] ?? 'Khách';
                        final initials = name.toString().trim().isNotEmpty 
                            ? name.toString().trim()[0].toUpperCase() 
                            : '?';
                        return ChatListItem(
                          initials: initials,
                          name: '$name (P.${chat['soPhong']})',
                          lastMessage: chat['lastMessage'] ?? '',
                          time: _formatTime(chat['ngayGui']),
                          isUnread: chat['isUnread'] ?? false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdChiTietChat(
                                  maKhach: chat['maKhach'],
                                  tenKhach: name,
                                  soPhong: chat['soPhong'].toString(),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
