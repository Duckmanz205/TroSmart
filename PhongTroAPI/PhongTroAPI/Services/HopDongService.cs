using System;
using System.Collections.Generic;
using System.Linq;
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
                TrangThai = "Chờ khách ký", // Trạng thái ban đầu, cho phép chỉnh sửa
                NgayTao = DateTime.Now
            };

            _context.HopDongThues.Add(hopDong);
            return _context.SaveChanges() > 0;
        }

        // LOGIC CHỐT 1: Cập nhật hợp đồng có bộ lọc khóa dữ liệu
        public bool UpdateHopDong(int maHopDong, CreateHopDongDto dto)
        {
            var hopDong = _context.HopDongThues.Find(maHopDong);
            if (hopDong == null) return false;

            // KIỂM TRA QUYỀN KHÓA: Nếu trạng thái đã có hiệu lực pháp lý thì chặn ngay!
            if (hopDong.TrangThai == "Đang hiệu lực" || hopDong.TrangThai == "Đã ký")
            {
                throw new InvalidOperationException("Hợp đồng này đã được ký kết và đang có hiệu lực. Không thể chỉnh sửa điều khoản!");
            }

            // Nếu hợp đồng vẫn đang chờ ký thì cho phép sửa bình thường
            hopDong.NgayBatDau = dto.NgayBatDau;
            hopDong.NgayKetThuc = dto.NgayKetThuc;
            hopDong.TienCoc = dto.TienCoc;

            return _context.SaveChanges() > 0;
        }

        // LOGIC CHỐT 2: Xử lý ký hợp đồng online bằng Signature Pad
        public bool KyHopDongOnline(int maHopDong, string chuKyBase64)
        {
            var hopDong = _context.HopDongThues.Find(maHopDong);
            if (hopDong == null) return false;

            // Nếu đã ký rồi thì không cho ký đè lại nữa
            if (hopDong.TrangThai == "Đang hiệu lực") return false;

            // Lưu trữ chuỗi ảnh chữ ký vào DB
            hopDong.ChuKy = chuKyBase64;
            
            // Kích hoạt trạng thái có hiệu lực và tự động chuyển đổi trạng thái Phòng
            hopDong.TrangThai = "Đang hiệu lực";

            var phong = _context.Phongs.Find(hopDong.MaPhong);
            if (phong != null)
            {
                phong.TrangThai = "Đang thuê"; // Chính thức lấp phòng
            }

            return _context.SaveChanges() > 0;
        }

        // 4. Xem chi tiết hợp đồng (Lấy luôn cả chuỗi chữ ký trả về cho client)
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
                    ChuKyBase64 = hd.ChuKy // Gửi kèm chữ ký số về để Flutter render thành ảnh
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