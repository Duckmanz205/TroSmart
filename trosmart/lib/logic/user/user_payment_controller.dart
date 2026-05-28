import 'package:flutter/foundation.dart';
import '../../models/admin/invoice_model.dart';
import '../admin/invoice_service.dart';

class UserPaymentController extends ChangeNotifier {
  final InvoiceService _service = InvoiceService();

  List<InvoiceModel> _allInvoices = [];
  List<InvoiceModel> get allInvoices => _allInvoices;

  InvoiceModel? _activeInvoice;
  InvoiceModel? get activeInvoice => _activeInvoice;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserPaymentController() {
    loadUserInvoices();
  }

  Future<void> loadUserInvoices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Lấy tất cả hóa đơn từ DB
      final list = await _service.getInvoices(0, 0);
      _allInvoices = list;
      
      if (list.isNotEmpty) {
        // Tìm hóa đơn chưa thanh toán mới nhất, nếu không có thì lấy hóa đơn mới nhất
        final pending = list.where((inv) => inv.trangThai != 'Đã thanh toán').toList();
        if (pending.isNotEmpty) {
          // Lấy hóa đơn có mã lớn nhất
          pending.sort((a, b) => b.maHoaDon.compareTo(a.maHoaDon));
          _activeInvoice = pending.first;
        } else {
          list.sort((a, b) => b.maHoaDon.compareTo(a.maHoaDon));
          _activeInvoice = list.first;
        }
      } else {
        _activeInvoice = null;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> markAsPaid(int invoiceId) async {
    try {
      await _service.updateInvoiceStatus(invoiceId, 'Đã thanh toán');
      // Tải lại danh sách
      await loadUserInvoices();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
