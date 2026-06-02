class KhachThue {
  final int maKhach;
  final String? hoTen;
  final String? sdt;
  final String? cccd;
  final String? email;
  final String? ngaySinh;
  final String? gioiTinh;
  final String? diaChiThuongTru;
  final String? ngayCapCccd;
  final String? noiCapCccd;
  final String? trangThai;

  KhachThue({
    required this.maKhach,
    this.hoTen,
    this.sdt,
    this.cccd,
    this.email,
    this.ngaySinh,
    this.gioiTinh,
    this.diaChiThuongTru,
    this.ngayCapCccd,
    this.noiCapCccd,
    this.trangThai,
  });

  factory KhachThue.fromJson(Map<String, dynamic> json) {
    return KhachThue(
      maKhach: json['maKhach'] ?? 0,
      hoTen: json['hoTen'],
      sdt: json['sdt'],
      cccd: json['cccd'],
      email: json['email'],
      ngaySinh: json['ngaySinh'],
      gioiTinh: json['gioiTinh'],
      diaChiThuongTru: json['diaChiThuongTru'],
      ngayCapCccd: json['ngayCapCccd'],
      noiCapCccd: json['noiCapCccd'],
      trangThai: json['trangThai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maKhach': maKhach,
      'hoTen': hoTen,
      'sdt': sdt,
      'cccd': cccd,
      'email': email,
      'ngaySinh': ngaySinh,
      'gioiTinh': gioiTinh,
      'diaChiThuongTru': diaChiThuongTru,
      'ngayCapCccd': ngayCapCccd,
      'noiCapCccd': noiCapCccd,
      'trangThai': trangThai,
    };
  }
}
