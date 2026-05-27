using Microsoft.EntityFrameworkCore;
using PhongTroAPI.Entities;

var builder = WebApplication.CreateBuilder(args);

// DB Context
builder.Services.AddDbContext<QuanLyPhongTroContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Controllers
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddScoped<HopDongService>();
builder.Services.AddScoped<OGhepService>();

// Services
builder.Services.AddScoped<PhongTroAPI.Services.IInvoiceService, PhongTroAPI.Services.InvoiceService>();

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


app.UseCors("AllowFlutterWeb");
app.UseStaticFiles();

app.UseAuthorization();

app.MapControllers();

app.Run();