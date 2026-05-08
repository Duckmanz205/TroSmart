import 'package:flutter/material.dart';

import '../../logic/admin/co_so_service.dart';
import '../../models/admin/co_so_detail_model.dart';

class DeleteCoSoView extends StatefulWidget {
  final CoSoDetailModel coSo;

  const DeleteCoSoView({
    super.key,
    required this.coSo,
  });

  @override
  State<DeleteCoSoView> createState() => _DeleteCoSoViewState();
}

class _DeleteCoSoViewState extends State<DeleteCoSoView> {
  final CoSoService _service = CoSoService();
  final TextEditingController _reasonController = TextEditingController();

  bool _confirmed = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    if (!_confirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn cần xác nhận đã kiểm tra kỹ trước khi xóa'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _service.deleteCoSo(widget.coSo.maCoSo);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa cơ sở'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể xóa: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goBack() {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    final coSo = widget.coSo;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE8E8),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: const Icon(
                          Icons.priority_high_rounded,
                          color: Color(0xFFFF4D4F),
                          size: 34,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Center(
                      child: Text(
                        'HÀNH ĐỘNG KHÔNG THỂ HOÀN TÁC',
                        style: TextStyle(
                          color: Color(0xFFFF4D4F),
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildWarningBox(),
                    const SizedBox(height: 18),
                    _sectionLabel('ĐANG CHỌN XÓA:'),
                    const SizedBox(height: 8),
                    _buildSelectedCoSoBox(coSo.tenCoSo),
                    const SizedBox(height: 16),
                    _sectionLabel('Lý do xóa / lưu vào lịch sử'),
                    const SizedBox(height: 8),
                    _buildReasonBox(),
                    const SizedBox(height: 14),
                    _buildConfirmCheckbox(),
                    const SizedBox(height: 20),
                    _buildDeleteButton(),
                    const SizedBox(height: 10),
                    _buildBackButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFA65ED3),
            Color(0xFF3B284D),
          ],
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: 24,
          ),
          const Spacer(),
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: const Color(0xFF20E6B8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.home_rounded,
              color: Color(0xFF252032),
              size: 17,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'TroSmart',
            style: TextStyle(
              color: Color(0xFF27EFC2),
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF132B34).withOpacity(0.75),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 6,
                  color: Color(0xFF24E6B5),
                ),
                SizedBox(width: 5),
                Text(
                  'Chủ trọ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF742EA1),
            Color(0xFF9C4FC1),
          ],
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          GestureDetector(
            onTap: _goBack,
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 19,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Xác nhận xóa cơ sở',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFF4D4F).withOpacity(0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Hệ quả khi xóa cơ sở này:',
            style: TextStyle(
              color: Color(0xFF191622),
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 10),
          _WarningLine(text: 'Xóa vĩnh viễn 20 phòng thuộc cơ sở.'),
          SizedBox(height: 8),
          _WarningLine(text: 'Hủy toàn bộ hợp đồng của 15 khách thuê.'),
          SizedBox(height: 8),
          _WarningLine(text: 'Mất toàn bộ lịch sử hóa đơn dịch vụ.'),
        ],
      ),
    );
  }

  Widget _buildSelectedCoSoBox(String tenCoSo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F0FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tenCoSo,
        style: const TextStyle(
          color: Color(0xFF7B2CBF),
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildReasonBox() {
    return TextField(
      controller: _reasonController,
      maxLines: 4,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: Color(0xFF191622),
      ),
      decoration: InputDecoration(
        hintText: 'VD: Ngưng kinh doanh tại địa điểm này...',
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.32),
          fontSize: 11.5,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(13),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            color: const Color(0xFF8A36B0).withOpacity(0.22),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(
            color: Color(0xFF8A36B0),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _confirmed,
          activeColor: const Color(0xFFFF4D4F),
          onChanged: (value) {
            setState(() {
              _confirmed = value ?? false;
            });
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Tôi đã kiểm tra kỹ và chấp nhận mọi rủi ro.',
              style: TextStyle(
                color: Colors.black.withOpacity(0.68),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _delete,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF4D4F),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Xác nhận xóa vĩnh viễn',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
      ),
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: _isLoading ? null : _goBack,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF7B2CBF),
          side: const BorderSide(
            color: Color(0xFF7B2CBF),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: const Text(
          'Quay lại',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black.withOpacity(0.48),
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black.withOpacity(0.15),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(
            icon: Icons.home_rounded,
            label: 'Trang chủ',
          ),
          _BottomNavItem(
            icon: Icons.receipt_long_rounded,
            label: 'Hóa đơn',
          ),
          _BottomNavItem(
            icon: Icons.apartment_rounded,
            label: 'Phòng',
          ),
          _BottomNavItem(
            icon: Icons.person_rounded,
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}

class _WarningLine extends StatelessWidget {
  final String text;

  const _WarningLine({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.circle,
          size: 6,
          color: Color(0xFFFF4D4F),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black.withOpacity(0.55),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BottomNavItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF5C5C64),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF5C5C64),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}