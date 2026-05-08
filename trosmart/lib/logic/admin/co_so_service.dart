import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/admin/co_so_model.dart';
import '../../models/admin/co_so_detail_model.dart';
import '../../models/admin/manager_model.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/admin/co_so_image_model.dart';
import '../../models/admin/tien_ich_model.dart';


class CoSoService {
  static const String baseUrl = 'http://localhost:5137/api';

  Future<List<ManagerModel>> getManagers() async {
    final uri = Uri.parse('$baseUrl/CoSo/managers');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Không tải được danh sách quản lý. '
        'Status: ${response.statusCode}, Body: ${response.body}',
      );
    }

    final List data = jsonDecode(response.body);
    return data.map((item) => ManagerModel.fromJson(item)).toList();
  }

  Future<List<CoSoDashboardModel>> getDashboard({int? maQuanLy}) async {
    final uri = maQuanLy == null
        ? Uri.parse('$baseUrl/CoSo/dashboard')
        : Uri.parse('$baseUrl/CoSo/dashboard?maQuanLy=$maQuanLy');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Không tải được danh sách cơ sở. '
        'Status: ${response.statusCode}, Body: ${response.body}',
      );
    }

    final List data = jsonDecode(response.body);

    return data
        .map((item) => CoSoDashboardModel.fromJson(item))
        .toList();
  }

  Future<CoSoDetailModel> getDetail(int id) async {
    final uri = Uri.parse('$baseUrl/CoSo/$id');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Không tải được chi tiết cơ sở. '
        'Status: ${response.statusCode}, Body: ${response.body}',
      );
    }

    final data = jsonDecode(response.body);
    return CoSoDetailModel.fromJson(data);
  }

 Future<int> createCoSo({
  required String tenCoSo,
  required String diaChi,
  required String loaiHinh,
  String? moTa,
  int? maQuanLy,
  double? latitude,
  double? longitude,
  List<int> maTienIchIds = const [],
}) async {
  final uri = Uri.parse('$baseUrl/CoSo');

  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'tenCoSo': tenCoSo,
      'diaChi': diaChi,
      'loaiHinh': loaiHinh,
      'maQuanLy': maQuanLy,
      'moTa': moTa,
      'latitude': latitude,
      'longitude': longitude,
      'maTienIchIds': maTienIchIds,
    }),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception(
      'Không thêm được cơ sở. Status: ${response.statusCode}, Body: ${response.body}',
    );
  }

  final data = jsonDecode(response.body);
  return data['maCoSo'] ?? data['MaCoSo'] ?? 0;
}

  Future<void> updateCoSo({
  required int maCoSo,
  required String tenCoSo,
  required String diaChi,
  required String loaiHinh,
  String? moTa,
  int? maQuanLy,
  double? latitude,
  double? longitude,
  List<int> maTienIchIds = const [],
}) async {
  final uri = Uri.parse('$baseUrl/CoSo/$maCoSo');

  final response = await http.put(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'maCoSo': maCoSo,
      'tenCoSo': tenCoSo,
      'diaChi': diaChi,
      'loaiHinh': loaiHinh,
      'maQuanLy': maQuanLy,
      'moTa': moTa,
      'latitude': latitude,
      'longitude': longitude,
      'maTienIchIds': maTienIchIds,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Không cập nhật được cơ sở. Status: ${response.statusCode}, Body: ${response.body}',
    );
  }
}

  Future<void> deleteCoSo(int maCoSo) async {
    final uri = Uri.parse('$baseUrl/CoSo/$maCoSo');

    final response = await http.delete(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Không xóa được cơ sở. '
        'Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }
  Future<List<CoSoImageModel>> getCoSoImages(int maCoSo) async {
  final uri = Uri.parse('$baseUrl/CoSo/$maCoSo/images');

  final response = await http.get(uri);

  if (response.statusCode != 200) {
    throw Exception(
      'Không tải được danh sách ảnh cơ sở. '
      'Status: ${response.statusCode}, Body: ${response.body}',
    );
  }

  final List data = jsonDecode(response.body);
  return data.map((e) => CoSoImageModel.fromJson(e)).toList();
}

Future<CoSoImageModel> uploadCoSoImage({
  required int maCoSo,
  required XFile file,
}) async {
  final uri = Uri.parse('$baseUrl/CoSo/$maCoSo/images');

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
      'Không upload được ảnh cơ sở. '
      'Status: ${response.statusCode}, Body: ${response.body}',
    );
  }

  return CoSoImageModel.fromJson(jsonDecode(response.body));
}

Future<void> setMainCoSoImage(int maAnh) async {
  final uri = Uri.parse('$baseUrl/CoSo/images/$maAnh/set-main');

  final response = await http.put(uri);

  if (response.statusCode != 200) {
    throw Exception(
      'Không cập nhật được ảnh chính. '
      'Status: ${response.statusCode}, Body: ${response.body}',
    );
  }
}

Future<void> deleteCoSoImage(int maAnh) async {
  final uri = Uri.parse('$baseUrl/CoSo/images/$maAnh');

  final response = await http.delete(uri);

  if (response.statusCode != 200) {
    throw Exception(
      'Không xóa được ảnh. '
      'Status: ${response.statusCode}, Body: ${response.body}',
    );
  }
}

Future<List<TienIchModel>> getTienIchList() async {
  final uri = Uri.parse('$baseUrl/CoSo/tien-ich');

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
  final uri = Uri.parse('$baseUrl/CoSo/tien-ich');

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

