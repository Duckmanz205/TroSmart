using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PhongTroAPI.DTOs;
using PhongTroAPI.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using PhongTroAPI.DTOs;

namespace PhongTroAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OGhepController : ControllerBase
    {
        private readonly QuanLyPhongTroContext _context;

        public OGhepController(QuanLyPhongTroContext context)
        {
            _context = context;
        }

        // GET: /api/OGhep/chi-tiet/{maPhong}
        [HttpGet("chi-tiet/{maPhong}")]
        public async Task<IActionResult> GetChiTietOGhep(int maPhong)
        {
            // 1. Lấy thông tin phòng và cơ sở
            var phong = await _context.Phongs
                .Include(p => p.MaCoSoNavigation)
                .FirstOrDefaultAsync(p => p.MaPhong == maPhong);

            if (phong == null) 
                return NotFound(new { message = "Không tìm thấy phòng yêu cầu." });

            // 2. Tìm tất cả hợp đồng "Đang hiệu lực" của phòng này
            var danhSachHopDong = await _context.HopDongThues
                .Include(h => h.MaKhachNavigation)
                .Where(h => h.MaPhong == maPhong && h.TrangThai == "Đang hiệu lực")
                .OrderBy(h => h.NgayBatDau)
                .ToListAsync();

            int soNguoiO = danhSachHopDong.Count;

            // 3. Lấy hóa đơn mới nhất của phòng này để làm căn cứ tính toán chi phí
            var hoaDonMoiNhat = await _context.HoaDons
                .Where(h => h.MaPhong == maPhong)
                .OrderByDescending(h => h.Nam)
                .ThenByDescending(h => h.Thang)
                .FirstOrDefaultAsync();

            decimal tongHoaDon = hoaDonMoiNhat?.TongTien ?? phong.GiaThue; 
            decimal tienChiaDeu = soNguoiO > 0 ? (tongHoaDon / soNguoiO) : tongHoaDon;

            var dto = new OGhepViewDto
            {
                SoPhong = phong.SoPhong,
                TenCoSo = phong.MaCoSoNavigation?.TenCoSo ?? "Chưa rõ cơ sở",
                SoNguoiO = soNguoiO == 0 ? 1 : soNguoiO, 
                TongHoaDon = tongHoaDon,
                TienChiaDeu = tienChiaDeu
            };

            decimal daThu = 0;

            // 4. Nếu phòng trống (chưa có ai thuê)
            if (soNguoiO == 0)
            {
                dto.ThanhViens.Add(new ThanhVienOGhepDto
                {
                    MaKhach = 0,
                    HoTen = "Chưa có người ở",
                    VaiTro = "Trống",
                    TrangThaiThanhToan = "Chưa trả",
                    ConPhaiTra = tongHoaDon
                });
                dto.DaThu = 0;
                dto.ConLai = tongHoaDon;
                dto.PhanTramTienDo = 0;
            }
            else
            {
                // Duyệt danh sách khách thuê thực tế
                for (int i = 0; i < danhSachHopDong.Count; i++)
                {
                    var hd = danhSachHopDong[i];
                    bool isChuPhong = (i == 0); 

                    // 🌟 ĐÃ FIX: Bỏ chữ N lỗi cú pháp C# ở đây
                    string trangThaiThanhToan = "Chưa trả";
                    if (hoaDonMoiNhat != null)
                    {
                        if (hoaDonMoiNhat.TrangThai == "Đã thanh toán")
                        {
                            trangThaiThanhToan = "Đã trả";
                        }
                        else if (hoaDonMoiNhat.TrangThai == "Quá hạn")
                        {
                            trangThaiThanhToan = "Quá hạn";
                        }
                        else if (isChuPhong && hoaDonMoiNhat.TrangThai == "Một phần") 
                        {
                            trangThaiThanhToan = "Đã trả";
                        }
                    }

                    decimal conPhaiTra = trangThaiThanhToan == "Đã trả" ? 0 : tienChiaDeu;
                    if (trangThaiThanhToan == "Đã trả") daThu += tienChiaDeu;

                    dto.ThanhViens.Add(new ThanhVienOGhepDto
                    {
                        MaKhach = hd.MaKhach,
                        HoTen = hd.MaKhachNavigation?.HoTen ?? "Khách ở ghép",
                        VaiTro = isChuPhong ? "Chủ phòng" : "Ở ghép",
                        TrangThaiThanhToan = trangThaiThanhToan == "Đã trả" ? "Đã trả" : "Chưa trả",
                        ConPhaiTra = conPhaiTra
                    });
                }

                dto.DaThu = daThu;
                dto.ConLai = tongHoaDon - daThu;
                dto.PhanTramTienDo = tongHoaDon > 0 ? (double)(daThu / tongHoaDon) : 0;
            }

            return Ok(dto);
        }
    }
}