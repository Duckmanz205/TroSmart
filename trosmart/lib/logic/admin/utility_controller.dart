import 'package:flutter/foundation.dart';
import 'utility_service.dart';

class UtilityController extends ChangeNotifier {
  final UtilityService _service = UtilityService();

  List<Map<String, dynamic>> _rooms = [];
  List<Map<String, dynamic>> get rooms => _rooms;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  int get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedYear;

  // Map lưu giá trị đang nhập: key = maPhong, value = {dienMoi, nuocMoi}
  final Map<int, Map<String, int?>> _editingValues = {};

  // Đơn giá mặc định
  double donGiaDien = 3500;
  double donGiaNuoc = 20000;

  UtilityController() {
    fetchReadings();
  }

  /// Thống kê
  int get totalRooms => _rooms.length;
  int get enteredRooms => _rooms.where((r) => r['chiSoDienMoi'] != null || _editingValues[r['maPhong']]?['dienMoi'] != null).length;
  int get savedRooms => _rooms.where((r) => r['chiSoDienMoi'] != null && r['chiSoNuocMoi'] != null).length;
  int get vacantRooms => _rooms.where((r) => r['trangThai'] == 'Trống').length;

  void changeMonthYear(int month, int year) {
    _selectedMonth = month;
    _selectedYear = year;
    _editingValues.clear();
    fetchReadings();
  }

  Future<void> fetchReadings() async {
    _setLoading(true);
    _setError(null);
    try {
      _rooms = await _service.getReadings(_selectedMonth, _selectedYear);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Cập nhật giá trị đang nhập cho 1 phòng
  void updateDienMoi(int maPhong, String value) {
    _editingValues[maPhong] ??= {};
    _editingValues[maPhong]!['dienMoi'] = int.tryParse(value);
    notifyListeners();
  }

  void updateNuocMoi(int maPhong, String value) {
    _editingValues[maPhong] ??= {};
    _editingValues[maPhong]!['nuocMoi'] = int.tryParse(value);
    notifyListeners();
  }

  int? getDienMoi(int maPhong) {
    return _editingValues[maPhong]?['dienMoi'];
  }

  int? getNuocMoi(int maPhong) {
    return _editingValues[maPhong]?['nuocMoi'];
  }

  /// Lưu chỉ số cho 1 phòng
  Future<bool> saveRoom(int maPhong) async {
    final room = _rooms.firstWhere((r) => r['maPhong'] == maPhong);
    final dienCu = room['chiSoDienCu'] ?? 0;
    final nuocCu = room['chiSoNuocCu'] ?? 0;
    
    // Lấy giá trị mới: ưu tiên editing, nếu không dùng từ server
    final dienMoi = _editingValues[maPhong]?['dienMoi'] ?? room['chiSoDienMoi'];
    final nuocMoi = _editingValues[maPhong]?['nuocMoi'] ?? room['chiSoNuocMoi'];

    try {
      await _service.saveReading(
        maPhong: maPhong,
        thang: _selectedMonth,
        nam: _selectedYear,
        chiSoDienCu: dienCu,
        chiSoDienMoi: dienMoi,
        chiSoNuocCu: nuocCu,
        chiSoNuocMoi: nuocMoi,
      );

      // Cập nhật UI
      final index = _rooms.indexWhere((r) => r['maPhong'] == maPhong);
      if (index != -1) {
        _rooms[index] = {..._rooms[index], 'chiSoDienMoi': dienMoi, 'chiSoNuocMoi': nuocMoi};
      }
      _editingValues.remove(maPhong);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  /// Lưu tất cả phòng đang có giá trị mới
  Future<bool> saveAll() async {
    _setLoading(true);
    _setError(null);
    try {
      final batchData = <Map<String, dynamic>>[];

      for (final room in _rooms) {
        final maPhong = room['maPhong'] as int;
        final editing = _editingValues[maPhong];
        final dienMoi = editing?['dienMoi'] ?? room['chiSoDienMoi'];
        final nuocMoi = editing?['nuocMoi'] ?? room['chiSoNuocMoi'];

        // Chỉ lưu phòng có chỉ số mới
        if (dienMoi != null || nuocMoi != null) {
          batchData.add({
            'maPhong': maPhong,
            'thang': _selectedMonth,
            'nam': _selectedYear,
            'chiSoDienCu': room['chiSoDienCu'] ?? 0,
            'chiSoDienMoi': dienMoi,
            'chiSoNuocCu': room['chiSoNuocCu'] ?? 0,
            'chiSoNuocMoi': nuocMoi,
          });
        }
      }

      if (batchData.isEmpty) {
        _setError('Không có dữ liệu mới cần lưu.');
        return false;
      }

      await _service.saveBatchReadings(batchData);

      // Refresh dữ liệu
      _editingValues.clear();
      await fetchReadings();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Lấy chỉ số điện nước đã nhập cho 1 phòng (hỗ trợ trang tạo hóa đơn)
  Map<String, dynamic>? getRoomReading(int maPhong) {
    try {
      return _rooms.firstWhere((r) => r['maPhong'] == maPhong);
    } catch (_) {
      return null;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    if (message != null && message.startsWith('Exception: ')) {
      _errorMessage = message.substring(11);
    } else {
      _errorMessage = message;
    }
    notifyListeners();
  }
}
