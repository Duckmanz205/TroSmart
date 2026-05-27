using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using PhongTroAPI.DTOs;
using PhongTroAPI.Entities;

namespace PhongTroAPI.Services
{
    public class OGhepService
    {
        private readonly QuanLyPhongTroContext _context;

        public OGhepService(QuanLyPhongTroContext context)
        {
            _context = context;
        }

        public bool CreateOGhep(CreateOGhepDto dto)
        {
            var khach = _context.KhachThues.Find(dto.MaKhach);
            if (khach == null) return false;

            var oghep = new Oghep
            {
                MaKhach = dto.MaKhach,
                TieuDe = dto.TieuDe,
                NoiDung = dto.NoiDung,
                ChiPhiDuKien = dto.ChiPhiDuKien,
                KhuVuc = dto.KhuVuc,
                YeuCauGioiTinh = dto.YeuCauGioiTinh,
                TrangThai = "Đang tìm",
                NgayDang = DateTime.Now
            };

            _context.Ogheps.Add(oghep);
            return _context.SaveChanges() > 0;
        }

        public List<OGhepRenderDto> GetAllOGheps()
        {
            return _context.Ogheps
                .Include(o => o.MaKhachNavigation)
                .Select(o => new OGhepRenderDto
                {
                    MaBaiDang = o.MaBaiDang,
                    MaKhach = o.MaKhach,
                    TenKhach = o.MaKhachNavigation.HoTen ?? "N/A",
                    SDTKhach = o.MaKhachNavigation.Sdt ?? "N/A",
                    TieuDe = o.TieuDe,
                    NoiDung = o.NoiDung,
                    ChiPhiDuKien = o.ChiPhiDuKien,
                    KhuVuc = o.KhuVuc,
                    YeuCauGioiTinh = o.YeuCauGioiTinh,
                    TrangThai = o.TrangThai,
                    NgayDang = o.NgayDang
                })
                .ToList();
        }

        public OGhepRenderDto? GetOGhepById(int id)
        {
            return _context.Ogheps
                .Include(o => o.MaKhachNavigation)
                .Where(o => o.MaBaiDang == id)
                .Select(o => new OGhepRenderDto
                {
                    MaBaiDang = o.MaBaiDang,
                    MaKhach = o.MaKhach,
                    TenKhach = o.MaKhachNavigation.HoTen ?? "N/A",
                    SDTKhach = o.MaKhachNavigation.Sdt ?? "N/A",
                    TieuDe = o.TieuDe,
                    NoiDung = o.NoiDung,
                    ChiPhiDuKien = o.ChiPhiDuKien,
                    KhuVuc = o.KhuVuc,
                    YeuCauGioiTinh = o.YeuCauGioiTinh,
                    TrangThai = o.TrangThai,
                    NgayDang = o.NgayDang
                })
                .FirstOrDefault();
        }

        public bool UpdateOGhep(int id, CreateOGhepDto dto)
        {
            var oghep = _context.Ogheps.Find(id);
            if (oghep == null) return false;

            oghep.TieuDe = dto.TieuDe;
            oghep.NoiDung = dto.NoiDung;
            oghep.ChiPhiDuKien = dto.ChiPhiDuKien;
            oghep.KhuVuc = dto.KhuVuc;
            oghep.YeuCauGioiTinh = dto.YeuCauGioiTinh;

            return _context.SaveChanges() > 0;
        }

        public bool UpdateTrangThai(int id, string trangThai)
        {
            var oghep = _context.Ogheps.Find(id);
            if (oghep == null) return false;

            oghep.TrangThai = trangThai;
            return _context.SaveChanges() > 0;
        }

        public bool DeleteOGhep(int id)
        {
            var oghep = _context.Ogheps.Find(id);
            if (oghep == null) return false;

            _context.Ogheps.Remove(oghep);
            return _context.SaveChanges() > 0;
        }
    }
}
