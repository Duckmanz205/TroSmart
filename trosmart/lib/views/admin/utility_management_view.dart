import 'package:flutter/material.dart';
import '../../shared/app_colors.dart';
import '../../widgets/common/admin/custom_app_bar.dart';
import '../../widgets/admin/utility_management_widgets.dart';

class UtilityManagementView extends StatelessWidget {
  const UtilityManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(), // Tái sử dụng Header của Chủ trọ
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            PageTitleSection(),
            SizedBox(height: 20),
            SaveAllButton(),
            SizedBox(height: 16),
            UtilityStatsGrid(),
            SizedBox(height: 20),
            UtilityFilterSection(),
            SizedBox(height: 20),
            RoomListHeader(),
            SizedBox(height: 12),
            
            // Danh sách các phòng
            RoomUtilityCard(
              roomName: 'Phòng 101',
              tenant: 'Nguyễn Văn An - Tầng 1',
              status: RoomStatus.inputting,
            ),
            SizedBox(height: 16),
            RoomUtilityCard(
              roomName: 'Phòng 102',
              tenant: 'Trần Thị Bích - Tầng 1',
              status: RoomStatus.calculated,
              totalAmount: '427.500đ',
            ),
            SizedBox(height: 16),
            RoomUtilityCard(
              roomName: 'Phòng 201',
              tenant: 'Lê Minh Tuấn - Tầng 2',
              status: RoomStatus.saved,
              totalAmount: '527.000đ',
            ),
            SizedBox(height: 16),
            RoomUtilityCard(
              roomName: 'Phòng 202',
              tenant: 'Chưa có khách thuê - Tầng 2',
              status: RoomStatus.vacant,
            ),
            SizedBox(height: 80), // Padding cho Bottom Nav
          ],
        ),
      ),
    );
  }
}
