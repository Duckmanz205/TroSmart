using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using PhongTroAPI.Entities;
using System.Text;
using PhongTroAPI.Services;

var builder = WebApplication.CreateBuilder(args);

// DB Context
builder.Services.AddDbContext<QuanLyPhongTroContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Controllers
builder.Services.AddControllers().AddJsonOptions(options =>
{
    options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
});
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Register Custom Services
builder.Services.AddScoped<HopDongService>();
builder.Services.AddScoped<OGhepService>();
builder.Services.AddScoped<LichHenService>();

// Services
builder.Services.AddScoped<PhongTroAPI.Services.IInvoiceService, PhongTroAPI.Services.InvoiceService>();

// ✅ JWT Authentication
var jwtSecret = builder.Configuration["JwtSettings:SecretKey"]!;
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSecret)),
            ValidateIssuer = true,
            ValidIssuer = builder.Configuration["JwtSettings:Issuer"],
            ValidateAudience = true,
            ValidAudience = builder.Configuration["JwtSettings:Audience"],
            ValidateLifetime = true,
            ClockSkew = TimeSpan.Zero
        };
    });

// ✅ THÊM CORS CHO FLUTTER WEB
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutterWeb", policy =>
    {
        policy
            .AllowAnyOrigin()
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

var app = builder.Build();

// Swagger
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Middleware
app.UseCors("AllowFlutterWeb");
app.UseStaticFiles();

app.UseAuthentication(); // ✅ PHẢI trước UseAuthorization
app.UseAuthorization();

app.MapControllers();

app.Run();
