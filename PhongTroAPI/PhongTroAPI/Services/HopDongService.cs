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
        public List<HopDongRenderDto> GetAllHopDong(int? maQuanLy = null)
        {
            var query = _context.HopDongThues
                .Include(hd => hd.MaKhachNavigation)
                .Include(hd => hd.MaPhongNavigation)
                    .ThenInclude(p => p.MaCoSoNavigation)
                        .ThenInclude(cs => cs.MaQuanLyNavigation)
                .AsQueryable();

            if (maQuanLy.HasValue)
            {
                query = query.Where(hd => hd.MaPhongNavigation.MaCoSoNavigation.MaQuanLy == maQuanLy.Value);
            }

            return query
                .OrderByDescending(hd => hd.MaHopDong)
                .Select(hd => new HopDongRenderDto
                {
                    MaHopDong = hd.MaHopDong,
                    MaKhach = hd.MaKhach,
                    MaPhong = hd.MaPhong,
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
                    UrlChuKySupabase = hd.ChuKy,
                    TenQuanLy = hd.MaPhongNavigation.MaCoSoNavigation.MaQuanLyNavigation != null ? hd.MaPhongNavigation.MaCoSoNavigation.MaQuanLyNavigation.HoTen : "N/A",
                    SdtQuanLy = hd.MaPhongNavigation.MaCoSoNavigation.MaQuanLyNavigation != null ? hd.MaPhongNavigation.MaCoSoNavigation.MaQuanLyNavigation.Sdt : "N/A",
                    EmailQuanLy = hd.MaPhongNavigation.MaCoSoNavigation.MaQuanLyNavigation != null ? hd.MaPhongNavigation.MaCoSoNavigation.MaQuanLyNavigation.Email : "N/A"
                })
                .ToList() 
                .Select(dto => {
                    dto.UrlChuKySupabase = ExtractSupabaseUrl(dto.UrlChuKySupabase);
                    return dto;
                })
                .ToList();
        }

        // 2. TẠO HỢP ĐỒNG NHÁP
        public bool CreateHopDong(CreateHopDongDto dto, int? maQuanLy = null)
        {
            var phong = _context.Phongs.Include(p => p.MaCoSoNavigation).FirstOrDefault(p => p.MaPhong == dto.MaPhong);
            if (phong == null) return false;
            if (maQuanLy.HasValue && phong.MaCoSoNavigation.MaQuanLy != maQuanLy.Value) return false;

            var hopDong = new HopDongThue
            {
                MaPhong = dto.MaPhong,
                MaKhach = dto.MaKhach,
                NgayBatDau = dto.NgayBatDau,
                NgayKetThuc = dto.NgayKetThuc,
                TienCoc = dto.TienCoc,
                ChiSoDienCu = dto.ChiSoDienCu,
                ChiSoNuocCu = dto.ChiSoNuocCu,
                TrangThai = "Chờ khách ký", 
                NgayTao = DateTime.Now
            };

            _context.HopDongThues.Add(hopDong);
            return _context.SaveChanges() > 0;
        }

        // 3. CẬP NHẬT ĐIỀU KHOẢN HỢP ĐỒNG NHÁP
        public bool UpdateHopDong(int maHopDong, CreateHopDongDto dto, int? maQuanLy = null)
        {
            var hopDong = _context.HopDongThues.Include(hd => hd.MaPhongNavigation).ThenInclude(p => p.MaCoSoNavigation).FirstOrDefault(hd => hd.MaHopDong == maHopDong);
            if (hopDong == null) return false;

            if (maQuanLy.HasValue && hopDong.MaPhongNavigation.MaCoSoNavigation.MaQuanLy != maQuanLy.Value) return false;

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

                // Cập nhật chỉ số điện nước cũ từ hợp đồng vào bảng ChiSoDienNuoc
                var startMonth = hopDong.NgayBatDau.Month;
                var startYear = hopDong.NgayBatDau.Year;
                var existingReading = _context.ChiSoDienNuocs
                    .FirstOrDefault(c => c.MaPhong == hopDong.MaPhong && c.Thang == startMonth && c.Nam == startYear);

                if (existingReading != null)
                {
                    existingReading.ChiSoDienCu = hopDong.ChiSoDienCu ?? 0;
                    existingReading.ChiSoNuocCu = hopDong.ChiSoNuocCu ?? 0;
                    existingReading.NgayCapNhat = DateTime.Now;
                }
                else
                {
                    var newReading = new ChiSoDienNuoc
                    {
                        MaPhong = hopDong.MaPhong,
                        Thang = startMonth,
                        Nam = startYear,
                        ChiSoDienCu = hopDong.ChiSoDienCu ?? 0,
                        ChiSoDienMoi = null,
                        ChiSoNuocCu = hopDong.ChiSoNuocCu ?? 0,
                        ChiSoNuocMoi = null,
                        DaLapHoaDon = false,
                        NgayCapNhat = DateTime.Now
                    };
                    _context.ChiSoDienNuocs.Add(newReading);
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
                        .ThenInclude(cs => cs.MaQuanLyNavigation)
                .FirstOrDefault(hd => hd.MaHopDong == maHopDong);

            if (hd == null) return null;

            return new HopDongRenderDto
            {
                MaHopDong = hd.MaHopDong,
                MaKhach = hd.MaKhach,
                MaPhong = hd.MaPhong,
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
                UrlChuKySupabase = ExtractSupabaseUrl(hd.ChuKy),
                TenQuanLy = hd.MaPhongNavigation.MaCoSoNavigation.MaQuanLyNavigation != null ? hd.MaPhongNavigation.MaCoSoNavigation.MaQuanLyNavigation.HoTen : "N/A",
                SdtQuanLy = hd.MaPhongNavigation.MaCoSoNavigation.MaQuanLyNavigation != null ? hd.MaPhongNavigation.MaCoSoNavigation.MaQuanLyNavigation.Sdt : "N/A",
                EmailQuanLy = hd.MaPhongNavigation.MaCoSoNavigation.MaQuanLyNavigation != null ? hd.MaPhongNavigation.MaCoSoNavigation.MaQuanLyNavigation.Email : "N/A"
            };
        }

        // 6. GIA HẠN HỢP ĐỒNG (LƯU VẾT LỊCH SỬ)
        public bool GiaHanHopDong(int maHopDong, GiaHanHopDongDto dto, int? maQuanLy = null)
        {
            var hopDong = _context.HopDongThues.Include(hd => hd.MaPhongNavigation).ThenInclude(p => p.MaCoSoNavigation).FirstOrDefault(hd => hd.MaHopDong == maHopDong);
            if (hopDong == null) return false;

            if (maQuanLy.HasValue && hopDong.MaPhongNavigation.MaCoSoNavigation.MaQuanLy != maQuanLy.Value) return false;

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
            hopDong.TrangThai = "Đang hiệu lực"; // Chuyển về đang hiệu lực sau khi gia hạn
            
            // Cập nhật lại giá thuê phòng
            var phong = _context.Phongs.Find(hopDong.MaPhong);
            if (phong != null)
            {
                phong.GiaThue = dto.GiaThueMoi;
            }

            return _context.SaveChanges() > 0;
        }

        // 6.1 YÊU CẦU GIA HẠN HỢP ĐỒNG (KHÁCH THUÊ GỬI YÊU CẦU)
        public bool YeuCauGiaHan(int maHopDong, int? maKhach = null)
        {
            var hopDong = _context.HopDongThues.Find(maHopDong);
            if (hopDong == null) return false;

            if (maKhach.HasValue && hopDong.MaKhach != maKhach.Value) return false;

            hopDong.TrangThai = "Chờ gia hạn";
            return _context.SaveChanges() > 0;
        }

        // 6.2 TỪ CHỐI GIA HẠN HỢP ĐỒNG (QUẢN TRỊ VIÊN TỪ CHỐI)
        public bool TuChoiGiaHan(int maHopDong, int? maQuanLy = null)
        {
            var hopDong = _context.HopDongThues.Include(hd => hd.MaPhongNavigation).ThenInclude(p => p.MaCoSoNavigation).FirstOrDefault(hd => hd.MaHopDong == maHopDong);
            if (hopDong == null) return false;

            if (maQuanLy.HasValue && hopDong.MaPhongNavigation.MaCoSoNavigation.MaQuanLy != maQuanLy.Value) return false;

            hopDong.TrangThai = "Quá hạn";
            return _context.SaveChanges() > 0;
        }

        //  7. XÓA HỢP ĐỒNG (DỌN RÁC KHÓA NGOẠI TRƯỚC KHI XÓA)
        public bool DeleteHopDong(int maHopDong, int? maQuanLy = null)
        {
            var hopDong = _context.HopDongThues.Include(hd => hd.MaPhongNavigation).ThenInclude(p => p.MaCoSoNavigation).FirstOrDefault(hd => hd.MaHopDong == maHopDong);
            if (hopDong == null) return false;

            if (maQuanLy.HasValue && hopDong.MaPhongNavigation.MaCoSoNavigation.MaQuanLy != maQuanLy.Value) return false;

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

        public bool VerifyOwnership(int maHopDong, int maQuanLy)
        {
            return _context.HopDongThues.Any(hd => hd.MaHopDong == maHopDong && hd.MaPhongNavigation.MaCoSoNavigation.MaQuanLy == maQuanLy);
        }

        public bool VerifyCustomerOwnership(int maHopDong, int maKhach)
        {
            return _context.HopDongThues.Any(hd => hd.MaHopDong == maHopDong && hd.MaKhach == maKhach);
        }

        // 🛠️ HÀM PHỤ TRỢ: BÓC TÁCH JSON
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

        // 8. LẤY HỢP ĐỒNG BẰNG ID (DÀNH CHO XUẤT PDF)
        public HopDongThue? GetById(int id)
        {
            return _context.HopDongThues
                .Include(hd => hd.MaKhachNavigation)
                .Include(hd => hd.MaPhongNavigation)
                    .ThenInclude(p => p.MaCoSoNavigation)
                        .ThenInclude(cs => cs.MaQuanLyNavigation)
                .FirstOrDefault(hd => hd.MaHopDong == id);
        }

        // 9. SINH PDF CHO HỢP ĐỒNG
        public byte[] GeneratePdfBytes(HopDongThue contract)
        {
            string content = $@"%PDF-1.4
1 0 obj
<< /Type /Catalog /Pages 2 0 R >>
endobj
2 0 obj
<< /Type /Pages /Kids [3 0 R] /Count 1 >>
endobj
3 0 obj
<< /Type /Page /Parent 2 0 R /Resources << /Font << /F1 << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >> >> >> /MediaBox [0 0 595 842] /Contents 4 0 R >>
endobj
4 0 obj
<< /Length 500 >>
stream
BT
/F1 24 Tf
50 750 Td
(HOP DONG THUE PHONG TRO) Tj
/F1 12 Tf
0 -40 Td
(Ma Hop Dong: HD-2026-00{contract.MaHopDong}) Tj
0 -20 Td
(Khach Thue: {contract.MaKhachNavigation?.HoTen ?? "N/A"}) Tj
0 -20 Td
(Phong: {contract.MaPhongNavigation?.SoPhong ?? "N/A"}) Tj
0 -20 Td
(Gia Thue: {contract.MaPhongNavigation?.GiaThue ?? 0} VND) Tj
0 -20 Td
(Tien Coc: {contract.TienCoc ?? 0} VND) Tj
0 -20 Td
(Ngay Bat Dau: {contract.NgayBatDau:yyyy-MM-dd}) Tj
0 -20 Td
(Ngay Ket Thuc: {contract.NgayKetThuc:yyyy-MM-dd}) Tj
0 -20 Td
(Trang Thai: {contract.TrangThai}) Tj
ET
endstream
endobj
xref
0 5
0000000000 65535 f 
0000000009 00000 n 
0000000058 00000 n 
0000000115 00000 n 
0000000282 00000 n 
trailer
<< /Size 5 /Root 1 0 R >>
startxref
820
%%EOF";
            return Encoding.UTF8.GetBytes(content);
        }
    }
}