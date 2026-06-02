using Microsoft.AspNetCore.Mvc;
using PhongTroAPI.DTOs;
using PhongTroAPI.Services;
using System;

namespace PhongTroAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HopDongController : ControllerBase
    {
        private readonly HopDongService _hopDongService;

        public HopDongController(HopDongService hopDongService)
        {
            _hopDongService = hopDongService;
        }

        // GET: api/HopDong
        [HttpGet]
        public IActionResult GetAll()
        {
            var data = _hopDongService.GetAllHopDong();
            return Ok(data);
        }

        // GET: api/HopDong/5
        [HttpGet("{id}")]
        public IActionResult GetById(int id)
        {
            var data = _hopDongService.GetChiTietHopDong(id);
            if (data == null) return NotFound("Không tìm thấy hợp đồng!");
            return Ok(data);
        }

        // POST: api/HopDong
        [HttpPost]
        public IActionResult Create([FromBody] CreateHopDongDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);
            
            var result = _hopDongService.CreateHopDong(dto);
            if (result) return Ok(true);
            return BadRequest("Không thể tạo hợp đồng nháp. Vui lòng kiểm tra lại mã phòng/mã khách.");
        }

        // PUT: api/HopDong/5
        [HttpPut("{id}")]
        public IActionResult Update(int id, [FromBody] CreateHopDongDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            try
            {
                var result = _hopDongService.UpdateHopDong(id, dto);
                if (result) return Ok(true);
                return BadRequest("Không tìm thấy hợp đồng để cập nhật.");
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(ex.Message); // Trả về thông báo lỗi nếu hợp đồng đã ký
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Lỗi server: " + ex.Message);
            }
        }

        //  DELETE: api/HopDong/5
       [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                var result = _hopDongService.DeleteHopDong(id);
                if (result) return Ok(true);
                return BadRequest("Không thể xóa do dính khóa ngoại hoặc không tìm thấy!");
            }
            catch (InvalidOperationException ex)
            {
                // Bắt đúng lỗi nghiệp vụ "Đang hiệu lực" và báo về cho App
                return BadRequest(ex.Message); 
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Lỗi server: " + ex.Message);
            }
        }

        // POST: api/HopDong/5/ky (Giao thức ký số từ điện thoại Khách)
        [HttpPost("{id}/ky")]
        public IActionResult KyHopDong(int id, [FromBody] KyHopDongNangCaoDto dto)
        {
            if (id != dto.MaHopDong) return BadRequest("ID không khớp!");
            
            var result = _hopDongService.KyHopDongNangCao(dto);
            if (result) return Ok(true);
            return BadRequest("Không thể ký hợp đồng. Có thể hợp đồng đã được ký trước đó!");
        }

        // POST: api/HopDong/5/gia-han
        [HttpPost("{id}/gia-han")]
        public IActionResult GiaHan(int id, [FromBody] GiaHanHopDongDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var result = _hopDongService.GiaHanHopDong(id, dto);
            if (result) return Ok(true);
            return BadRequest("Gia hạn thất bại.");
        }
    }
}