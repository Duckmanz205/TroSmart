using System;
using Microsoft.AspNetCore.Mvc;
using PhongTroAPI.DTOs;
using PhongTroAPI.Services;

namespace PhongTroAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class HopDongController : ControllerBase
    {
        private readonly HopDongService _hopDongService;

        public HopDongController(HopDongService hopDongService)
        {
            _hopDongService = hopDongService;
        }

        //  Lấy toàn bộ danh sách hợp đồng (Dành cho trang AD_QLHopDong của Admin)
        [HttpGet]
        public IActionResult GetAll()
        {
            var result = _hopDongService.GetAllHopDong();
            return Ok(result);
        }

        [HttpPost]
        public IActionResult Create([FromBody] CreateHopDongDto dto)
        {
            var result = _hopDongService.CreateHopDong(dto);
            if (!result) return BadRequest("Không thể lập hợp đồng. Vui lòng kiểm tra lại thông tin!");
            return Ok(new { Message = "Lập hợp đồng nháp thành công!" });
        }

        [HttpPut("{id}")]
        public IActionResult Update(int id, [FromBody] CreateHopDongDto dto)
        {
            try
            {
                var result = _hopDongService.UpdateHopDong(id, dto);
                if (!result) return NotFound("Không tìm thấy hợp đồng!");
                return Ok(new { Message = "Cập nhật hợp đồng thành công!" });
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(ex.Message);
            }
        }

        //  Thay đổi route ký online để nhận DTO chữ ký số nâng cao phục vụ chấm đồ án
        [HttpPost("{id}/ky")]
        public IActionResult KyOnline(int id, [FromBody] KyHopDongNangCaoDto dto)
        {
            // Ép ID từ Route vào DTO để bảo mật
            dto.MaHopDong = id; 
            
            var result = _hopDongService.KyHopDongNangCao(dto);
            if (!result) return BadRequest("Không thể ký hợp đồng, sai mã băm bảo mật hoặc hợp đồng đã có hiệu lực!");
            return Ok(new { Message = "Ký số hợp đồng thành công và đã ghi nhận bảo mật mã băm!" });
        }

        [HttpGet("{id}")]
        public IActionResult GetById(int id)
        {
            var result = _hopDongService.GetChiTietHopDong(id);
            if (result == null) return NotFound("Không tìm thấy hợp đồng!");
            return Ok(result);
        }

        [HttpPost("{id}/gia-han")]
        public IActionResult GiaHan(int id, [FromBody] GiaHanHopDongDto dto)
        {
            var result = _hopDongService.GiaHanHopDong(id, dto);
            if (!result) return BadRequest("Gia hạn thất bại!");
            return Ok(new { Message = "Gia hạn hợp đồng thành công!" });
        }
    }
}