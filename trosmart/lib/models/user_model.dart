/// Model ánh xạ với AuthResponse trả về từ backend
class AuthResponse {
  final String token;
  final int maTaiKhoan;
  final String tenDangNhap;
  final String hoTen;
  final String vaiTro;
  final int? maKhach;

  const AuthResponse({
    required this.token,
    required this.maTaiKhoan,
    required this.tenDangNhap,
    required this.hoTen,
    required this.vaiTro,
    this.maKhach,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String? ?? '',
      maTaiKhoan: json['maTaiKhoan'] as int? ?? 0,
      tenDangNhap: json['tenDangNhap'] as String? ?? '',
      hoTen: json['hoTen'] as String? ?? '',
      vaiTro: json['vaiTro'] as String? ?? '',
      maKhach: json['maKhach'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'maTaiKhoan': maTaiKhoan,
        'tenDangNhap': tenDangNhap,
        'hoTen': hoTen,
        'vaiTro': vaiTro,
        'maKhach': maKhach,
      };
}
