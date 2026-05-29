import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/thong_bao.dart';
import '../shared/api_constants.dart';

class ThongBaoService {
  // Lấy tất cả thông báo (dành cho Admin)
  Future<List<ThongBao>> getAllThongBao() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/ThongBao');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ThongBao.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load thông báo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối server: $e');
    }
  }

  // Lấy thông báo theo mã khách (dành cho User)
  Future<List<ThongBao>> getThongBaoForUser(int maKhach) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/ThongBao/user/$maKhach');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ThongBao.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load thông báo user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối server: $e');
    }
  }

  // Tạo thông báo mới (Admin)
  Future<bool> sendThongBao(ThongBao thongBao) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/ThongBao');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(thongBao.toJson()),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      throw Exception('Lỗi kết nối server: $e');
    }
  }
}
