using System;
using System.Collections.Generic;

namespace PhongTroAPI.Entities;

public partial class ThongBao
{
    public int MaThongBao { get; set; }
    public string TieuDe { get; set; } = null!;
    public string NoiDung { get; set; } = null!;
    public string LoaiThongBao { get; set; } = "Hệ thống";
    public DateTime NgayTao { get; set; } = DateTime.Now;
    public int? MaKhachNhan { get; set; } // Null if it's a broadcast to all
    public string TrangThai { get; set; } = "Đã gửi";
    
    // Optional Navigation property if needed
    // public virtual KhachThue? KhachNhanNavigation { get; set; }
}
