using System;

namespace PhongTroAPI.DTOs
{
    public class CreateHopDongDto
    {
        public int MaPhong { get; set; }
        public int MaKhach { get; set; }
        public DateOnly NgayBatDau { get; set; }
        public DateOnly? NgayKetThuc { get; set; }
        public decimal TienCoc { get; set; }
    }

    public class HopDongRenderDto
    {
        public int MaHopDong { get; set; }
        public int MaKhach { get; set; }
        public string TenKhach { get; set; } = null!;
        public string CCCD { get; set; } = null!;
        public string SDT { get; set; } = null!;
        public string SoPhong { get; set; } = null!;
        public string TenCoSo { get; set; } = null!;
        public decimal GiaThue { get; set; }
        public decimal TienCoc { get; set; }
        public DateOnly NgayBatDau { get; set; }
        public DateOnly NgayKetThuc { get; set; }
        public string? TrangThai { get; set; }
        public string? ChuKyBase64 { get; set; }

        public string? UrlChuKySupabase { get; set; }
    }

    public class GiaHanHopDongDto
    {
        public DateOnly NgayBatDauMoi { get; set; }
        public DateOnly NgayKetThucMoi { get; set; }
        public decimal GiaThueMoi { get; set; }
        public string? GhiChu { get; set; }
    }
}
