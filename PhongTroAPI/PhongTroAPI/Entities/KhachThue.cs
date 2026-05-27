using System;
using System.Collections.Generic;

namespace PhongTroAPI.Entities;

public partial class KhachThue
{
    public int MaKhach { get; set; }

    public string? HoTen { get; set; }

    public string? Sdt { get; set; }

    public string? Cccd { get; set; }

    public virtual ICollection<HoaDon> HoaDons { get; set; } = new List<HoaDon>();

    public virtual ICollection<HopDongThue> HopDongThues { get; set; } = new List<HopDongThue>();

    public virtual ICollection<SuCo> SuCos { get; set; } = new List<SuCo>();

    public virtual ICollection<TaiKhoan> TaiKhoans { get; set; } = new List<TaiKhoan>();

    public virtual ICollection<ThongBao> ThongBaos { get; set; } = new List<ThongBao>();
}
