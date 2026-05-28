using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.IdentityModel.Tokens;
using PhongTroAPI.DTOs;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace PhongTroAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly string _connStr;

        public AuthController(IConfiguration config)
        {
            _config = config;
            _connStr = config.GetConnectionString("DefaultConnection")!;
        }

        // ─────────────────────────────────────────────
        // POST /api/auth/register
        // ─────────────────────────────────────────────
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest request)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            await using var conn = new SqlConnection(_connStr);
            await conn.OpenAsync();

            // Bước 1: Kiểm tra TenDangNhap đã tồn tại chưa
            await using (var checkCmd = new SqlCommand(
                "SELECT COUNT(1) FROM TaiKhoan WHERE TenDangNhap = @TenDangNhap", conn))
            {
                checkCmd.Parameters.AddWithValue("@TenDangNhap", request.TenDangNhap.Trim());
                var count = Convert.ToInt32(await checkCmd.ExecuteScalarAsync() ?? 0);
                if (count > 0)
                    return BadRequest(new { message = "Tên đăng nhập đã được sử dụng" });
            }

            // Bước 2 → 4: Mở transaction, INSERT KhachThue, INSERT TaiKhoan, COMMIT
            await using var transaction = (SqlTransaction)await conn.BeginTransactionAsync();
            try
            {
                // INSERT vào KhachThue
                int maKhach;
                await using (var insertKhachCmd = new SqlCommand(
                    @"INSERT INTO KhachThue (HoTen, SDT)
                      VALUES (@HoTen, @SDT);
                      SELECT CAST(SCOPE_IDENTITY() AS INT);", conn, transaction))
                {
                    insertKhachCmd.Parameters.AddWithValue("@HoTen", request.HoTen.Trim());
                    insertKhachCmd.Parameters.AddWithValue("@SDT",
                        string.IsNullOrWhiteSpace(request.SDT) ? DBNull.Value : (object)request.SDT.Trim());

                    var result = await insertKhachCmd.ExecuteScalarAsync();
                    maKhach = Convert.ToInt32(result);
                }

                // INSERT vào TaiKhoan (VaiTro hard-code = 'KhachThue', lưu plain text)
                int maTaiKhoan;
                await using (var insertTkCmd = new SqlCommand(
                    @"INSERT INTO TaiKhoan (TenDangNhap, MatKhau, VaiTro, MaKhach, MaQuanLy)
                      VALUES (@TenDangNhap, @MatKhau, N'KhachThue', @MaKhach, NULL);
                      SELECT CAST(SCOPE_IDENTITY() AS INT);", conn, transaction))
                {
                    insertTkCmd.Parameters.AddWithValue("@TenDangNhap", request.TenDangNhap.Trim());
                    insertTkCmd.Parameters.AddWithValue("@MatKhau", request.MatKhau); // plain text
                    insertTkCmd.Parameters.AddWithValue("@MaKhach", maKhach);

                    var result = await insertTkCmd.ExecuteScalarAsync();
                    maTaiKhoan = Convert.ToInt32(result);
                }

                await transaction.CommitAsync();

                // Bước 5: Tạo JWT và trả AuthResponse
                var token = GenerateJwtToken(maTaiKhoan, request.TenDangNhap.Trim(),
                    "KhachThue", maKhach, request.HoTen.Trim());

                return Ok(new AuthResponse
                {
                    Token = token,
                    MaTaiKhoan = maTaiKhoan,
                    TenDangNhap = request.TenDangNhap.Trim(),
                    HoTen = request.HoTen.Trim(),
                    VaiTro = "KhachThue",
                    MaKhach = maKhach
                });
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                return StatusCode(500, new { message = "Đăng ký thất bại. Vui lòng thử lại.", detail = ex.Message });
            }
        }

        // ─────────────────────────────────────────────
        // POST /api/auth/login
        // ─────────────────────────────────────────────
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            await using var conn = new SqlConnection(_connStr);
            await conn.OpenAsync();

            // Bước 1: Query TaiKhoan JOIN KhachThue / NguoiQuanLy theo TenDangNhap
            const string sql = @"
                SELECT tk.MaTaiKhoan, tk.TenDangNhap, tk.MatKhau, tk.VaiTro,
                       tk.TrangThai, tk.MaKhach, tk.MaQuanLy,
                       COALESCE(k.HoTen, q.HoTen) AS HoTen
                FROM TaiKhoan tk
                LEFT JOIN KhachThue k ON tk.MaKhach = k.MaKhach
                LEFT JOIN NguoiQuanLy q ON tk.MaQuanLy = q.MaQuanLy
                WHERE tk.TenDangNhap = @TenDangNhap";

            await using var cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@TenDangNhap", request.TenDangNhap.Trim());

            await using var reader = await cmd.ExecuteReaderAsync();

            // Bước 2: Không tìm thấy → 401
            if (!await reader.ReadAsync())
                return Unauthorized(new { message = "Tên đăng nhập hoặc mật khẩu không đúng" });

            var maTaiKhoan = reader.GetInt32(reader.GetOrdinal("MaTaiKhoan"));
            var tenDangNhap = reader.GetString(reader.GetOrdinal("TenDangNhap"));
            var matKhauDb = reader.GetString(reader.GetOrdinal("MatKhau"));
            var vaiTro = reader.GetString(reader.GetOrdinal("VaiTro"));
            // NULL TrangThai cũng coi là 'Hoạt động' (dữ liệu mẫu INSERT không set TrangThai)
            var trangThaiRaw = reader.IsDBNull(reader.GetOrdinal("TrangThai"))
                ? null
                : reader.GetString(reader.GetOrdinal("TrangThai"));
            var trangThai = string.IsNullOrWhiteSpace(trangThaiRaw) ? "Hoạt động" : trangThaiRaw;
            int? maKhach = reader.IsDBNull(reader.GetOrdinal("MaKhach"))
                ? null
                : reader.GetInt32(reader.GetOrdinal("MaKhach"));
            int? maQuanLy = reader.IsDBNull(reader.GetOrdinal("MaQuanLy"))
                ? null
                : reader.GetInt32(reader.GetOrdinal("MaQuanLy"));
            var hoTen = reader.IsDBNull(reader.GetOrdinal("HoTen"))
                ? tenDangNhap
                : reader.GetString(reader.GetOrdinal("HoTen"));

            await reader.CloseAsync();

            // Bước 3: So sánh mật khẩu plain text
            if (request.MatKhau != matKhauDb)
                return Unauthorized(new { message = "Tên đăng nhập hoặc mật khẩu không đúng" });

            // Bước 4: Kiểm tra trạng thái tài khoản
            if (trangThai != "Hoạt động")
                return StatusCode(403, new { message = "Tài khoản đã bị khóa" });

            // Bước 5 & 6: Tạo JWT và trả AuthResponse
            var token = GenerateJwtToken(maTaiKhoan, tenDangNhap, vaiTro, maKhach, hoTen);

            return Ok(new AuthResponse
            {
                Token = token,
                MaTaiKhoan = maTaiKhoan,
                TenDangNhap = tenDangNhap,
                HoTen = hoTen,
                VaiTro = vaiTro,
                MaKhach = maKhach,
                MaQuanLy = maQuanLy
            });
        }

        // ─────────────────────────────────────────────
        // Hàm tạo JWT token
        // ─────────────────────────────────────────────
        private string GenerateJwtToken(int maTaiKhoan, string tenDangNhap,
            string vaiTro, int? maKhach, string hoTen)
        {
            var secretKey = _config["JwtSettings:SecretKey"]!;
            var issuer = _config["JwtSettings:Issuer"]!;
            var audience = _config["JwtSettings:Audience"]!;
            var expiryDays = int.TryParse(_config["JwtSettings:ExpiryDays"], out var d) ? d : 7;

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var claims = new List<Claim>
            {
                new Claim("MaTaiKhoan", maTaiKhoan.ToString()),
                new Claim(ClaimTypes.Name, tenDangNhap),
                new Claim(ClaimTypes.Role, vaiTro),
                new Claim("HoTen", hoTen),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            };

            if (maKhach.HasValue)
                claims.Add(new Claim("MaKhach", maKhach.Value.ToString()));

            var token = new JwtSecurityToken(
                issuer: issuer,
                audience: audience,
                claims: claims,
                expires: DateTime.UtcNow.AddDays(expiryDays),
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
