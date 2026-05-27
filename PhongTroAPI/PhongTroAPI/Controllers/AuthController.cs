using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;

namespace PhongTroAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        public class LoginRequest
        {
            public string Identifier { get; set; }
            public string Password { get; set; }
        }
        public class RegisterRequest
        {
            public string Email { get; set; }
            public string Password { get; set; }
            public string Name { get; set; }
            public string Phone { get; set; }
        }

        public class UserAccount
        {
            public string Email { get; set; }
            public string Password { get; set; }
            public string Name { get; set; }
            public string Phone { get; set; }
            public string Role { get; set; }
        }

        private static List<UserAccount> _users = new List<UserAccount>
        {
            new UserAccount { Email = "admin@gmail.com", Password = "123", Name = "Admin", Phone = "0123456789", Role = "admin" },
            new UserAccount { Email = "user@gmail.com", Password = "123", Name = "User", Phone = "0987654321", Role = "user" }
        };
        [HttpPost("register")]
        public IActionResult Register([FromBody] RegisterRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Email) || string.IsNullOrWhiteSpace(request.Password))
            {
                return BadRequest(new { message = "Vui lòng cung cấp đầy đủ thông tin (Email và Password)!" });
            }

            string email = request.Email.Trim().ToLower();

            if (_users.Any(u => u.Email == email))
            {
                return Conflict(new { message = "Email này đã được đăng ký!" });
            }

            string name = string.IsNullOrWhiteSpace(request.Name) ? "Người dùng mới" : request.Name;
            string phone = string.IsNullOrWhiteSpace(request.Phone) ? "" : request.Phone;

            var newUser = new UserAccount
            {
                Email = email,
                Password = request.Password,
                Name = name,
                Phone = phone,
                Role = "user"
            };

            _users.Add(newUser);

            return Ok(new
            {
                message = "Đăng ký tài khoản thành công",
                user = new { email = newUser.Email, name = newUser.Name, phone = newUser.Phone, role = newUser.Role }
            });
        }

        [HttpPost("login")]
        public IActionResult LoginPost([FromBody] LoginRequest request)
        {
            return ProcessLogin(request);
        }

        [HttpGet("login")]
        public IActionResult LoginGet([FromQuery] string identifier, [FromQuery] string password)
        {
            var request = new LoginRequest { Identifier = identifier, Password = password };
            return ProcessLogin(request);
        }

        private IActionResult ProcessLogin(LoginRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Identifier) || string.IsNullOrWhiteSpace(request.Password))
            {
                return BadRequest(new { message = "Vui lòng cung cấp đầy đủ thông tin!" });
            }

            string email = request.Identifier.Trim().ToLower();
            var user = _users.FirstOrDefault(u => u.Email == email && u.Password == request.Password);

            if (user != null)
            {
                return Ok(new
                {
                    message = $"Đăng nhập {user.Role} thành công",
                    user = new { role = user.Role, name = user.Name, email = user.Email, phone = user.Phone }
                });
            }

            return Unauthorized(new { message = "Tài khoản hoặc mật khẩu không chính xác" });
        }
    }
}
