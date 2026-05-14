using System;
using System.Collections.Generic;

namespace PhongTroAPI.Entities;

public partial class NguoiQuanLy
{
    public int MaQuanLy { get; set; }

    public string HoTen { get; set; } = null!;

    public string? Sdt { get; set; }

    public string? Email { get; set; }

    public string? TrangThai { get; set; }

    public DateTime? NgayTao { get; set; }

    public virtual ICollection<CoSo> CoSos { get; set; } = new List<CoSo>();
}
