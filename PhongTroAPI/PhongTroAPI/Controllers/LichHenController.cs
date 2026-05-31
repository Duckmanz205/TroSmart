using Microsoft.AspNetCore.Mvc;
using PhongTroAPI.DTOs;
using PhongTroAPI.Services;


namespace PhongTroAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LichHenController : ControllerBase
    {
        private readonly LichHenService _lichHenService;

        public LichHenController(LichHenService lichHenService)
        {
            _lichHenService = lichHenService;
        }

        // 1. POST: /api/LichHen -> Dành cho màn hình đặt lịch xem phòng của khách
        [HttpPost]
        public IActionResult DatLich([FromBody] CreateLichHenDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var isSuccess = _lichHenService.CreateLichHen(dto);
            if (isSuccess) 
                return Ok(new { message = "Đặt lịch xem phòng thành công!" });
                
            return BadRequest(new { message = "Đã xảy ra lỗi khi lưu lịch hẹn." });
        }

        // 2. GET: /api/LichHen -> Dành cho màn hình danh sách Admin và lịch sử User
        [HttpGet]
        public IActionResult GetDanhSach()
        {
            var data = _lichHenService.GetDanhSachLichHen();
            return Ok(data);
        }

        // 3. PUT: /api/LichHen/{id}/status -> Dành cho nút Duyệt / Hoàn thành nhanh bên Admin
        [HttpPut("{id}/status")]
        public IActionResult CapNhatTrangThai(int id, [FromBody] UpdateStatusDto dto)
        {
            if (dto == null || string.IsNullOrEmpty(dto.TrangThaiMoi))
            {
                return BadRequest(new { message = "Dữ liệu trạng thái mới không hợp lệ." });
            }

            var isSuccess = _lichHenService.UpdateTrangThaiLich(id, dto.TrangThaiMoi);
            if (isSuccess) 
                return Ok(new { message = $"Đã cập nhật trạng thái lịch hẹn sang: {dto.TrangThaiMoi}" });
                
            return NotFound(new { message = "Không tìm thấy lịch hẹn yêu cầu." });
        }

        // 4. PUT: /api/LichHen/{id} -> Tiếp nhận dữ liệu chỉnh sửa thô từ màn hình AD_EditLich
        [HttpPut("{id}")]
        public IActionResult SuaThongTinLichHen(int id, [FromBody] CreateLichHenDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var isSuccess = _lichHenService.UpdateLichHen(id, dto);
            if (isSuccess) 
                return Ok(new { message = "Cập nhật thông tin lịch hẹn thành công!" });
                
            return NotFound(new { message = "Không tìm thấy lịch hẹn hoặc dữ liệu không thay đổi." });
        }

        // 5. DELETE: /api/LichHen/{id} -> Nút bấm xác nhận xoá hẳn bên màn hình AD_DeleteLich
        [HttpDelete("{id}")]
        public IActionResult XoaLichHen(int id)
        {
            var isSuccess = _lichHenService.DeleteLichHen(id);
            if (isSuccess) 
                return Ok(new { message = "Đã xóa vĩnh viễn lịch hẹn ra khỏi cơ sở dữ liệu hệ thống!" });
                
            return NotFound(new { message = "Không tìm thấy lịch hẹn hoặc bản ghi đã bị xóa trước đó." });
        }

       [HttpGet("{id}")]
        public IActionResult GetChiTietLichHen(int id)
        {
            var data = _lichHenService.GetLichHenById(id);
            
            if (data == null) 
                return NotFound(new { message = "Không tìm thấy thông tin lịch hẹn này." });

            return Ok(data);
        }
    }
}