namespace PhongTroAPI.DTOs
{
    public class KyHopDongNangCaoDto
    {
        public int MaHopDong { get; set; }
        public string UrlChuKyKhach { get; set; } = null!; // Link Supabase gửi về
        public string PublicKeyKhach { get; set; } = null!; // Khóa sinh ra từ thiết bị Flutter
    }
}