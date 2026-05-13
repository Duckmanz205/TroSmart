import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/co_so.dart';
import '../models/phong.dart';
import '../shared/api_constants.dart';

class CoSoService {
  Future<List<CoSo>> getAllCoSo() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/CoSo');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CoSo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cơ sở: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối server: $e');
    }
  }

  Future<CoSo> getCoSoById(int id) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/CoSo/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return CoSo.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load cơ sở detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối server: $e');
    }
  }

  Future<List<Phong>> getPhongsByCoSoId(int id) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/CoSo/$id/phong');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Phong.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load phòng: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối server: $e');
    }
  }
}
