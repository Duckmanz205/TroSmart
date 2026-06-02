import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/khach_thue.dart';
import '../shared/api_constants.dart';

class KhachThueService {
  Future<KhachThue> getCustomerProfile(int id) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/KhachThue/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return KhachThue.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> updateCustomerProfile(KhachThue profile) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/KhachThue/${profile.maKhach}');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(profile.toJson()),
      );
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
