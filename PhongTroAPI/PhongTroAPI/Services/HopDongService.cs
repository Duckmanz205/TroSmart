using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json; 
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

        // 1. LẤY TOÀN BỘ DANH SÁCH HỢP ĐỒNG
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
                    MaKhach = hd.MaKhach,
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
                    UrlChuKySupabase = hd.ChuKy 
                })
                .ToList() 
                .Select(dto => {
                    dto.UrlChuKySupabase = ExtractSupabaseUrl(dto.UrlChuKySupabase);
                    return dto;
                })
                .ToList();
        }

        // 2. TẠO HỢP ĐỒNG NHÁP
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

        // 3. CẬP NHẬT ĐIỀU KHOẢN HỢP ĐỒNG NHÁP
        public bool UpdateHopDong(int maHopDong, CreateHopDongDto dto)
        {
            var hopDong = _context.HopDongThues.Find(maHopDong);
            if (hopDong == null) return false;

            if (hopDong.TrangThai == "Đang hiệu lực" || hopDong.TrangThai == "Đã ký")
            {
                throw new InvalidOperationException("Hợp đồng này đã được ký kết và đang có hiệu lực. Không thể chỉnh sửa điều khoản!");
            }

            hopDong.NgayBatDau = dto.NgayBatDau;
            hopDong.NgayKetThuc = dto.NgayKetThuc;
            hopDong.TienCoc = dto.TienCoc;

            return _context.SaveChanges() > 0;
        }

        // 4. KÝ SỐ NÂNG CAO (SHA-256 & BỌC JSON VÀO CỘT CHỮ KÝ)
        public bool KyHopDongNangCao(KyHopDongNangCaoDto dto)
        {
            var hopDong = _context.HopDongThues.Find(dto.MaHopDong);
            if (hopDong == null) return false;
            if (hopDong.TrangThai == "Đang hiệu lực") return false;

            try
            {
                string stringToHash = $"{hopDong.MaHopDong}-{hopDong.MaPhong}-{hopDong.MaKhach}-{hopDong.NgayBatDau:yyyyMMdd}-{hopDong.TienCoc}";
                string contractHash = "";

                using (SHA256 sha256 = SHA256.Create())
                {
                    byte[] inputBytes = Encoding.UTF8.GetBytes(stringToHash);
                    byte[] hashBytes = sha256.ComputeHash(inputBytes);
                    contractHash = Convert.ToBase64String(hashBytes);
                }

                var signaturePayload = new
                {
                    ContractHash = contractHash,
                    UrlChuKyKhach = dto.UrlChuKySupabase,
                    PublicKeyKhach = dto.DevicePublicKey,
                    NgayKy = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")
                };

                hopDong.ChuKy = JsonSerializer.Serialize(signaturePayload); 
                hopDong.TrangThai = "Đang hiệu lực";

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

        // 5. XEM CHI TIẾT HỢP ĐỒNG
        public HopDongRenderDto? GetChiTietHopDong(int maHopDong)
        {
            var hd = _context.HopDongThues
                .Include(hd => hd.MaKhachNavigation)
                .Include(hd => hd.MaPhongNavigation)
                    .ThenInclude(p => p.MaCoSoNavigation)
                .FirstOrDefault(hd => hd.MaHopDong == maHopDong);

            if (hd == null) return null;

            return new HopDongRenderDto
            {
                MaHopDong = hd.MaHopDong,
                MaKhach = hd.MaKhach,
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
                UrlChuKySupabase = ExtractSupabaseUrl(hd.ChuKy) 
            };
        }

        // 6. GIA HẠN HỢP ĐỒNG (LƯU VẾT LỊCH SỬ)
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

        //  7. XÓA HỢP ĐỒNG (DỌN RÁC KHÓA NGOẠI TRƯỚC KHI XÓA)
        public bool DeleteHopDong(int maHopDong)
        {
            var hopDong = _context.HopDongThues.Find(maHopDong);
            if (hopDong == null) return false;

            if (hopDong.TrangThai == "Đang hiệu lực" || hopDong.TrangThai == "Đã ký")
            {
                throw new InvalidOperationException("Hợp đồng đang có hiệu lực pháp lý, tuyệt đối không được xóa.");
            }

            try
            {
                // Gỡ trạng thái phòng về "Trống"
                var phong = _context.Phongs.Find(hopDong.MaPhong);
                if (phong != null) phong.TrangThai = "Trống";

                // Xóa lịch sử gia hạn dính tới hợp đồng này
                var lichSu = _context.LichSuGiaHans.Where(x => x.MaHopDong == maHopDong).ToList();
                if (lichSu.Any()) _context.LichSuGiaHans.RemoveRange(lichSu);

                // Lưu ý: Mở comment dòng dưới nếu có bảng Hóa Đơn dính khóa ngoại tới Hợp đồng
                // var hoaDons = _context.HoaDons.Where(x => x.MaHopDong == maHopDong).ToList();
                // if (hoaDons.Any()) _context.HoaDons.RemoveRange(hoaDons);

                _context.HopDongThues.Remove(hopDong);
                return _context.SaveChanges() > 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi xóa DB: " + ex.InnerException?.Message);
                return false;
            }
        }

        // 🛠️ HÀM PHỤ TRỢ: BÓC TÁCH JSON
        private static string? ExtractSupabaseUrl(string? rawDbValue)
        {
            if (string.IsNullOrEmpty(rawDbValue)) return null;
            if (!rawDbValue.Trim().StartsWith("{")) return rawDbValue; 

            try
            {
                using (JsonDocument doc = JsonDocument.Parse(rawDbValue))
                {
                    if (doc.RootElement.TryGetProperty("UrlChuKyKhach", out JsonElement urlElement))
                    {
                        return urlElement.GetString();
                    }
                }
            }
            catch { }
            return rawDbValue;
        }
    }
}