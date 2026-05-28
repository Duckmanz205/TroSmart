using System;
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

        [HttpPost]
        public IActionResult Create([FromBody] CreateLichHenDto dto)
        {
            var result = _lichHenService.CreateLichHen(dto);
            if (!result) return BadRequest("Không thể tạo lịch hẹn. Vui lòng kiểm tra lại thông tin!");
            return Ok(new { Message = "Đặt lịch hẹn xem phòng thành công!" });
        }

        [HttpGet]
        public IActionResult GetAll()
        {
            var result = _lichHenService.GetAllLichHens();
            return Ok(result);
        }

        [HttpGet("{id}")]
        public IActionResult GetById(int id)
        {
            var result = _lichHenService.GetLichHenById(id);
            if (result == null) return NotFound("Không tìm thấy lịch hẹn!");
            return Ok(result);
        }

        [HttpPut("{id}/trang-thai")]
        public IActionResult UpdateTrangThai(int id, [FromBody] string trangThai)
        {
            var result = _lichHenService.UpdateLichHenTrangThai(id, trangThai);
            if (!result) return NotFound("Không tìm thấy lịch hẹn!");
            return Ok(new { Message = "Cập nhật trạng thái lịch hẹn thành công!" });
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var result = _lichHenService.DeleteLichHen(id);
            if (!result) return NotFound("Không tìm thấy lịch hẹn!");
            return Ok(new { Message = "Xóa lịch hẹn thành công!" });
        }
    }
}
