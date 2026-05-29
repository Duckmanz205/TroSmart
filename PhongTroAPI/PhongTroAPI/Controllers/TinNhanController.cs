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
    public class TinNhanController : ControllerBase
    {
        private readonly QuanLyPhongTroContext _context;

        public TinNhanController(QuanLyPhongTroContext context)
        {
            _context = context;
        }

        // GET: api/TinNhan/5/1
        // maNguoi1 có thể là admin, maNguoi2 có thể là user
        [HttpGet("{maAdmin}/{maKhach}")]
        public async Task<ActionResult<IEnumerable<TinNhan>>> GetChatHistory(int maAdmin, int maKhach)
        {
            var history = await _context.TinNhans
                .Where(t => 
                    (t.MaNguoiGui == maAdmin && t.VaiTroNguoiGui == "Admin" && t.MaNguoiNhan == maKhach && t.VaiTroNguoiNhan == "User") ||
                    (t.MaNguoiGui == maKhach && t.VaiTroNguoiGui == "User" && t.MaNguoiNhan == maAdmin && t.VaiTroNguoiNhan == "Admin")
                )
                .OrderBy(t => t.NgayGui)
                .ToListAsync();

            return history;
        }

        // POST: api/TinNhan
        [HttpPost]
        public async Task<ActionResult<TinNhan>> SendMessage(TinNhan tinNhan)
        {
            tinNhan.NgayGui = System.DateTime.Now;
            tinNhan.DaDoc = false;
            
            _context.TinNhans.Add(tinNhan);
            await _context.SaveChangesAsync();

            return Ok(tinNhan);
        }
    }
}
