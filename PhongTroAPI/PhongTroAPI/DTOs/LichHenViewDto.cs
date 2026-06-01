using System;

namespace PhongTroAPI.DTOs
{

    // DTO trả về danh sách lịch hẹn hiển thị lên UI Lịch sử
    public class LichHenViewDto
    {
        public int MaLichHen { get; set; }
        public string SoPhong { get; set; } = null!;
        public string TenCoSo { get; set; } = null!;
        public DateTime ThoiGianHen { get; set; }
        public string? GhiChu { get; set; }
        public string TrangThai { get; set; } = null!; // "Chờ xác nhận", "Đã xác nhận", "Đã xem", "Đã hủy"
        public DateTime? NgayTao { get; set; }
    }
}