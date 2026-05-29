import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import '../../logic/admin/co_so_service.dart';
import '../../models/admin/co_so_detail_model.dart';
import '../../models/admin/co_so_image_model.dart';
import '../../models/admin/tien_ich_model.dart';
import 'AD_XoaCoSo.dart';

class EditCoSoView extends StatefulWidget {
  final CoSoDetailModel coSo;

  const EditCoSoView({
    super.key,
    required this.coSo,
  });

  @override
  State<EditCoSoView> createState() => _EditCoSoViewState();
}

class _EditCoSoViewState extends State<EditCoSoView> {
  final _formKey = GlobalKey<FormState>();
  final CoSoService _service = CoSoService();
  final ImagePicker _imagePicker = ImagePicker();

  static const List<String> _loaiHinhItems = [
    'Nhà trọ',
    'KTX',
    'Chung cư',
  ];

  late final TextEditingController _tenCoSoController;
  late final TextEditingController _diaChiController;
  late final TextEditingController _sdtController;
  late final TextEditingController _emailController;
  late final TextEditingController _moTaController;

  late String _loaiHinh;
  bool _isLoading = false;

  String? _existingDisplayImagePath;
  final List<_PickedFacilityImage> _pickedImages = [];
  int? _selectedPickedImageIndex;

  double? _latitude;
  double? _longitude;

  List<TienIchModel> _tienIchList = [];
  final Set<int> _selectedTienIchIds = {};
  bool _isLoadingTienIch = true;
  bool _isCreatingTienIch = false;

  @override
  void initState() {
    super.initState();

    _tenCoSoController = TextEditingController(text: widget.coSo.tenCoSo);
    _diaChiController = TextEditingController(text: widget.coSo.diaChi);
    _sdtController = TextEditingController(
      text: widget.coSo.soDienThoaiQuanLy ?? '',
    );
    _emailController = TextEditingController(
      text: widget.coSo.emailQuanLy ?? '',
    );
    _moTaController = TextEditingController(
      text: widget.coSo.moTa ?? '',
    );

    _loaiHinh = _normalizeLoaiHinh(widget.coSo.loaiHinh);
    _existingDisplayImagePath = widget.coSo.hinhAnhCoSo;
    _latitude = widget.coSo.latitude;
    _longitude = widget.coSo.longitude;

    for (final item in widget.coSo.tienIches) {
      _selectedTienIchIds.add(item.maTienIch);
    }

    _loadTienIch();
  }

  String _normalizeLoaiHinh(String? value) {
    final raw = (value ?? '').trim();

    if (_loaiHinhItems.contains(raw)) {
      return raw;
    }

    switch (raw.toLowerCase()) {
      case 'nhà trọ tự quản':
        return 'Nhà trọ';
      case 'chung cư mini':
        return 'Chung cư';
      default:
        return 'Nhà trọ';
    }
  }

  Future<void> _loadTienIch() async {
    try {
      final data = await _service.getTienIchList();
      if (!mounted) return;

      data.sort((a, b) => a.tenTienIch.compareTo(b.tenTienIch));

      setState(() {
        _tienIchList = data;
        _isLoadingTienIch = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoadingTienIch = false;
      });
    }
  }

  bool _containsTienIchName(String ten) {
    final normalized = ten.trim().toLowerCase();
    return _tienIchList.any(
      (e) => e.tenTienIch.trim().toLowerCase() == normalized,
    );
  }

