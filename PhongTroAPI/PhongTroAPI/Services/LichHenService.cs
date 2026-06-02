using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using PhongTroAPI.DTOs;
using PhongTroAPI.Entities;

namespace PhongTroAPI.Services
{
    public class LichHenService
    {
        private readonly QuanLyPhongTroContext _context;

        public LichHenService(QuanLyPhongTroContext context)
        {
            _context = context;
        }

        // 🌟 1. ĐÃ FIX: BỔ SUNG MAKHACH ĐỂ LƯU ĐÚNG ĐỊNH DANH USER ĐĂNG NHẬP
        public bool CreateLichHen(CreateLichHenDto dto)
        {
            var lichHen = new LichHenXemPhong
            {
                MaKhach = dto.MaKhach,        // 🌟 THÊM DÒNG NÀY: Để không bị NULL trong DB, phục vụ hàm load Lịch sử
                HoTenKhach = dto.HoTenKhach ?? "Khách ẩn danh",
                Sdtkhach = dto.SdtKhach,       // Map chuẩn theo thuộc tính Entity của ông
                MaPhong = dto.MaPhong,
                ThoiGianHen = dto.ThoiGianHen,
                GhiChu = dto.GhiChu,
                TrangThai = "Chờ xác nhận",    // Khớp với giá trị mặc định của DB mẫu
                NgayTao = DateTime.Now
            };

            _context.LichHenXemPhongs.Add(lichHen);
            return _context.SaveChanges() > 0;
        }

        // 2. Logic lấy danh sách tổng cho Admin (Giữ nguyên cấu trúc tối ưu của ông)
        public List<LichHenRenderDto> GetDanhSachLichHen()
        {
            return _context.LichHenXemPhongs
                .Include(lh => lh.MaPhongNavigation)               
                    .ThenInclude(p => p.MaCoSoNavigation)          
                .OrderByDescending(lh => lh.ThoiGianHen)
                .Select(lh => new LichHenRenderDto
                {
                    MaLichHen = lh.MaLichHen,
                    MaKhach = lh.MaKhach,
                    MaPhong = lh.MaPhong,
                    HoTenKhach = lh.HoTenKhach,
                    SdtKhach = lh.Sdtkhach,
                    SoPhong = lh.MaPhongNavigation != null ? lh.MaPhongNavigation.SoPhong : "Trống",       
                    TenCoSo = (lh.MaPhongNavigation != null && lh.MaPhongNavigation.MaCoSoNavigation != null) 
                                ? lh.MaPhongNavigation.MaCoSoNavigation.TenCoSo : "Chưa rõ cơ sở", 
                    ThoiGianHen = lh.ThoiGianHen,
                    TrangThai = lh.TrangThai,
                    GhiChu = lh.GhiChu,
                    NgayTao = lh.NgayTao
                })
                .ToList();
        }

        // 3. Cập nhật TRẠNG THÁI lịch hẹn nhanh (Admin Duyệt)
        public bool UpdateTrangThaiLich(int id, string trangThaiMoi)
        {
            var lichHen = _context.LichHenXemPhongs.FirstOrDefault(x => x.MaLichHen == id);
            if (lichHen == null) return false;

            lichHen.TrangThai = trangThaiMoi;
            return _context.SaveChanges() > 0; 
        }

        // 4. Cập nhật THÔNG TIN CHI TIẾT (AD_EditLich)
        public bool UpdateLichHen(int id, CreateLichHenDto dto)
        {
            var lichHen = _context.LichHenXemPhongs.FirstOrDefault(x => x.MaLichHen == id);
            if (lichHen == null) return false;

            lichHen.MaKhach = dto.MaKhach; // Cập nhật thêm liên kết khách nếu cần
            lichHen.HoTenKhach = dto.HoTenKhach;
            lichHen.Sdtkhach = dto.SdtKhach;     
            lichHen.MaPhong = dto.MaPhong;
            lichHen.ThoiGianHen = dto.ThoiGianHen;
            lichHen.GhiChu = dto.GhiChu;

            return _context.SaveChanges() > 0;
        }

        //  5. Xóa vĩnh viễn khỏi Database
        public bool DeleteLichHen(int id)
        {
            var lichHen = _context.LichHenXemPhongs.FirstOrDefault(x => x.MaLichHen == id);
            if (lichHen == null) return false;

            _context.LichHenXemPhongs.Remove(lichHen);
            return _context.SaveChanges() > 0;
        }

        // 6. Lấy chi tiết 1 lịch hẹn (Bẫy rỗng an toàn tránh sập luồng hệ thống)
        public object? GetLichHenById(int id)
        {
            var lichHen = _context.LichHenXemPhongs
                .Include(l => l.MaPhongNavigation)       
                    .ThenInclude(p => p.MaCoSoNavigation) 
                .FirstOrDefault(l => l.MaLichHen == id);

            if (lichHen == null) return null;

            return new
            {
                MaLichHen = lichHen.MaLichHen,
                MaKhach = lichHen.MaKhach,
                HoTenKhach = lichHen.HoTenKhach,
                SDTKhach = lichHen.Sdtkhach,
                ThoiGianHen = lichHen.ThoiGianHen,
                GhiChu = lichHen.GhiChu,
                TrangThai = lichHen.TrangThai,
                SoPhong = lichHen.MaPhongNavigation?.SoPhong ?? "Trống",
                TenCoSo = lichHen.MaPhongNavigation?.MaCoSoNavigation?.TenCoSo ?? "Chưa rõ cơ sở"
            };
        }

        // 🌟 7. ĐÃ FIX LUỒNG KIỂM TRA ĐIỀU KIỆN KHI KHÁCH TRA CỨU LỊCH SỬ HẸN
        public List<LichHenViewDto> GetDanhSachLichHenByKhach(int maKhach)
        {
            return _context.LichHenXemPhongs
                .Include(l => l.MaPhongNavigation)
                    .ThenInclude(p => p.MaCoSoNavigation)
                .Where(l => l.MaKhach == maKhach) // Giờ điều kiện này đã chạy chuẩn vì MaKhach không còn bị NULL
                .OrderByDescending(l => l.ThoiGianHen)
                .Select(l => new LichHenViewDto
                {
                    MaLichHen = l.MaLichHen,
                    SoPhong = l.MaPhongNavigation != null ? l.MaPhongNavigation.SoPhong : "Trống",
                    TenCoSo = (l.MaPhongNavigation != null && l.MaPhongNavigation.MaCoSoNavigation != null)
                                ? l.MaPhongNavigation.MaCoSoNavigation.TenCoSo : "Chưa rõ cơ sở",
                    ThoiGianHen = l.ThoiGianHen,
                    GhiChu = l.GhiChu,
                    TrangThai = l.TrangThai ?? "Chờ xác nhận",
                    NgayTao = l.NgayTao
                })
                .ToList();
        }
    }
}