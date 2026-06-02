using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using Microsoft.EntityFrameworkCore;
using PhongTroAPI.DTOs;
using PhongTroAPI.Entities;

namespace PhongTroAPI.Services
{
    public class HopDongService
    {
        private readonly QuanLyPhongTroContext _context;

        public HopDongService(QuanLyPhongTroContext context)
        {
            _context = context;
        }

        // Lấy toàn bộ danh sách hợp đồng (Dành cho trang AD_QLHopDong của Admin)
        public List<HopDongRenderDto> GetAllHopDong()
        {
            return _context.HopDongThues
                .Include(hd => hd.MaKhachNavigation)
                .Include(hd => hd.MaPhongNavigation)
                    .ThenInclude(p => p.MaCoSoNavigation)
                .OrderByDescending(hd => hd.MaHopDong)
                .Select(hd => new HopDongRenderDto
                {
                    MaHopDong = hd.MaHopDong,
                    TenKhach = hd.MaKhachNavigation.HoTen ?? "N/A",
                    CCCD = hd.MaKhachNavigation.Cccd ?? "N/A",
                    SDT = hd.MaKhachNavigation.Sdt ?? "N/A",
                    SoPhong = hd.MaPhongNavigation.SoPhong,
                    TenCoSo = hd.MaPhongNavigation.MaCoSoNavigation.TenCoSo,
                    GiaThue = hd.MaPhongNavigation.GiaThue,
                    TienCoc = hd.TienCoc ?? 0m,
                    NgayBatDau = hd.NgayBatDau,
                    NgayKetThuc = hd.NgayKetThuc ?? DateOnly.MinValue,
                    TrangThai = hd.TrangThai,
                    UrlChuKySupabase = hd.UrlChuKyKhach // Áp dụng cột chứa link lưu từ đám mây
                })
                .ToList();
        }

        // 1. Lập hợp đồng nháp ban đầu
        public bool CreateHopDong(CreateHopDongDto dto)
        {
            var phong = _context.Phongs.Find(dto.MaPhong);
            if (phong == null) return false;

            var hopDong = new HopDongThue
            {
                MaPhong = dto.MaPhong,
                MaKhach = dto.MaKhach,
                NgayBatDau = dto.NgayBatDau,
                NgayKetThuc = dto.NgayKetThuc,
                TienCoc = dto.TienCoc,
                TrangThai = "Chờ khách ký", 
                NgayTao = DateTime.Now
            };

            _context.HopDongThues.Add(hopDong);
            return _context.SaveChanges() > 0;
        }

        // Cập nhật hợp đồng có bộ lọc khóa dữ liệu
        public bool UpdateHopDong(int maHopDong, CreateHopDongDto dto)
        {
            var hopDong = _context.HopDongThues.Find(maHopDong);
            if (hopDong == null) return false;

            // KIỂM TRA QUYỀN KHÓA: Nếu trạng thái đã có hiệu lực pháp lý thì chặn ngay!
            if (hopDong.TrangThai == "Đang hiệu lực" || hopDong.TrangThai == "Đã ký")
            {
                throw new InvalidOperationException("Hợp đồng này đã được ký kết và đang có hiệu lực. Không thể chỉnh sửa điều khoản!");
            }

            hopDong.NgayBatDau = dto.NgayBatDau;
            hopDong.NgayKetThuc = dto.NgayKetThuc;
            hopDong.TienCoc = dto.TienCoc;

            return _context.SaveChanges() > 0;
        }