  Future<void> _openAddTienIchDialog() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Thêm tiện ích mới',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Ví dụ: Hồ bơi, Thang máy, Gym...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty) return;
                Navigator.pop(dialogContext, text);
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result == null || result.trim().isEmpty) return;
    await _createTienIchAndSelect(result.trim());
  }

  Future<void> _createTienIchAndSelect(String tenTienIch) async {
    if (_containsTienIchName(tenTienIch)) {
      final existed = _tienIchList.firstWhere(
        (e) => e.tenTienIch.trim().toLowerCase() == tenTienIch.trim().toLowerCase(),
      );

      setState(() {
        _selectedTienIchIds.add(existed.maTienIch);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tiện ích đã tồn tại, đã tự chọn cho cơ sở')),
      );
      return;
    }

    setState(() {
      _isCreatingTienIch = true;
    });

    try {
      final created = await _service.createTienIch(tenTienIch: tenTienIch);

      if (!mounted) return;

      setState(() {
        _tienIchList = [..._tienIchList, created]
          ..sort((a, b) => a.tenTienIch.compareTo(b.tenTienIch));
        _selectedTienIchIds.add(created.maTienIch);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm tiện ích mới')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể thêm tiện ích: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingTienIch = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tenCoSoController.dispose();
    _diaChiController.dispose();
    _sdtController.dispose();
    _emailController.dispose();
    _moTaController.dispose();
    super.dispose();
  }

  void _goBack() {
    Navigator.pop(context, false);
  }

  Future<void> _pickImagesFromDevice() async {
    try {
      final files = await _imagePicker.pickMultiImage(imageQuality: 85);

      if (files.isEmpty) return;

      final newItems = <_PickedFacilityImage>[];

      for (final file in files) {
        final bytes = await file.readAsBytes();
        newItems.add(
          _PickedFacilityImage(
            name: file.name,
            bytes: bytes,
            file: file,
          ),
        );
      }

      setState(() {
        _pickedImages.addAll(newItems);

        if (_selectedPickedImageIndex == null &&
            (_existingDisplayImagePath == null ||
                _existingDisplayImagePath!.isEmpty)) {
          _selectedPickedImageIndex = 0;
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể chọn ảnh: $e')),
      );
    }
  }

  void _selectExistingImage() {
    setState(() {
      _selectedPickedImageIndex = null;
    });
  }

  void _selectPickedImage(int index) {
    setState(() {
      _selectedPickedImageIndex = index;
    });
  }

  void _removePickedImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);

      if (_pickedImages.isEmpty) {
        _selectedPickedImageIndex = null;
        return;
      }

      if (_selectedPickedImageIndex == index) {
        _selectedPickedImageIndex = 0;
      } else if (_selectedPickedImageIndex != null &&
          _selectedPickedImageIndex! > index) {
        _selectedPickedImageIndex = _selectedPickedImageIndex! - 1;
      }
    });
  }

  Widget _buildCurrentDisplayImage() {
    if (_selectedPickedImageIndex != null &&
        _selectedPickedImageIndex! >= 0 &&
        _selectedPickedImageIndex! < _pickedImages.length) {
      return Image.memory(
        _pickedImages[_selectedPickedImageIndex!].bytes,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_existingDisplayImagePath != null &&
        _existingDisplayImagePath!.trim().isNotEmpty) {
      final path = _existingDisplayImagePath!.trim();

      if (path.startsWith('assets/')) {
        return Image.asset(
          path,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
        );
      }

      return Image.network(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
      );
    }

    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFF4EDF8),
      child: const Center(
        child: Icon(
          Icons.add_photo_alternate_outlined,
          color: Color(0xFF7B2CBF),
          size: 40,
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _service.updateCoSo(
        maCoSo: widget.coSo.maCoSo,
        tenCoSo: _tenCoSoController.text.trim(),
        diaChi: _diaChiController.text.trim(),
        loaiHinh: _loaiHinh,
        moTa: _moTaController.text.trim(),
        maQuanLy: widget.coSo.maQuanLy,
        latitude: _latitude,
        longitude: _longitude,
        maTienIchIds: _selectedTienIchIds.toList(),
      );

      int? mainImageId;

      if (_pickedImages.isNotEmpty) {
        final uploadedImages = <CoSoImageModel>[];

        for (final item in _pickedImages) {
          final uploaded = await _service.uploadCoSoImage(
            maCoSo: widget.coSo.maCoSo,
            file: item.file,
          );
          uploadedImages.add(uploaded);
        }

        if (_selectedPickedImageIndex != null &&
            _selectedPickedImageIndex! >= 0 &&
            _selectedPickedImageIndex! < uploadedImages.length) {
          mainImageId = uploadedImages[_selectedPickedImageIndex!].maAnh;
        } else if (uploadedImages.isNotEmpty) {
          mainImageId = uploadedImages.first.maAnh;
        }
      }

      if (mainImageId != null) {
        await _service.setMainCoSoImage(mainImageId);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật cơ sở thành công'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể cập nhật: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openDeletePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeleteCoSoView(coSo: widget.coSo),
      ),
    );

    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackRow(),
              const SizedBox(height: 14),
              _buildHeaderCard(),
              const SizedBox(height: 16),
              _buildFormCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackRow() {
    return GestureDetector(
      onTap: _goBack,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xFF191622),
          ),
          SizedBox(width: 6),
          Text(
            'Quay lại',
            style: TextStyle(
              color: Color(0xFF191622),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF742EA1),
            Color(0xFF9C4FC1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Chỉnh sửa cơ sở',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _sectionTitle('ẢNH CƠ SỞ ĐANG HIỂN THỊ'),
            const SizedBox(height: 10),
            _buildDisplayImageCard(),
            const SizedBox(height: 12),
            _buildImageActions(),
            const SizedBox(height: 12),
            _buildImageChooserList(),
            const SizedBox(height: 20),
            _sectionTitle('THÔNG TIN CHI TIẾT'),
            const SizedBox(height: 10),
            _inputField(
              controller: _tenCoSoController,
              label: 'Tên cơ sở / tòa nhà',
              hint: 'Cơ sở Quận 7 - Luxury',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập tên cơ sở';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            _inputField(
              controller: _diaChiController,
              label: 'Địa chỉ',
              hint: '123 Nguyễn Văn Linh, P. Tân Phong',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập địa chỉ';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            _inputField(
              controller: _sdtController,
              label: 'SĐT liên hệ',
              hint: '',
              readOnly: true,
            ),
            const SizedBox(height: 10),
            _inputField(
              controller: _emailController,
              label: 'Email quản lý',
              hint: '',
              readOnly: true,
            ),
            const SizedBox(height: 10),
            _inputField(
              controller: _moTaController,
              label: 'Mô tả',
              hint: 'Nhập mô tả cơ sở',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _loaiHinhDropdown(),
            const SizedBox(height: 18),
            _sectionTitle('TIỆN ÍCH CƠ SỞ'),
            const SizedBox(height: 10),
            _buildTienIchToolbar(),
            const SizedBox(height: 10),
            _buildTienIchSelector(),
            const SizedBox(height: 18),
            _sectionTitle('CẬP NHẬT VỊ TRÍ MAP'),
            const SizedBox(height: 10),
            _buildMapEditor(),
            const SizedBox(height: 10),
            _buildCoordinateInfo(),
            const SizedBox(height: 18),
            _buildSaveButton(),
            const SizedBox(height: 10),
            _buildDeleteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTienIchToolbar() {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${_selectedTienIchIds.length} tiện ích đã chọn',
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.58),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: (_isLoading || _isCreatingTienIch) ? null : _openAddTienIchDialog,
          icon: _isCreatingTienIch
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add_rounded, size: 16),
          label: const Text(
            'Thêm tiện ích mới',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF7430A3),
            side: BorderSide(
              color: const Color(0xFF7430A3).withValues(alpha: 0.35),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTienIchSelector() {
    if (_isLoadingTienIch) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_tienIchList.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F7FB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('Chưa có dữ liệu tiện ích'),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _tienIchList.map((item) {
          final selected = _selectedTienIchIds.contains(item.maTienIch);

          return FilterChip(
            selected: selected,
            label: Text(item.tenTienIch),
            onSelected: (value) {
              setState(() {
                if (value) {
                  _selectedTienIchIds.add(item.maTienIch);
                } else {
                  _selectedTienIchIds.remove(item.maTienIch);
                }
              });
            },
            selectedColor: const Color(0xFFEBDCF6),
            checkmarkColor: const Color(0xFF7430A3),
            labelStyle: TextStyle(
              color: selected
                  ? const Color(0xFF7430A3)
                  : const Color(0xFF191622),
              fontWeight: FontWeight.w700,
            ),
            side: BorderSide(
              color: selected
                  ? const Color(0xFF7430A3)
                  : Colors.black.withValues(alpha: 0.12),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDisplayImageCard() {
    return Container(
      width: double.infinity,
      height: 190,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF4EDF8),
        border: Border.all(
          color: const Color(0xFF8A36B0).withValues(alpha: 0.14),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildCurrentDisplayImage(),
          Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Ảnh đang hiển thị',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _pickImagesFromDevice,
            icon: const Icon(Icons.upload_rounded, size: 18),
            label: const Text(
              'Chọn ảnh từ máy',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7430A3),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageChooserList() {
    final hasExistingImage = _existingDisplayImagePath != null &&
        _existingDisplayImagePath!.trim().isNotEmpty;

    if (!hasExistingImage && _pickedImages.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F7FB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ),
        child: Text(
          'Chưa có ảnh nào. Bạn hãy chọn ảnh từ máy để preview và chọn ảnh hiển thị.',
          style: TextStyle(
            color: Colors.black.withValues(alpha: 0.55),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasExistingImage) ...[
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ảnh hiện tại từ hệ thống',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF191622),
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _selectExistingImage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _selectedPickedImageIndex == null
                    ? const Color(0xFFF4EDF8)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _selectedPickedImageIndex == null
                      ? const Color(0xFF7B2CBF)
                      : Colors.black.withValues(alpha: 0.07),
                  width: _selectedPickedImageIndex == null ? 1.4 : 1,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 78,
                      height: 78,
                      child: _buildCurrentExistingThumb(
                        _existingDisplayImagePath!,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Dùng ảnh cơ sở hiện tại',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF191622),
                      ),
                    ),
                  ),
                  if (_selectedPickedImageIndex == null)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF7B2CBF),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (_pickedImages.isNotEmpty) ...[
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ảnh mới chọn từ máy',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF191622),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(_pickedImages.length, (index) {
              final item = _pickedImages[index];
              final isSelected = _selectedPickedImageIndex == index;

              return GestureDetector(
                onTap: () => _selectPickedImage(index),
                child: Container(
                  width: 96,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFF4EDF8)
                        : const Color(0xFFF9F7FB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF7B2CBF)
                          : Colors.black.withValues(alpha: 0.06),
                      width: isSelected ? 1.4 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              item.bytes,
                              width: 84,
                              height: 84,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removePickedImage(index),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF4D4F),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isSelected ? 'Ảnh hiển thị' : 'Chọn hiển thị',
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF7B2CBF)
                              : const Color(0xFF191622),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildCurrentExistingThumb(String path) {
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _thumbPlaceholder();
        },
      );
    }

    return Image.network(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _thumbPlaceholder();
      },
    );
  }

  Widget _thumbPlaceholder() {
    return Container(
      color: const Color(0xFFF4EDF8),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: Color(0xFF7B2CBF),
        ),
      ),
    );
  }

Widget _buildMapEditor() {
  final currentPoint = LatLng(
    _latitude ?? 10.7769,
    _longitude ?? 106.7009,
  );

  return Container(
    height: 240,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color(0xFF8A36B0).withOpacity(0.14),
      ),
    ),
    child: FlutterMap(
      options: MapOptions(
        initialCenter: currentPoint,
        initialZoom: 15.5,

        onTap: (tapPosition, point) {
          setState(() {
            _latitude = point.latitude;
            _longitude = point.longitude;
          });
        },
      ),

      children: [
        TileLayer(
          // ===== FIX ACCESS BLOCKED =====
          urlTemplate:
              'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',

          subdomains: const ['a', 'b', 'c'],

          userAgentPackageName: 'com.example.trosmart',

          maxZoom: 19,

          tileDisplay: const TileDisplay.fadeIn(),
        ),

        if (_latitude != null && _longitude != null)
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(_latitude!, _longitude!),

                width: 42,
                height: 42,

                child: const Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFF7B2CBF),
                  size: 38,
                ),
              ),
            ],
          ),
      ],
    ),
  );
}

  Widget _buildCoordinateInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F7FB),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bấm trực tiếp lên bản đồ để chọn vị trí mới',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF191622),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Latitude: ${_latitude?.toStringAsFixed(6) ?? 'Chưa có'}',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Colors.black.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Longitude: ${_longitude?.toStringAsFixed(6) ?? 'Chưa có'}',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Colors.black.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loaiHinhDropdown() {
    final safeValue = _loaiHinhItems.contains(_loaiHinh)
        ? _loaiHinh
        : 'Nhà trọ';

    return DropdownButtonFormField<String>(
      value: safeValue,
      decoration: _inputDecoration(
        label: 'Loại hình',
        hint: '',
      ),
      items: _loaiHinhItems.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _loaiHinh = value;
        });
      },
      style: const TextStyle(
        color: Color(0xFF191622),
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _save,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7430A3),
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
                'Lưu cập nhật',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton(
        onPressed: _isLoading ? null : _openDeletePage,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFFF4D4F),
          side: const BorderSide(
            color: Color(0xFFFF4D4F),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        child: const Text(
          'Xóa cơ sở',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF7B2CBF),
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      style: const TextStyle(
        color: Color(0xFF191622),
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
      ),
      decoration: _inputDecoration(
        label: label,
        hint: hint,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      labelText: label.isEmpty ? null : label,
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.black.withValues(alpha: 0.35),
        fontSize: 11.5,
        fontWeight: FontWeight.w500,
      ),
      labelStyle: TextStyle(
        color: Colors.black.withValues(alpha: 0.55),
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: const Color(0xFF8A36B0).withValues(alpha: 0.22),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFF8A36B0),
          width: 1.2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFFF4D4F),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFFF4D4F),
        ),
      ),
    );
  }
}

class _PickedFacilityImage {
  final String name;
  final Uint8List bytes;
  final XFile file;

  _PickedFacilityImage({
    required this.name,
    required this.bytes,
    required this.file,
  });
}