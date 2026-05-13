using System;
using System.Collections.Generic;

namespace PhongTroAPI.Entities;

public partial class HopDongThue
{
    public int MaHopDong { get; set; }

    public int MaPhong { get; set; }

    public int MaKhach { get; set; }

    public DateOnly NgayBatDau { get; set; }

    public DateOnly? NgayKetThuc { get; set; }

    public decimal? TienCoc { get; set; }

    public string? TrangThai { get; set; }

    public DateTime? NgayTao { get; set; }

    public virtual KhachThue MaKhachNavigation { get; set; } = null!;

    public virtual Phong MaPhongNavigation { get; set; } = null!;
}
