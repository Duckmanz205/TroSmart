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

        // GET: api/TinNhan/Admin/1/Recent
        [HttpGet("Admin/{maAdmin}/Recent")]
        public async Task<ActionResult<IEnumerable<object>>> GetRecentChatsForAdmin(int maAdmin)
        {
            var messages = await _context.TinNhans
                .Where(t => (t.MaNguoiGui == maAdmin && t.VaiTroNguoiGui == "Admin") ||
                            (t.MaNguoiNhan == maAdmin && t.VaiTroNguoiNhan == "Admin"))
                .ToListAsync();

            var userIds = messages
                .Select(t => t.VaiTroNguoiGui == "User" ? t.MaNguoiGui : t.MaNguoiNhan)
                .Where(id => id.HasValue)
                .Select(id => id.Value)
                .Distinct()
                .ToList();

            var recentChats = new List<object>();

            foreach (var userId in userIds)
            {
                var userMessages = messages
                    .Where(t => (t.MaNguoiGui == userId && t.VaiTroNguoiGui == "User") ||
                                (t.MaNguoiNhan == userId && t.VaiTroNguoiNhan == "User"))
                    .OrderByDescending(t => t.NgayGui)
                    .ToList();

                var lastMessage = userMessages.FirstOrDefault();
                if (lastMessage != null)
                {
                    var khachThue = await _context.KhachThues.FindAsync(userId);
                    var hopDong = await _context.HopDongThues
                        .Include(h => h.MaPhongNavigation)
                        .Where(h => h.MaKhach == userId && h.TrangThai == "Đang hiệu lực")
                        .FirstOrDefaultAsync();

                    var unreadCount = userMessages.Count(t => t.MaNguoiNhan == maAdmin && t.VaiTroNguoiNhan == "Admin" && t.DaDoc == false);

                    recentChats.Add(new
                    {
                        MaKhach = userId,
                        TenKhach = khachThue?.HoTen ?? "Khách " + userId,
                        SoPhong = hopDong?.MaPhongNavigation?.SoPhong ?? "N/A",
                        LastMessage = lastMessage.NoiDung,
                        NgayGui = lastMessage.NgayGui,
                        IsUnread = unreadCount > 0,
                        UnreadCount = unreadCount
                    });
                }
            }

            return Ok(recentChats.OrderByDescending(c => ((dynamic)c).NgayGui));
        }
    }
}
