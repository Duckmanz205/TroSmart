import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../models/admin/phong_model.dart';
import '../../models/admin/phong_view_model.dart';
import '../../models/admin/tien_ich_model.dart';

class PhongService {
  static const String baseUrl = 'http://localhost:5137/api';

  Future<List<PhongModel>> getByCoSo(int maCoSo) async {
    final uri = Uri.parse('$baseUrl/Phong/coso/$maCoSo');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Không tải được danh sách phòng. '
        'Status: ${response.statusCode}, Body: ${response.body}',
      );
    }

    final List data = jsonDecode(response.body);
    return data.map((item) => PhongModel.fromJson(item)).toList();
  }

  Future<List<PhongModel>> getPhongTrong() async {
    final uri = Uri.parse('$baseUrl/Phong/trong');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Không tải được danh sách phòng trống. '
        'Status: ${response.statusCode}, Body: ${response.body}',
      );
    }

    final List data = jsonDecode(response.body);
    return data.map((item) => PhongModel.fromJson(item)).toList();
  }

  Future<List<PhongViewModel>> getPhongView() async {
    final uri = Uri.parse('$baseUrl/Phong/view');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Không tải được dữ liệu tra cứu phòng. '
        'Status: ${response.statusCode}, Body: ${response.body}',
      );
    }

    final List data = jsonDecode(response.body);
    return data.map((item) => PhongViewModel.fromJson(item)).toList();
  }

  Future<PhongModel> getDetail(int maPhong) async {
    final uri = Uri.parse('$baseUrl/Phong/$maPhong');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Không tải được chi tiết phòng. '
        'Status: ${response.statusCode}, Body: ${response.body}',
      );
    }

    final data = jsonDecode(response.body);
    return PhongModel.fromJson(data);
  }

 Future<int> createPhong({
  required String soPhong,
  required num giaThue,
  required String trangThai,
  required int maCoSo,
  int? tang,
  num? dienTich,
  int? soNguoiToiDa,
  String? moTa,
  List<int> maTienIchIds = const [],
}) async {
  final uri = Uri.parse('$baseUrl/Phong');

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'soPhong': soPhong,
      'giaThue': giaThue,
      'trangThai': trangThai,
      'maCoSo': maCoSo,
      'tang': tang,
      'dienTich': dienTich,
      'soNguoiToiDa': soNguoiToiDa,
      'moTa': moTa,
      'maTienIchIds': maTienIchIds,
    }),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception(
      'Không thêm được phòng. Status: ${response.statusCode}, Body: ${response.body}',
    );
  }

  final data = jsonDecode(response.body);
  return data['maPhong'] ?? data['MaPhong'] ?? 0;
}

 Future<void> updatePhong({
  required int maPhong,
  required int maCoSo,
  required String soPhong,
  int? tang,
  num? dienTich,
  required num giaThue,
  int? soNguoiToiDa,
  required String trangThai,
  String? moTa,
  List<int> maTienIchIds = const [],
}) async {
  final uri = Uri.parse('$baseUrl/Phong/$maPhong');

  final response = await http.put(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'maPhong': maPhong,
      'maCoSo': maCoSo,
      'soPhong': soPhong,
      'tang': tang,
      'dienTich': dienTich,
      'giaThue': giaThue,
      'soNguoiToiDa': soNguoiToiDa,
      'trangThai': trangThai,
      'moTa': moTa,
      'maTienIchIds': maTienIchIds,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Không cập nhật được phòng. Status: ${response.statusCode}, Body: ${response.body}',
    );
  }
}

  Future<void> deletePhong(int maPhong) async {
    final uri = Uri.parse('$baseUrl/Phong/$maPhong');

    final response = await http.delete(uri);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Không xóa được phòng. '
        'Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  Future<void> uploadPhongImage({
    required int maPhong,
    required XFile file,
  }) async {
    final uri = Uri.parse('$baseUrl/Phong/$maPhong/image');

    final request = http.MultipartRequest('POST', uri);

    final bytes = await file.readAsBytes();
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: file.name,
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Không upload được ảnh phòng. '
        'Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  Future<List<TienIchModel>> getTienIchList() async {
  final uri = Uri.parse('$baseUrl/Phong/tien-ich');

  final response = await http.get(uri);

  if (response.statusCode != 200) {
    throw Exception(
      'Không tải được tiện ích. Status: ${response.statusCode}, Body: ${response.body}',
    );
  }

  final List data = jsonDecode(response.body);
  return data.map((e) => TienIchModel.fromJson(e)).toList();
}

Future<TienIchModel> createTienIch({
  required String tenTienIch,
}) async {
  final uri = Uri.parse('$baseUrl/Phong/tien-ich');

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'tenTienIch': tenTienIch,
    }),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception(
      'Không thêm được tiện ích. Status: ${response.statusCode}, Body: ${response.body}',
    );
  }

  final data = jsonDecode(response.body);
  return TienIchModel.fromJson(data);
}
}