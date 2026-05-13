using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using PhongTroAPI.DTOs;
using PhongTroAPI.Entities;

namespace PhongTroAPI.Services;

public class InvoiceService : IInvoiceService
{
    private readonly QuanLyPhongTroContext _context;

    public InvoiceService(QuanLyPhongTroContext context)
    {
        _context = context;
    }

    public async Task<List<InvoiceDto>> GetInvoicesAsync(int month, int year)
    {
        var invoices = await _context.HoaDons
            .Include(h => h.MaPhongNavigation)
            .Where(h => h.Thang == month && h.Nam == year)
            .Select(h => new InvoiceDto
            {
                MaHoaDon = h.MaHoaDon,
                MaPhong = h.MaPhong,
                TenPhong = h.MaPhongNavigation != null ? h.MaPhongNavigation.SoPhong : string.Empty,
                Thang = h.Thang,
                Nam = h.Nam,
                SoDienCu = h.ChiSoDienCu,
                SoDienMoi = h.ChiSoDienMoi,
                SoNuocCu = h.ChiSoNuocCu,
                SoNuocMoi = h.ChiSoNuocMoi,
                TienPhong = h.TienPhong,
                PhuPhi = h.PhuPhi ?? 0,
                TongTien = h.TongTien,
                TrangThai = h.TrangThai
            })
            .ToListAsync();

        return invoices;
    }

    public async Task<InvoiceDto?> GetInvoiceByIdAsync(int id)
    {
        var invoice = await _context.HoaDons
            .Include(h => h.MaPhongNavigation)
            .FirstOrDefaultAsync(h => h.MaHoaDon == id);

        if (invoice == null) return null;

        return new InvoiceDto
        {
            MaHoaDon = invoice.MaHoaDon,
            MaPhong = invoice.MaPhong,
            TenPhong = invoice.MaPhongNavigation != null ? invoice.MaPhongNavigation.SoPhong : string.Empty,
            Thang = invoice.Thang,
            Nam = invoice.Nam,
            SoDienCu = invoice.ChiSoDienCu,
            SoDienMoi = invoice.ChiSoDienMoi,
            SoNuocCu = invoice.ChiSoNuocCu,
            SoNuocMoi = invoice.ChiSoNuocMoi,
            TienPhong = invoice.TienPhong,
            PhuPhi = invoice.PhuPhi ?? 0,
            TongTien = invoice.TongTien,
            TrangThai = invoice.TrangThai
        };
    }

    public async Task<InvoiceDto> CreateInvoiceAsync(InvoiceCreateDto createDto)
    {
        var phong = await _context.Phongs.FindAsync(createDto.MaPhong);
        if (phong == null)
        {
            throw new Exception("Không tìm thấy phòng.");
        }

        // Logic tính toán điện nước
        decimal tienDien = (decimal)(createDto.SoDienMoi - createDto.SoDienCu) * createDto.DonGiaDien;
        decimal tienNuoc = (decimal)(createDto.SoNuocMoi - createDto.SoNuocCu) * createDto.DonGiaNuoc;
        
        // Tổng tiền = Tiền phòng + Tiền điện + Tiền nước + Phụ phí
        decimal tongTien = phong.GiaThue + tienDien + tienNuoc + createDto.PhuPhi;

        var hoaDon = new HoaDon
        {
            MaPhong = createDto.MaPhong,
            Thang = createDto.Thang,
            Nam = createDto.Nam,
            ChiSoDienCu = (int)createDto.SoDienCu,
            ChiSoDienMoi = (int)createDto.SoDienMoi,
            DonGiaDien = createDto.DonGiaDien,
            ChiSoNuocCu = (int)createDto.SoNuocCu,
            ChiSoNuocMoi = (int)createDto.SoNuocMoi,
            DonGiaNuoc = createDto.DonGiaNuoc,
            TienPhong = phong.GiaThue, // Lấy giá thuê từ thông tin phòng
            PhuPhi = createDto.PhuPhi,
            TongTien = tongTien,
            TrangThai = "Chưa thanh toán",
            HanThanhToan = DateOnly.FromDateTime(DateTime.Now.AddDays(5))
        };

        _context.HoaDons.Add(hoaDon);
        await _context.SaveChangesAsync();

        return new InvoiceDto
        {
            MaHoaDon = hoaDon.MaHoaDon,
            MaPhong = hoaDon.MaPhong,
            TenPhong = phong.SoPhong,
            Thang = hoaDon.Thang,
            Nam = hoaDon.Nam,
            SoDienCu = hoaDon.ChiSoDienCu,
            SoDienMoi = hoaDon.ChiSoDienMoi,
            SoNuocCu = hoaDon.ChiSoNuocCu,
            SoNuocMoi = hoaDon.ChiSoNuocMoi,
            TienPhong = hoaDon.TienPhong,
            PhuPhi = hoaDon.PhuPhi ?? 0,
            TongTien = hoaDon.TongTien,
            TrangThai = hoaDon.TrangThai
        };
    }

    public async Task<bool> UpdateInvoiceStatusAsync(int id, InvoiceUpdateStatusDto updateDto)
    {
        var invoice = await _context.HoaDons.FindAsync(id);
        if (invoice == null) return false;

        invoice.TrangThai = updateDto.TrangThai;
        await _context.SaveChangesAsync();
        return true;
    }
}
