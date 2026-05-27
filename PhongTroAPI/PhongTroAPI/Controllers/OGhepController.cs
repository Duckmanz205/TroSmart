using System;
using Microsoft.AspNetCore.Mvc;
using PhongTroAPI.DTOs;
using PhongTroAPI.Services;

namespace PhongTroAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OGhepController : ControllerBase
    {
        private readonly OGhepService _oGhepService;

        public OGhepController(OGhepService oGhepService)
        {
            _oGhepService = oGhepService;
        }

        [HttpPost]
        public IActionResult Create([FromBody] CreateOGhepDto dto)
        {
            var result = _oGhepService.CreateOGhep(dto);
            if (!result) return BadRequest("Không thể tạo bài đăng ở ghép!");
            return Ok(new { Message = "Tạo bài đăng ở ghép thành công!" });
        }

        [HttpGet]
        public IActionResult GetAll()
        {
            var result = _oGhepService.GetAllOGheps();
            return Ok(result);
        }

        [HttpGet("{id}")]
        public IActionResult GetById(int id)
        {
            var result = _oGhepService.GetOGhepById(id);
            if (result == null) return NotFound("Không tìm thấy bài đăng!");
            return Ok(result);
        }

        [HttpPut("{id}")]
        public IActionResult Update(int id, [FromBody] CreateOGhepDto dto)
        {
            var result = _oGhepService.UpdateOGhep(id, dto);
            if (!result) return NotFound("Không tìm thấy bài đăng!");
            return Ok(new { Message = "Cập nhật bài đăng thành công!" });
        }

        [HttpPut("{id}/trang-thai")]
        public IActionResult UpdateTrangThai(int id, [FromBody] string trangThai)
        {
            var result = _oGhepService.UpdateTrangThai(id, trangThai);
            if (!result) return NotFound("Không tìm thấy bài đăng!");
            return Ok(new { Message = "Cập nhật trạng thái bài đăng thành công!" });
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            var result = _oGhepService.DeleteOGhep(id);
            if (!result) return NotFound("Không tìm thấy bài đăng!");
            return Ok(new { Message = "Xóa bài đăng thành công!" });
        }
    }
}
