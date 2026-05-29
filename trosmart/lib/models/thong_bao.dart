class ThongBao {
  final int maThongBao;
  final String tieuDe;
  final String noiDung;
  final String loaiThongBao;
  final String ngayTao;
  final int? maKhachNhan;
  final String trangThai;

  ThongBao({
    required this.maThongBao,
    required this.tieuDe,
    required this.noiDung,
    required this.loaiThongBao,
    required this.ngayTao,
    this.maKhachNhan,
    required this.trangThai,
  });

  factory ThongBao.fromJson(Map<String, dynamic> json) {
    return ThongBao(
      maThongBao: json['maThongBao'] ?? 0,
      tieuDe: json['tieuDe'] ?? '',
      noiDung: json['noiDung'] ?? '',
      loaiThongBao: json['loaiThongBao'] ?? 'Hệ thống',
      ngayTao: json['ngayTao'] ?? '',
      maKhachNhan: json['maKhachNhan'],
      trangThai: json['trangThai'] ?? 'Đã gửi',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maThongBao': maThongBao,
      'tieuDe': tieuDe,
      'noiDung': noiDung,
      'loaiThongBao': loaiThongBao,
      'ngayTao': ngayTao,
      'maKhachNhan': maKhachNhan,
      'trangThai': trangThai,
    };
  }
}
