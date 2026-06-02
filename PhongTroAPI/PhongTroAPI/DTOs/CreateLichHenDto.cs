using System;
using System.Text.Json.Serialization;
namespace PhongTroAPI.DTOs
{
    public class CreateLichHenDto
    {
        public int? MaKhach { get; set; }
        public string? HoTenKhach { get; set; }
        
        // Tạo trường chuẩn khớp với Entity
        public string? SdtKhach { get; set; } 

        // Giữ thêm trường này làm fallback phòng hờ màn hình Add/Edit đang gọi
        [JsonIgnore]
        public string? SDTKhach 
        { 
            get => SdtKhach; 
            set => SdtKhach = value; 
        }

        public int MaPhong { get; set; }
        public DateTime ThoiGianHen { get; set; }
        public string? GhiChu { get; set; }
    }
}