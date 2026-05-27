using System;

namespace PhongTroAPI.DTOs
{
    public class CreateOGhepDto
    {
        public int MaKhach { get; set; }
        public string TieuDe { get; set; } = null!;
        public string? NoiDung { get; set; }
        public decimal ChiPhiDuKien { get; set; }
        public string? KhuVuc { get; set; }
        public string? YeuCauGioiTinh { get; set; }
    }

    public class OGhepRenderDto
    {
        public int MaBaiDang { get; set; }
        public int MaKhach { get; set; }
        public string TenKhach { get; set; } = null!;
        public string SDTKhach { get; set; } = null!;
        public string TieuDe { get; set; } = null!;
        public string? NoiDung { get; set; }
        public decimal ChiPhiDuKien { get; set; }
        public string? KhuVuc { get; set; }
        public string? YeuCauGioiTinh { get; set; }
        public string? TrangThai { get; set; }
        public DateTime? NgayDang { get; set; }
    }
}
