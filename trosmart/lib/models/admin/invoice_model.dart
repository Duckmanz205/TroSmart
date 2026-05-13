class InvoiceModel {
  final int maHoaDon;
  final int maPhong;
  final String tenPhong;
  final int thang;
  final int nam;
  final double soDienCu;
  final double soDienMoi;
  final double soNuocCu;
  final double soNuocMoi;
  final double tienPhong;
  final double phuPhi;
  final double tongTien;
  final String trangThai;

  InvoiceModel({
    required this.maHoaDon,
    required this.maPhong,
    required this.tenPhong,
    required this.thang,
    required this.nam,
    required this.soDienCu,
    required this.soDienMoi,
    required this.soNuocCu,
    required this.soNuocMoi,
    required this.tienPhong,
    required this.phuPhi,
    required this.tongTien,
    required this.trangThai,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      maHoaDon: json['maHoaDon'] ?? 0,
      maPhong: json['maPhong'] ?? 0,
      tenPhong: json['tenPhong'] ?? '',
      thang: json['thang'] ?? 1,
      nam: json['nam'] ?? 2024,
      soDienCu: (json['soDienCu'] ?? 0).toDouble(),
      soDienMoi: (json['soDienMoi'] ?? 0).toDouble(),
      soNuocCu: (json['soNuocCu'] ?? 0).toDouble(),
      soNuocMoi: (json['soNuocMoi'] ?? 0).toDouble(),
      tienPhong: (json['tienPhong'] ?? 0).toDouble(),
      phuPhi: (json['phuPhi'] ?? 0).toDouble(),
      tongTien: (json['tongTien'] ?? 0).toDouble(),
      trangThai: json['trangThai'] ?? 'Chưa thanh toán',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maHoaDon': maHoaDon,
      'maPhong': maPhong,
      'tenPhong': tenPhong,
      'thang': thang,
      'nam': nam,
      'soDienCu': soDienCu,
      'soDienMoi': soDienMoi,
      'soNuocCu': soNuocCu,
      'soNuocMoi': soNuocMoi,
      'tienPhong': tienPhong,
      'phuPhi': phuPhi,
      'tongTien': tongTien,
      'trangThai': trangThai,
    };
  }
}
