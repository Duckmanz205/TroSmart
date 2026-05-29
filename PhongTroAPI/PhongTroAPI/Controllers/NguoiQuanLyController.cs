using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PhongTroAPI.Entities;
using System.Linq;
using System.Threading.Tasks;

namespace PhongTroAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NguoiQuanLyController : ControllerBase
    {
        private readonly QuanLyPhongTroContext _context;

        public NguoiQuanLyController(QuanLyPhongTroContext context)
        {
            _context = context;
        }

        // GET: api/NguoiQuanLy/5
        [HttpGet("{id}")]
        public async Task<ActionResult<NguoiQuanLy>> GetNguoiQuanLy(int id)
        {
            var nguoiQuanLy = await _context.NguoiQuanLies.FindAsync(id);

            if (nguoiQuanLy == null)
            {
                return NotFound();
            }

            return nguoiQuanLy;
        }

        // PUT: api/NguoiQuanLy/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutNguoiQuanLy(int id, NguoiQuanLy nguoiQuanLy)
        {
            if (id != nguoiQuanLy.MaQuanLy)
            {
                return BadRequest();
            }

            var existingManager = await _context.NguoiQuanLies.FindAsync(id);
            if (existingManager == null)
            {
                return NotFound();
            }

            // Update fields
            existingManager.HoTen = nguoiQuanLy.HoTen;
            existingManager.Sdt = nguoiQuanLy.Sdt;
            existingManager.Email = nguoiQuanLy.Email;
            existingManager.SoTaiKhoan = nguoiQuanLy.SoTaiKhoan;
            existingManager.TenTaiKhoan = nguoiQuanLy.TenTaiKhoan;
            existingManager.MaNganHang = nguoiQuanLy.MaNganHang;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!NguoiQuanLyExists(id))
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

        private bool NguoiQuanLyExists(int id)
        {
            return _context.NguoiQuanLies.Any(e => e.MaQuanLy == id);
        }
    }
}
