using System;
using System.Collections.Generic;

namespace PhongTroAPI.Entities;

public partial class TinNhan
{
    public int MaTinNhan { get; set; }
    public int? MaNguoiGui { get; set; } 
    public string VaiTroNguoiGui { get; set; } = null!; // "Admin" or "User"
    public int? MaNguoiNhan { get; set; }
    public string VaiTroNguoiNhan { get; set; } = null!; // "Admin" or "User"
    public string NoiDung { get; set; } = null!;
    public DateTime NgayGui { get; set; } = DateTime.Now;
    public bool DaDoc { get; set; } = false;
}
