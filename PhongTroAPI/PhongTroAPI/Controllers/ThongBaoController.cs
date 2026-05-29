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
            return await _context.ThongBaos.OrderByDescending(t => t.NgayTao).ToListAsync();
        }

        // GET: api/ThongBao/user/5
        [HttpGet("user/{maKhach}")]
        public async Task<ActionResult<IEnumerable<ThongBao>>> GetThongBaoForUser(int maKhach)
        {
            return await _context.ThongBaos
                .Where(t => t.MaKhachNhan == maKhach || t.MaKhachNhan == null)
                .OrderByDescending(t => t.NgayTao)
                .ToListAsync();
        }

        // POST: api/ThongBao
        [HttpPost]
        public async Task<ActionResult<ThongBao>> PostThongBao(ThongBao thongBao)
        {
            thongBao.NgayTao = System.DateTime.Now;
            _context.ThongBaos.Add(thongBao);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetThongBaos", new { id = thongBao.MaThongBao }, thongBao);
        }
    }
}
