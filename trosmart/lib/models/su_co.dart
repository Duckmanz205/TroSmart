class SuCo {
  final int maSuCo;
  final int maPhong;
  final int maKhach;
  final String tieuDe;
  final String? moTa;
  final String? hinhAnh;
  final String? trangThai;
  final DateTime? ngayBao;
  final DateTime? ngayXuLy;

  SuCo({
    required this.maSuCo,
    required this.maPhong,
    required this.maKhach,
    required this.tieuDe,
    this.moTa,
    this.hinhAnh,
    this.trangThai,
    this.ngayBao,
    this.ngayXuLy,
  });

  factory SuCo.fromJson(Map<String, dynamic> json) {
    return SuCo(
      maSuCo: json['maSuCo'] ?? 0,
      maPhong: json['maPhong'] ?? 0,
      maKhach: json['maKhach'] ?? 0,
      tieuDe: json['tieuDe'] ?? '',
      moTa: json['moTa'],
      hinhAnh: json['hinhAnh'],
      trangThai: json['trangThai'],
      ngayBao: json['ngayBao'] != null ? DateTime.parse(json['ngayBao']) : null,
      ngayXuLy: json['ngayXuLy'] != null ? DateTime.parse(json['ngayXuLy']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maSuCo': maSuCo,
      'maPhong': maPhong,
      'maKhach': maKhach,
      'tieuDe': tieuDe,
      'moTa': moTa,
      'hinhAnh': hinhAnh,
      'trangThai': trangThai,
      'ngayBao': ngayBao?.toIso8601String(),
      'ngayXuLy': ngayXuLy?.toIso8601String(),
    };
  }
}
