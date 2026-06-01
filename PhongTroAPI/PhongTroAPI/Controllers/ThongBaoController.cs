using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PhongTroAPI.Entities;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PhongTroAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ThongBaoController : ControllerBase
    {
        private readonly QuanLyPhongTroContext _context;

        public ThongBaoController(QuanLyPhongTroContext context)
        {
            _context = context;
        }

        // GET: api/ThongBao
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ThongBao>>> GetThongBaos()
        {
            return await _context.ThongBaos.OrderByDescending(t => t.NgayGui).ToListAsync();
        }

        // GET: api/ThongBao/user/5
        [HttpGet("user/{maKhach}")]
        public async Task<ActionResult<IEnumerable<ThongBao>>> GetThongBaoForUser(int maKhach)
        {
            return await _context.ThongBaos
                .Where(t => t.MaKhach == maKhach)
                .OrderByDescending(t => t.NgayGui)
                .ToListAsync();
        }

        // POST: api/ThongBao
        [HttpPost]
        public async Task<ActionResult<ThongBao>> PostThongBao(ThongBao thongBao)
        {
            thongBao.NgayGui = System.DateTime.Now;
            _context.ThongBaos.Add(thongBao);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetThongBaos", new { id = thongBao.MaThongBao }, thongBao);
        }

        // GET: api/ThongBao/danh-sach-khach
        [HttpGet("danh-sach-khach")]
        public async Task<ActionResult<IEnumerable<object>>> GetDanhSachKhach()
        {
            // Get all active contracts to find current tenants
            var khachThues = await _context.HopDongThues
                .Include(hd => hd.MaKhachNavigation)
                .Include(hd => hd.MaPhongNavigation)
                .Where(hd => hd.TrangThai == "Đang hiệu lực" || hd.TrangThai == "Đã ký")
                .Select(hd => new
                {
                    MaKhach = hd.MaKhach,
                    HoTen = hd.MaKhachNavigation.HoTen,
                    SoPhong = hd.MaPhongNavigation.SoPhong
                })
                .Distinct()
                .ToListAsync();
            
            return Ok(khachThues);
        }
    }
}
