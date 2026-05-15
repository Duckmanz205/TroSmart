import 'package:dio/dio.dart';
import '../../models/admin/invoice_model.dart';

class InvoiceService {
  static const String baseUrl = 'http://10.0.2.2:5137/api';
  
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<InvoiceModel>> getInvoices(int month, int year) async {
    try {
      final response = await _dio.get('/Invoice', queryParameters: {
        'month': month,
        'year': year,
      });

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((item) => InvoiceModel.fromJson(item)).toList();
      }
      throw Exception('Không tải được danh sách hóa đơn.');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Lỗi hệ thống: $e');
    }
  }

  Future<InvoiceModel> getInvoiceById(int id) async {
    try {
      final response = await _dio.get('/Invoice/$id');
      if (response.statusCode == 200) {
        return InvoiceModel.fromJson(response.data);
      }
      throw Exception('Không tải được chi tiết hóa đơn.');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Lỗi hệ thống: $e');
    }
  }

  Future<InvoiceModel> createInvoice({
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
    try {
      final response = await _dio.post(
        '/Invoice',
        data: {
          'maPhong': maPhong,
          'thang': thang,
          'nam': nam,
          'soDienCu': soDienCu,
          'soDienMoi': soDienMoi,
          'soNuocCu': soNuocCu,
          'soNuocMoi': soNuocMoi,
          'donGiaDien': donGiaDien,
          'donGiaNuoc': donGiaNuoc,
          'phuPhi': phuPhi,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return InvoiceModel.fromJson(response.data);
      }
      throw Exception('Không tạo được hóa đơn.');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Lỗi hệ thống: $e');
    }
  }

  Future<void> updateInvoiceStatus(int id, String trangThai) async {
    try {
      final response = await _dio.put(
        '/Invoice/$id/status',
        data: {
          'trangThai': trangThai,
        },
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Không cập nhật được trạng thái.');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Lỗi hệ thống: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableRooms() async {
    try {
      // Gọi API lấy danh sách phòng để lập hóa đơn
      final response = await _dio.get('/Phong');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((room) => {
          'id': room['maPhong'],
          'name': 'Phòng ${room['soPhong']} - ${room['trangThai']}',
          'soDienCu': 0.0, // Chỗ này thực tế cần API lấy số điện/nước cũ của tháng trước, tạm đặt 0.0
          'soNuocCu': 0.0,
          'tienPhong': (room['giaThue'] ?? 0).toDouble(),
        }).toList();
      }
      throw Exception('Không tải được danh sách phòng.');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Lỗi hệ thống: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || 
        e.type == DioExceptionType.receiveTimeout) {
      return Exception('Kết nối mạng quá hạn. Vui lòng kiểm tra internet.');
    } else if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      final errorMessage = e.response?.data?['message'] ?? e.message;
      
      if (statusCode == 400) {
        return Exception('Dữ liệu không hợp lệ: $errorMessage');
      } else if (statusCode == 404) {
        return Exception('Không tìm thấy dữ liệu: $errorMessage');
      } else if (statusCode == 500) {
        return Exception('Lỗi máy chủ (500). Vui lòng thử lại sau.');
      }
      return Exception('Lỗi hệ thống ($statusCode): $errorMessage');
    }
    return Exception('Không thể kết nối đến máy chủ. Kiểm tra baseUrl và mạng.');
  }
}
