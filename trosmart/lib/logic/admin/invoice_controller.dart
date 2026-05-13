import 'package:flutter/foundation.dart';
import '../../models/admin/invoice_model.dart';
import 'invoice_service.dart';

class InvoiceController extends ChangeNotifier {
  final InvoiceService _invoiceService = InvoiceService();

  List<InvoiceModel> _invoices = [];
  List<InvoiceModel> get invoices => _invoices;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Form State
  int? selectedRoomId;
  double soDienCu = 0;
  double soDienMoi = 0;
  double soNuocCu = 0;
  double soNuocMoi = 0;
  double tienPhong = 0;
  double phuPhi = 0;
  double donGiaDien = 3500;
  double donGiaNuoc = 20000;

  double get tongTien => 
    tienPhong + 
    ((soDienMoi > soDienCu ? soDienMoi - soDienCu : 0) * donGiaDien) + 
    ((soNuocMoi > soNuocCu ? soNuocMoi - soNuocCu : 0) * donGiaNuoc) + 
    phuPhi;

  List<Map<String, dynamic>> availableRooms = [];

  InvoiceController() {
    fetchAvailableRooms();
    final now = DateTime.now();
    fetchInvoices(now.month, now.year);
  }

  Future<void> fetchAvailableRooms() async {
    _setLoading(true);
    _setError(null);
    try {
      availableRooms = await _invoiceService.getAvailableRooms();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void selectRoom(int roomId) {
    selectedRoomId = roomId;
    final room = availableRooms.firstWhere((r) => r['id'] == roomId);
    soDienCu = room['soDienCu'] ?? 0.0;
    soNuocCu = room['soNuocCu'] ?? 0.0;
    tienPhong = room['tienPhong'] ?? 0.0;
    // Reset chỉ số mới khi đổi phòng
    soDienMoi = 0;
    soNuocMoi = 0;
    phuPhi = 0;
    notifyListeners();
  }

  void updateDienMoi(String value) {
    soDienMoi = double.tryParse(value) ?? 0;
    notifyListeners();
  }

  void updateNuocMoi(String value) {
    soNuocMoi = double.tryParse(value) ?? 0;
    notifyListeners();
  }

  void updatePhuPhi(String value) {
    phuPhi = double.tryParse(value) ?? 0;
    notifyListeners();
  }

  // Lấy danh sách hóa đơn theo tháng và năm
  Future<void> fetchInvoices(int month, int year) async {
    _setLoading(true);
    _setError(null);
    try {
      _invoices = await _invoiceService.getInvoices(month, year);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Lấy chi tiết hóa đơn (thường không cần lưu vào list mà trả về trực tiếp)
  Future<InvoiceModel?> fetchInvoiceDetail(int id) async {
    _setLoading(true);
    _setError(null);
    try {
      final invoice = await _invoiceService.getInvoiceById(id);
      return invoice;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Tạo hóa đơn mới
  Future<bool> createInvoice({
    required int maPhong,
    required int thang,
    required int nam,
    required double soDienCu,
    required double soDienMoi,
    required double soNuocCu,
    required double soNuocMoi,
    required double donGiaDien,
    required double donGiaNuoc,
    required double phuPhi,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final newInvoice = await _invoiceService.createInvoice(
        maPhong: maPhong,
        thang: thang,
        nam: nam,
        soDienCu: soDienCu,
        soDienMoi: soDienMoi,
        soNuocCu: soNuocCu,
        soNuocMoi: soNuocMoi,
        donGiaDien: donGiaDien,
        donGiaNuoc: donGiaNuoc,
        phuPhi: phuPhi,
      );
      
      // Có thể thêm luôn vào danh sách nếu đang xem cùng tháng/năm
      _invoices.add(newInvoice);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Cập nhật trạng thái thanh toán
  Future<bool> updateStatus(int id, String trangThai) async {
    _setLoading(true);
    _setError(null);
    try {
      await _invoiceService.updateInvoiceStatus(id, trangThai);
      
      // Cập nhật UI list nếu tồn tại trong danh sách hiện tại
      final index = _invoices.indexWhere((inv) => inv.maHoaDon == id);
      if (index != -1) {
        final current = _invoices[index];
        _invoices[index] = InvoiceModel(
          maHoaDon: current.maHoaDon,
          maPhong: current.maPhong,
          tenPhong: current.tenPhong,
          thang: current.thang,
          nam: current.nam,
          soDienCu: current.soDienCu,
          soDienMoi: current.soDienMoi,
          soNuocCu: current.soNuocCu,
          soNuocMoi: current.soNuocMoi,
          tienPhong: current.tienPhong,
          phuPhi: current.phuPhi,
          tongTien: current.tongTien,
          trangThai: trangThai,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper cho trạng thái Loading
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Helper cho lỗi
  void _setError(String? message) {
    if (message != null && message.startsWith('Exception: ')) {
      _errorMessage = message.substring(11);
    } else {
      _errorMessage = message;
    }
    notifyListeners();
  }
}