        // Xử lý ký số bảo mật SHA-256 kết hợp Supabase URL
        public bool KyHopDongNangCao(KyHopDongNangCaoDto dto)
        {
            var hopDong = _context.HopDongThues.Find(dto.MaHopDong);
            if (hopDong == null) return false;

            // Nếu đã ký rồi thì không cho ký đè tránh giả mạo ghi đè
            if (hopDong.TrangThai == "Đang hiệu lực") return false;

            try
            {
                // 🔐 THUẬT TOÁN KÝ SỐ: Tạo chuỗi định danh duy nhất từ các thông tin cốt lõi của hợp đồng
                string stringToHash = $"{hopDong.MaHopDong}-{hopDong.MaPhong}-{hopDong.MaKhach}-{hopDong.NgayBatDau:yyyyMMdd}-{hopDong.TienCoc}";
                
                using (SHA256 sha256 = SHA256.Create())
                {
                    byte[] inputBytes = Encoding.UTF8.GetBytes(stringToHash);
                    byte[] hashBytes = sha256.ComputeHash(inputBytes);
                    
                    // Gán mã băm chuỗi bảo mật vào trường ContractHash chống sửa đổi dữ liệu tận tầng gốc database
                    hopDong.ContractHash = Convert.ToBase64String(hashBytes);
                }

                // Lưu các dữ liệu minh chứng ký số phân hệ Khách hàng
                hopDong.UrlChuKyKhach = dto.UrlChuKySupabase; // Đường dẫn ảnh từ Supabase Storage gửi về
                hopDong.PublicKeyKhach = dto.DevicePublicKey; // Khóa công khai của thiết bị di động
                hopDong.NgayKy = DateTime.Now;               // Ghi nhận mốc thời gian ký thành công
                hopDong.TrangThai = "Đang hiệu lực";

                // Tự động lấp phòng trọ chuyển đổi trạng thái thực tế
                var phong = _context.Phongs.Find(hopDong.MaPhong);
                if (phong != null)
                {
                    phong.TrangThai = "Đang thuê"; 
                }

                return _context.SaveChanges() > 0;
            }
            catch (Exception)
            {
                return false;
            }
        }

        // 4. Xem chi tiết hợp đồng
        public HopDongRenderDto? GetChiTietHopDong(int maHopDong)
        {
            return _context.HopDongThues
                .Include(hd => hd.MaKhachNavigation)
                .Include(hd => hd.MaPhongNavigation)
                    .ThenInclude(p => p.MaCoSoNavigation)
                .Where(hd => hd.MaHopDong == maHopDong)
                .Select(hd => new HopDongRenderDto
                {
                    MaHopDong = hd.MaHopDong,
                    TenKhach = hd.MaKhachNavigation.HoTen ?? "N/A",
                    CCCD = hd.MaKhachNavigation.Cccd ?? "N/A",
                    SDT = hd.MaKhachNavigation.Sdt ?? "N/A",
                    SoPhong = hd.MaPhongNavigation.SoPhong,
                    TenCoSo = hd.MaPhongNavigation.MaCoSoNavigation.TenCoSo,
                    GiaThue = hd.MaPhongNavigation.GiaThue,
                    TienCoc = hd.TienCoc ?? 0m,
                    NgayBatDau = hd.NgayBatDau,
                    NgayKetThuc = hd.NgayKetThuc ?? DateOnly.MinValue,
                    TrangThai = hd.TrangThai,
                    UrlChuKySupabase = hd.UrlChuKyKhach // Trả link ảnh của Supabase về để Flutter dùng Image.network hiển thị
                })
                .FirstOrDefault();
        }

        // 5. Gia hạn hợp đồng (Giữ nguyên logic tạo phụ lục bảo lưu dữ liệu cũ)
        public bool GiaHanHopDong(int maHopDong, GiaHanHopDongDto dto)
        {
            var hopDong = _context.HopDongThues.Find(maHopDong);
            if (hopDong == null) return false;

            var lichSu = new LichSuGiaHan
            {
                MaHopDong = maHopDong,
                NgayBatDauMoi = dto.NgayBatDauMoi,
                NgayKetThucMoi = dto.NgayKetThucMoi,
                GiaThueMoi = dto.GiaThueMoi,
                NgayThucHien = DateTime.Now,
                GhiChu = dto.GhiChu
            };
            _context.LichSuGiaHans.Add(lichSu);

            hopDong.NgayKetThuc = dto.NgayKetThucMoi;
            return _context.SaveChanges() > 0;
        }
    }
}