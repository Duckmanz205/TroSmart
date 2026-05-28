using System;

namespace PhongTroAPI.DTOs
{
    public class CreateLichHenDto
    {
        public int? MaKhach { get; set; }
        public string HoTenKhach { get; set; } = null!;
        public string SdtKhach { get; set; } = null!;
        public int MaPhong { get; set; }
        public DateTime ThoiGianHen { get; set; }
        public string? GhiChu { get; set; }
    }

    public class LichHenRenderDto
    {
        public int MaLichHen { get; set; }
        public int? MaKhach { get; set; }
        public string HoTenKhach { get; set; } = null!;
        public string SdtKhach { get; set; } = null!;
        public int MaPhong { get; set; }
        public string SoPhong { get; set; } = null!;
        public string TenCoSo { get; set; } = null!;
        public DateTime ThoiGianHen { get; set; }
        public string? GhiChu { get; set; }
        public string? TrangThai { get; set; }
        public DateTime? NgayTao { get; set; }
    }
}
