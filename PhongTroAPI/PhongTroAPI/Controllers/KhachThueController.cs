using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PhongTroAPI.Entities;
using System.Linq;
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
            var khachThue = await _context.KhachThues.FindAsync(id);

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
                return BadRequest();
            }

            var existingKhach = await _context.KhachThues.FindAsync(id);
            if (existingKhach == null)
            {
                return NotFound();
            }

            existingKhach.HoTen = khachThue.HoTen;
            existingKhach.Sdt = khachThue.Sdt;
            existingKhach.Cccd = khachThue.Cccd;
            existingKhach.Email = khachThue.Email;
            existingKhach.GioiTinh = khachThue.GioiTinh;
            existingKhach.DiaChiThuongTru = khachThue.DiaChiThuongTru;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!KhachThueExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        private bool KhachThueExists(int id)
        {
            return _context.KhachThues.Any(e => e.MaKhach == id);
        }
    }
}
