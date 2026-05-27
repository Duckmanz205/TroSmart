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

        public bool CreateLichHen(CreateLichHenDto dto)
        {
            var phong = _context.Phongs.Find(dto.MaPhong);
            if (phong == null) return false;

            var lichHen = new LichHenXemPhong
            {
                MaKhach = dto.MaKhach,
                HoTenKhach = dto.HoTenKhach,
                Sdtkhach = dto.SdtKhach,
                MaPhong = dto.MaPhong,
                ThoiGianHen = dto.ThoiGianHen,
                GhiChu = dto.GhiChu,
                TrangThai = "Chờ xác nhận",
                NgayTao = DateTime.Now
            };

            _context.LichHenXemPhongs.Add(lichHen);
            return _context.SaveChanges() > 0;
        }

        public List<LichHenRenderDto> GetAllLichHens()
        {
            return _context.LichHenXemPhongs
                .Include(lh => lh.MaPhongNavigation)
                    .ThenInclude(p => p.MaCoSoNavigation)
                .Select(lh => new LichHenRenderDto
                {
                    MaLichHen = lh.MaLichHen,
                    MaKhach = lh.MaKhach,
                    HoTenKhach = lh.HoTenKhach,
                    SdtKhach = lh.Sdtkhach,
                    MaPhong = lh.MaPhong,
                    SoPhong = lh.MaPhongNavigation.SoPhong,
                    TenCoSo = lh.MaPhongNavigation.MaCoSoNavigation.TenCoSo,
                    ThoiGianHen = lh.ThoiGianHen,
                    GhiChu = lh.GhiChu,
                    TrangThai = lh.TrangThai,
                    NgayTao = lh.NgayTao
                })
                .ToList();
        }

        public LichHenRenderDto? GetLichHenById(int id)
        {
            return _context.LichHenXemPhongs
                .Include(lh => lh.MaPhongNavigation)
                    .ThenInclude(p => p.MaCoSoNavigation)
                .Where(lh => lh.MaLichHen == id)
                .Select(lh => new LichHenRenderDto
                {
                    MaLichHen = lh.MaLichHen,
                    MaKhach = lh.MaKhach,
                    HoTenKhach = lh.HoTenKhach,
                    SdtKhach = lh.Sdtkhach,
                    MaPhong = lh.MaPhong,
                    SoPhong = lh.MaPhongNavigation.SoPhong,
                    TenCoSo = lh.MaPhongNavigation.MaCoSoNavigation.TenCoSo,
                    ThoiGianHen = lh.ThoiGianHen,
                    GhiChu = lh.GhiChu,
                    TrangThai = lh.TrangThai,
                    NgayTao = lh.NgayTao
                })
                .FirstOrDefault();
        }

        public bool UpdateLichHenTrangThai(int id, string trangThai)
        {
            var lh = _context.LichHenXemPhongs.Find(id);
            if (lh == null) return false;

            lh.TrangThai = trangThai;
            return _context.SaveChanges() > 0;
        }

        public bool DeleteLichHen(int id)
        {
            var lh = _context.LichHenXemPhongs.Find(id);
            if (lh == null) return false;

            _context.LichHenXemPhongs.Remove(lh);
            return _context.SaveChanges() > 0;
        }
    }
}
