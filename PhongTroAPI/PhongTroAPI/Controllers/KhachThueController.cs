using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PhongTroAPI.Entities;
using System.Threading.Tasks;

namespace PhongTroAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KhachThueController : ControllerBase
    {
        private readonly QuanLyPhongTroContext _context;

        public KhachThueController(QuanLyPhongTroContext context)
        {
            _context = context;
        }

        // GET: api/KhachThue
        [HttpGet]
        public async Task<ActionResult<IEnumerable<KhachThue>>> GetKhachThues()
        {
            return await _context.KhachThues.ToListAsync();
        }

        // GET: api/KhachThue/5
        [HttpGet("{id}")]
        public async Task<ActionResult<KhachThue>> GetKhachThue(int id)
        {
            var khachThue = await _context.KhachThues
                .FirstOrDefaultAsync(k => k.MaKhach == id);

            if (khachThue == null)
            {
                return NotFound();
            }

            return khachThue;
        }

        // PUT: api/KhachThue/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutKhachThue(int id, KhachThue khachThue)
        {
            if (id != khachThue.MaKhach)
            {
                return BadRequest("ID không khớp");
            }

            var existingKhach = await _context.KhachThues.FindAsync(id);
            if (existingKhach == null)
            {
                return NotFound("Không tìm thấy khách thuê");
            }

            existingKhach.HoTen = khachThue.HoTen;
            existingKhach.Sdt = khachThue.Sdt;
            existingKhach.Email = khachThue.Email;
            existingKhach.Cccd = khachThue.Cccd;
            existingKhach.GioiTinh = khachThue.GioiTinh;
            existingKhach.DiaChiThuongTru = khachThue.DiaChiThuongTru;

            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
