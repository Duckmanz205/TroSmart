import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/api_constants.dart';

class UserContractController extends ChangeNotifier {
  int _maHopDong = 0;
  int get maHopDong => _maHopDong;

  Map<String, dynamic>? _contract;
  Map<String, dynamic>? get contract => _contract;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  int _currentMaKhach = 1;
  int get currentMaKhach => _currentMaKhach;

  UserContractController() {
    loadContractFlow();
  }

  Future<void> loadContractFlow() async {
    _isLoading = true;
    _maHopDong = 0;
    _contract = null;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      var saved = prefs.getInt('maKhach') ?? prefs.getInt('ma_khach');
      if (saved != null && saved > 0) {
        _currentMaKhach = saved;
      } else {
        _currentMaKhach = 1;
      }

      final listResponse = await http.get(Uri.parse('${ApiConstants.baseUrl}/HopDong'));
      if (listResponse.statusCode == 200) {
        final dynamic decoded = jsonDecode(listResponse.body);
        List<dynamic> contracts = [];
        if (decoded is List) {
          contracts = decoded;
        } else if (decoded is Map) {
          if (decoded.containsKey('data') && decoded['data'] is List) {
            contracts = decoded['data'];
          } else if (decoded.containsKey('value') && decoded['value'] is List) {
            contracts = decoded['value'];
          } else {
            contracts = [decoded];
          }
        }

        dynamic userContract;
        for (var hd in contracts) {
          if (hd == null || hd is! Map) continue;
          var dynamicMaKhach = hd['MaKhach'] ?? hd['maKhach'] ?? hd['MAKHACH'] ?? hd['ma_khach'];

          if (dynamicMaKhach != null && dynamicMaKhach.toString() == _currentMaKhach.toString()) {
            userContract = hd;
            break;
          }
        }

        if (userContract != null) {
          var rawMaHopDong = userContract['MaHopDong'] ?? userContract['maHopDong'] ?? 0;
          _maHopDong = int.tryParse(rawMaHopDong.toString()) ?? 0;

          if (_maHopDong > 0) {
            final detailResponse = await http.get(
              Uri.parse('${ApiConstants.baseUrl}/HopDong/$_maHopDong'),
            );
            if (detailResponse.statusCode == 200) {
              _contract = jsonDecode(detailResponse.body);
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Lỗi tải thông tin hợp đồng: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
