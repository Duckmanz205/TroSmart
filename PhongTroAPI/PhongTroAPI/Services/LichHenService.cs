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

        // 1. Logic xử lý User đặt lịch (Insert bằng EF Core)
        public bool CreateLichHen(CreateLichHenDto dto)
        {
            var lichHen = new LichHenXemPhong
            {
                HoTenKhach = dto.HoTenKhach,
                Sdtkhach = dto.SdtKhach,
                MaPhong = dto.MaPhong,
                ThoiGianHen = dto.ThoiGianHen,
                GhiChu = dto.GhiChu,
                TrangThai = "Chờ xác nhận", // Mặc định khi đặt
                NgayTao = DateTime.Now
            };

            _context.LichHenXemPhongs.Add(lichHen);
            return _context.SaveChanges() > 0;
        }

        // 2. Logic lấy danh sách (Dùng LINQ để JOIN tự động thông qua Navigation Properties)
        public List<LichHenRenderDto> GetDanhSachLichHen()
        {
            return _context.LichHenXemPhongs
                .Include(lh => lh.MaPhongNavigation)               // JOIN sang bảng Phong
                    .ThenInclude(p => p.MaCoSoNavigation)          // JOIN tiếp từ Phong sang CoSo
                .OrderByDescending(lh => lh.ThoiGianHen)
                .Select(lh => new LichHenRenderDto
                {
                    MaLichHen = lh.MaLichHen,
                    MaKhach = lh.MaKhach,
                    MaPhong = lh.MaPhong,
                    HoTenKhach = lh.HoTenKhach,
                    SdtKhach = lh.Sdtkhach,
                    SoPhong = lh.MaPhongNavigation.SoPhong,       // Lấy từ bảng Phong
                    TenCoSo = lh.MaPhongNavigation.MaCoSoNavigation.TenCoSo, // Lấy từ bảng CoSo
                    ThoiGianHen = lh.ThoiGianHen,
                    TrangThai = lh.TrangThai,
                    GhiChu = lh.GhiChu
                })
                .ToList();
        }

        // 3. Cập nhật TRẠNG THÁI lịch hẹn nhanh (Admin Duyệt/Hoàn thành nhanh trên giao diện)
        public bool UpdateTrangThaiLich(int id, string trangThaiMoi)
        {
            // Tìm chính xác bản ghi lịch hẹn bằng khóa chính MaLichHen trong DbSet LichHenXemPhongs
            var lichHen = _context.LichHenXemPhongs.FirstOrDefault(x => x.MaLichHen == id);
            
            if (lichHen == null) return false; // Không tìm thấy trả về false để Controller báo lỗi

            // Gán giá trị trạng thái mới (Ví dụ: "Đã hoàn thành")
            lichHen.TrangThai = trangThaiMoi;

            // Đồng bộ lệnh UPDATE xuống database SQL Server thực tế
            return _context.SaveChanges() > 0; 
        }

        // 4. Cập nhật THÔNG TIN CHI TIẾT (Dành riêng cho màn hình sửa dữ liệu thô AD_EditLich)
        public bool UpdateLichHen(int id, CreateLichHenDto dto)
        {
            // Tìm lịch hẹn cần sửa bằng khóa chính
            var lichHen = _context.LichHenXemPhongs.FirstOrDefault(x => x.MaLichHen == id);
            if (lichHen == null) return false;

            // Tiến hành cập nhật đè các dữ liệu chữ, số, ngày tháng từ Form Admin gửi về
            lichHen.HoTenKhach = dto.HoTenKhach;
            lichHen.Sdtkhach = dto.SdtKhach;     // Gán chuẩn map trường SdtKhach
            lichHen.MaPhong = dto.MaPhong;
            lichHen.ThoiGianHen = dto.ThoiGianHen;
            lichHen.GhiChu = dto.GhiChu;

            // Thực thi câu lệnh UPDATE xuống SQL Server
            return _context.SaveChanges() > 0;
        }

        //  5.  Xóa hẳn vĩnh viễn khỏi Database (Dành cho màn hình AD_DeleteLich)
        public bool DeleteLichHen(int id)
        {
            // Tìm bản ghi dựa trên khóa chính MaLichHen
            var lichHen = _context.LichHenXemPhongs.FirstOrDefault(x => x.MaLichHen == id);
            
            if (lichHen == null) return false; // Không tìm thấy bản ghi thì huỷ lệnh

            // Thực hiện xoá cứng dòng dữ liệu này ra khỏi Entity Framework
            _context.LichHenXemPhongs.Remove(lichHen);

            // Đẩy lệnh DELETE xuống SQL Server thực tế
            return _context.SaveChanges() > 0;
        }
        public object GetLichHenById(int id)
        {
            // Ép Entity Framework nạp kèm dữ liệu liên kết bảng từ SQL Server
            var lichHen = _context.LichHenXemPhongs
                .Include(l => l.MaPhongNavigation)       // Kết nối sang bảng Phong
                    .ThenInclude(p => p.MaCoSoNavigation) // Từ bảng Phong kết nối tiếp sang bảng CoSo
                .FirstOrDefault(l => l.MaLichHen == id);

            if (lichHen == null) return null;

            // Trả về cấu trúc DTO tường minh cho Controller bắn sang Flutter hứng
            return new
            {
                MaLichHen = lichHen.MaLichHen,
                HoTenKhach = lichHen.HoTenKhach,
                SDTKhach = lichHen.Sdtkhach,
                ThoiGianHen = lichHen.ThoiGianHen,
                GhiChu = lichHen.GhiChu,
                TrangThai = lichHen.TrangThai,
                // Trích xuất an toàn tránh lỗi sập NullReferenceException
                SoPhong = lichHen.MaPhongNavigation?.SoPhong ?? "Trống",
                TenCoSo = lichHen.MaPhongNavigation?.MaCoSoNavigation?.TenCoSo ?? "Chưa rõ cơ sở"
            };
        }
    }
}