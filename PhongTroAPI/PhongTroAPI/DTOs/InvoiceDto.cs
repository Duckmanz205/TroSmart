namespace PhongTroAPI.DTOs;

public class InvoiceDto
{
    public int MaHoaDon { get; set; }
    public int MaPhong { get; set; }
    public string TenPhong { get; set; } = string.Empty;
    public int Thang { get; set; }
    public int Nam { get; set; }
    public double SoDienCu { get; set; }
    public double SoDienMoi { get; set; }
    public double SoNuocCu { get; set; }
    public double SoNuocMoi { get; set; }
    public decimal TienPhong { get; set; }
    public decimal PhuPhi { get; set; }
    public decimal TongTien { get; set; }
    public string TrangThai { get; set; } = "Chưa thanh toán";
}

public class InvoiceCreateDto
{
    public int MaPhong { get; set; }
    public int Thang { get; set; }
    public int Nam { get; set; }
    public double SoDienCu { get; set; }
    public double SoDienMoi { get; set; }
    public double SoNuocCu { get; set; }
    public double SoNuocMoi { get; set; }
    public decimal DonGiaDien { get; set; }
    public decimal DonGiaNuoc { get; set; }
    public decimal PhuPhi { get; set; }
}

public class InvoiceUpdateStatusDto
{
    public string TrangThai { get; set; } = string.Empty;
}
