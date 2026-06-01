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
            var activeTenants = await _context.HopDongThues
                .Include(h => h.MaKhachNavigation)
                .Include(h => h.MaPhongNavigation)
                .Where(h => h.TrangThai == "Đang hiệu lực")
                .ToListAsync();

            var messages = await _context.TinNhans
                .Where(t => (t.MaNguoiGui == maAdmin && t.VaiTroNguoiGui == "Admin") ||
                            (t.MaNguoiNhan == maAdmin && t.VaiTroNguoiNhan == "Admin"))
                .ToListAsync();

            var userIdsWithMessages = messages
                .Select(t => t.VaiTroNguoiGui == "User" ? t.MaNguoiGui : t.MaNguoiNhan)
                .Where(id => id.HasValue)
                .Select(id => id.Value)
                .Distinct()
                .ToList();

            var activeTenantIds = activeTenants.Select(h => h.MaKhach).Distinct().ToList();
            var allUserIds = activeTenantIds.Union(userIdsWithMessages).Distinct().ToList();

            var recentChats = new List<object>();

            foreach (var userId in allUserIds)
            {
                var userMessages = messages
                    .Where(t => (t.MaNguoiGui == userId && t.VaiTroNguoiGui == "User") ||
                                (t.MaNguoiNhan == userId && t.VaiTroNguoiNhan == "User"))
                    .OrderByDescending(t => t.NgayGui)
                    .ToList();

                var lastMessage = userMessages.FirstOrDefault();
                
                var hopDong = activeTenants.FirstOrDefault(h => h.MaKhach == userId);
                string tenKhach = hopDong?.MaKhachNavigation?.HoTen;
                string soPhong = hopDong?.MaPhongNavigation?.SoPhong;
                int category = 1; // 1: Khách đang thuê

                if (hopDong == null)
                {
                    var khachThue = await _context.KhachThues.FindAsync(userId);
                    tenKhach = khachThue?.HoTen;
                    var anyContract = await _context.HopDongThues
                        .Include(h => h.MaPhongNavigation)
                        .Where(h => h.MaKhach == userId)
                        .OrderByDescending(h => h.NgayBatDau)
                        .FirstOrDefaultAsync();
                        
                    if (anyContract != null)
                    {
                        category = 3; // 3: Khách hết hợp đồng
                        soPhong = anyContract.MaPhongNavigation?.SoPhong ?? "N/A";
                    }
                    else
                    {
                        category = 2; // 2: Khách quan tâm
                        soPhong = "N/A";
                    }
                }

                var unreadCount = userMessages.Count(t => t.MaNguoiNhan == maAdmin && t.VaiTroNguoiNhan == "Admin" && t.DaDoc == false);

                recentChats.Add(new
                {
                    MaKhach = userId,
                    TenKhach = tenKhach ?? "Khách " + userId,
                    SoPhong = soPhong,
                    LastMessage = lastMessage?.NoiDung ?? "Chưa có tin nhắn nào",
                    NgayGui = (DateTime?)lastMessage?.NgayGui,
                    IsUnread = unreadCount > 0,
                    UnreadCount = unreadCount,
                    Category = category
                });
            }

            return Ok(recentChats.OrderByDescending(c => ((dynamic)c).NgayGui ?? DateTime.MinValue));
        }

        // GET: api/TinNhan/User/1/Recent
        [HttpGet("User/{maKhach}/Recent")]
        public async Task<ActionResult<IEnumerable<object>>> GetRecentChatsForUser(int maKhach)
        {
            var messages = await _context.TinNhans
                .Where(t => (t.MaNguoiGui == maKhach && t.VaiTroNguoiGui == "User") ||
                            (t.MaNguoiNhan == maKhach && t.VaiTroNguoiNhan == "User"))
                .ToListAsync();

            var adminIdsWithMessages = messages
                .Select(t => t.VaiTroNguoiGui == "Admin" ? t.MaNguoiGui : t.MaNguoiNhan)
                .Where(id => id.HasValue)
                .Select(id => id.Value)
                .Distinct()
                .ToList();

            var recentChats = new List<object>();

            foreach (var adminId in adminIdsWithMessages)
            {
                var adminMessages = messages
                    .Where(t => (t.MaNguoiGui == adminId && t.VaiTroNguoiGui == "Admin") ||
                                (t.MaNguoiNhan == adminId && t.VaiTroNguoiNhan == "Admin"))
                    .OrderByDescending(t => t.NgayGui)
                    .ToList();

                var lastMessage = adminMessages.FirstOrDefault();
                
                var admin = await _context.NguoiQuanLies.FindAsync(adminId);
                string tenAdmin = admin?.HoTen ?? "Admin " + adminId;

                var unreadCount = adminMessages.Count(t => t.MaNguoiNhan == maKhach && t.VaiTroNguoiNhan == "User" && t.DaDoc == false);

                recentChats.Add(new
                {
                    MaAdmin = adminId,
                    TenAdmin = tenAdmin,
                    LastMessage = lastMessage?.NoiDung ?? "Chưa có tin nhắn nào",
                    NgayGui = (DateTime?)lastMessage?.NgayGui,
                    IsUnread = unreadCount > 0,
                    UnreadCount = unreadCount
                });
            }

            return Ok(recentChats.OrderByDescending(c => ((dynamic)c).NgayGui ?? DateTime.MinValue));
        }
    }
}
