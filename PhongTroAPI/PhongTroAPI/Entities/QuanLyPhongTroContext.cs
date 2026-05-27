using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace PhongTroAPI.Entities;

public partial class QuanLyPhongTroContext : DbContext
{
    public QuanLyPhongTroContext()
    {
    }

    public QuanLyPhongTroContext(DbContextOptions<QuanLyPhongTroContext> options)
        : base(options)
    {
    }

    public virtual DbSet<ChiSoDienNuoc> ChiSoDienNuocs { get; set; }

    public virtual DbSet<CoSo> CoSos { get; set; }

    public virtual DbSet<HinhAnhCoSo> HinhAnhCoSos { get; set; }

    public virtual DbSet<HinhAnhPhong> HinhAnhPhongs { get; set; }

    public virtual DbSet<HoaDon> HoaDons { get; set; }

    public virtual DbSet<HopDongThue> HopDongThues { get; set; }

    public virtual DbSet<KhachThue> KhachThues { get; set; }

    public virtual DbSet<LichSuThanhToan> LichSuThanhToans { get; set; }

    public virtual DbSet<NguoiQuanLy> NguoiQuanLies { get; set; }

    public virtual DbSet<Phong> Phongs { get; set; }

    public virtual DbSet<SuCo> SuCos { get; set; }

    public virtual DbSet<TaiKhoan> TaiKhoans { get; set; }

    public virtual DbSet<ThongBao> ThongBaos { get; set; }

    public virtual DbSet<TienIch> TienIches { get; set; }

    public virtual DbSet<ViewCoSoTongQuan> ViewCoSoTongQuans { get; set; }

    public virtual DbSet<ViewHoaDonUi> ViewHoaDonUis { get; set; }

    public virtual DbSet<ViewPhongUi> ViewPhongUis { get; set; }

    public virtual DbSet<LichHenXemPhong> LichHenXemPhongs { get; set; } 

    public virtual DbSet<OGhep> OGheps { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseSqlServer("Server=.;Database=QuanLyPhongTro;Integrated Security=True;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ChiSoDienNuoc>(entity =>
        {
            entity.HasKey(e => e.MaChiSo).HasName("PK__ChiSoDie__EBA18E15AC39FDF6");

            entity.ToTable("ChiSoDienNuoc");

            entity.HasIndex(e => new { e.MaPhong, e.Thang, e.Nam }, "UQ_ChiSo_Phong_Thang_Nam").IsUnique();

            entity.Property(e => e.NgayCapNhat)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.MaPhongNavigation).WithMany(p => p.ChiSoDienNuocs)
                .HasForeignKey(d => d.MaPhong)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ChiSoDien__MaPho__59FA5E80");
        });

        modelBuilder.Entity<CoSo>(entity =>
        {
            entity.HasKey(e => e.MaCoSo).HasName("PK__CoSo__152D0634C265D923");

            entity.ToTable("CoSo");

            entity.Property(e => e.DanhGia).HasDefaultValue(0.0);
            entity.Property(e => e.DiaChi).HasMaxLength(255);
            entity.Property(e => e.LoaiHinh).HasMaxLength(100);
            entity.Property(e => e.NgayTao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.TenCoSo).HasMaxLength(150);
            entity.Property(e => e.TrangThai)
                .HasMaxLength(50)
                .HasDefaultValue("Hoạt động");

            entity.HasOne(d => d.MaQuanLyNavigation).WithMany(p => p.CoSos)
                .HasForeignKey(d => d.MaQuanLy)
                .HasConstraintName("FK__CoSo__MaQuanLy__6D0D32F4");

            entity.HasMany(d => d.MaTienIches).WithMany(p => p.MaCoSos)
                .UsingEntity<Dictionary<string, object>>(
                    "CoSoTienIch",
                    r => r.HasOne<TienIch>().WithMany()
                        .HasForeignKey("MaTienIch")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__CoSo_Tien__MaTie__6EF57B66"),
                    l => l.HasOne<CoSo>().WithMany()
                        .HasForeignKey("MaCoSo")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__CoSo_Tien__MaCoS__6E01572D"),
                    j =>
                    {
                        j.HasKey("MaCoSo", "MaTienIch").HasName("PK__CoSo_Tie__A1447BBA5EA25C0B");
                        j.ToTable("CoSo_TienIch");
                    });
        });

        modelBuilder.Entity<HinhAnhCoSo>(entity =>
        {
            entity.HasKey(e => e.MaAnh).HasName("PK__HinhAnhC__356240DF828F9DD1");

            entity.ToTable("HinhAnhCoSo");

            entity.HasOne(d => d.MaCoSoNavigation).WithMany(p => p.HinhAnhCoSos)
                .HasForeignKey(d => d.MaCoSo)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HinhAnhCo__MaCoS__6FE99F9F");
        });

        modelBuilder.Entity<HinhAnhPhong>(entity =>
        {
            entity.HasKey(e => e.MaAnh).HasName("PK__HinhAnhP__356240DF3213C86A");

            entity.ToTable("HinhAnhPhong");

            entity.HasOne(d => d.MaPhongNavigation).WithMany(p => p.HinhAnhPhongs)
                .HasForeignKey(d => d.MaPhong)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HinhAnhPh__MaPho__70DDC3D8");
        });

        modelBuilder.Entity<HoaDon>(entity =>
        {
            entity.HasKey(e => e.MaHoaDon).HasName("PK__HoaDon__835ED13BEE2B232A");

            entity.ToTable("HoaDon");

            entity.Property(e => e.DonGiaDien).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.DonGiaNuoc).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.MoTaDichVu).HasMaxLength(255);
            entity.Property(e => e.MoTaPhuPhi).HasMaxLength(255);
            entity.Property(e => e.NgayLap).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.PhuPhi)
                .HasDefaultValue(0m)
                .HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TienDichVu)
                .HasDefaultValue(0m)
                .HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TienPhong).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TongTien).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(50)
                .HasDefaultValue("Chưa thanh toán");

            entity.HasOne(d => d.MaKhachNavigation).WithMany(p => p.HoaDons)
                .HasForeignKey(d => d.MaKhach)
                .HasConstraintName("FK__HoaDon__MaKhach__787EE5A0");

            entity.HasOne(d => d.MaPhongNavigation).WithMany(p => p.HoaDons)
                .HasForeignKey(d => d.MaPhong)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HoaDon__MaPhong__778AC167");
        });

        modelBuilder.Entity<HopDongThue>(entity =>
        {
            entity.HasKey(e => e.MaHopDong).HasName("PK__HopDongT__36DD43426F9B2C9F");

            entity.ToTable("HopDongThue");

            entity.Property(e => e.NgayTao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.Property(e => e.TienCoc)
                .HasDefaultValue(0m)
                .HasColumnType("decimal(18, 2)");

            entity.Property(e => e.TrangThai)
                .HasMaxLength(50)
                .HasDefaultValue("Chờ khách ký");

            // THÊM DÒNG NÀY: Cấu hình lưu trữ chuỗi chữ ký số Base64 siêu dài
            entity.Property(e => e.ChuKy).HasColumnType("nvarchar(max)");

            entity.HasOne(d => d.MaKhachNavigation).WithMany(p => p.HopDongThues)
                .HasForeignKey(d => d.MaKhach)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HopDongTh__MaKha__76969D2E");

            entity.HasOne(d => d.MaPhongNavigation).WithMany(p => p.HopDongThues)
                .HasForeignKey(d => d.MaPhong)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HopDongTh__MaPho__75A278F5");
        });
        modelBuilder.Entity<KhachThue>(entity =>
        {
            entity.HasKey(e => e.MaKhach).HasName("PK__KhachThu__D0CB8DDDDF8057E8");

            entity.ToTable("KhachThue");

            entity.Property(e => e.Cccd)
                .HasMaxLength(20)
                .IsUnicode(false)
                .HasColumnName("CCCD");
            entity.Property(e => e.HoTen).HasMaxLength(100);
            entity.Property(e => e.Sdt)
                .HasMaxLength(15)
                .IsUnicode(false)
                .HasColumnName("SDT");
        });

        modelBuilder.Entity<LichSuThanhToan>(entity =>
        {
            entity.HasKey(e => e.MaThanhToan).HasName("PK__LichSuTh__D4B258442B25A72B");

            entity.ToTable("LichSuThanhToan");

            entity.Property(e => e.NgayThanhToan)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.PhuongThuc).HasMaxLength(50);
            entity.Property(e => e.SoTien).HasColumnType("decimal(18, 2)");

            entity.HasOne(d => d.MaHoaDonNavigation).WithMany(p => p.LichSuThanhToans)
                .HasForeignKey(d => d.MaHoaDon)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LichSuTha__MaHoa__03F0984C");

            entity.HasOne(d => d.NguoiGhiNhanNavigation).WithMany(p => p.LichSuThanhToans)
                .HasForeignKey(d => d.NguoiGhiNhan)
                .HasConstraintName("FK__LichSuTha__Nguoi__04E4BC85");
        });

        modelBuilder.Entity<NguoiQuanLy>(entity =>
        {
            entity.HasKey(e => e.MaQuanLy).HasName("PK__NguoiQua__2AB9EAF8E5DEB4C6");

            entity.ToTable("NguoiQuanLy");

            entity.HasIndex(e => e.Sdt, "UQ__NguoiQua__CA1930A53B3E8E9F").IsUnique();

            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.HoTen).HasMaxLength(100);
            entity.Property(e => e.NgayTao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Sdt)
                .HasMaxLength(15)
                .IsUnicode(false)
                .HasColumnName("SDT");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(50)
                .HasDefaultValue("Hoạt động");
        });

        modelBuilder.Entity<Phong>(entity =>
        {
            entity.HasKey(e => e.MaPhong).HasName("PK__Phong__20BD5E5B004FF581");

            entity.ToTable("Phong");

            entity.Property(e => e.GiaThue).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.NgayTao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.SoPhong).HasMaxLength(20);
            entity.Property(e => e.TrangThai)
                .HasMaxLength(50)
                .HasDefaultValue("Trống");

            entity.HasOne(d => d.MaCoSoNavigation).WithMany(p => p.Phongs)
                .HasForeignKey(d => d.MaCoSo)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Phong__MaCoSo__71D1E811");

            entity.HasMany(d => d.MaTienIches).WithMany(p => p.MaPhongs)
                .UsingEntity<Dictionary<string, object>>(
                    "PhongTienIch",
                    r => r.HasOne<TienIch>().WithMany()
                        .HasForeignKey("MaTienIch")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Phong_Tie__MaTie__73BA3083"),
                    l => l.HasOne<Phong>().WithMany()
                        .HasForeignKey("MaPhong")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Phong_Tie__MaPho__72C60C4A"),
                    j =>
                    {
                        j.HasKey("MaPhong", "MaTienIch").HasName("PK__Phong_Ti__94D423D5B3F0796A");
                        j.ToTable("Phong_TienIch");
                    });
        });

        modelBuilder.Entity<SuCo>(entity =>
        {
            entity.HasKey(e => e.MaSuCo).HasName("PK__SuCo__A69DF79F21AAA5D3");

            entity.ToTable("SuCo");

            entity.Property(e => e.NgayBao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.NgayXuLy).HasColumnType("datetime");
            entity.Property(e => e.TieuDe).HasMaxLength(255);
            entity.Property(e => e.TrangThai)
                .HasMaxLength(50)
                .HasDefaultValue("Chờ xử lý");

            entity.HasOne(d => d.MaKhachNavigation).WithMany(p => p.SuCos)
                .HasForeignKey(d => d.MaKhach)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SuCo__MaKhach__02FC7413");

            entity.HasOne(d => d.MaPhongNavigation).WithMany(p => p.SuCos)
                .HasForeignKey(d => d.MaPhong)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SuCo__MaPhong__02084FDA");
        });

        modelBuilder.Entity<TaiKhoan>(entity =>
        {
            entity.HasKey(e => e.MaTaiKhoan).HasName("PK__TaiKhoan__AD7C6529BF49D213");

            entity.ToTable("TaiKhoan");

            entity.HasIndex(e => e.TenDangNhap, "UQ__TaiKhoan__55F68FC0F708B9DB").IsUnique();

            entity.Property(e => e.MatKhau)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.NgayTao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.TenDangNhap)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.TrangThai)
                .HasMaxLength(50)
                .HasDefaultValue("Hoạt động");
            entity.Property(e => e.VaiTro).HasMaxLength(50);

            entity.HasOne(d => d.MaKhachNavigation).WithMany(p => p.TaiKhoans)
                .HasForeignKey(d => d.MaKhach)
                .HasConstraintName("FK__TaiKhoan__MaKhac__01142BA1");

            entity.HasOne(d => d.MaQuanLyNavigation).WithMany(p => p.TaiKhoans)
                .HasForeignKey(d => d.MaQuanLy)
                .HasConstraintName("FK__TaiKhoan__MaQuan__00200768");
        });

        modelBuilder.Entity<ThongBao>(entity =>
        {
            entity.HasKey(e => e.MaThongBao).HasName("PK__ThongBao__04DEB54E8020F12F");

            entity.ToTable("ThongBao");

            entity.Property(e => e.DaDoc).HasDefaultValue(false);
            entity.Property(e => e.NgayGui)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.TieuDe).HasMaxLength(255);

            entity.HasOne(d => d.MaKhachNavigation).WithMany(p => p.ThongBaos)
                .HasForeignKey(d => d.MaKhach)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ThongBao__MaKhac__05D8E0BE");
        });

        modelBuilder.Entity<TienIch>(entity =>
        {
            entity.HasKey(e => e.MaTienIch).HasName("PK__TienIch__4697D8EA8CE4FBBB");

            entity.ToTable("TienIch");

            entity.Property(e => e.TenTienIch).HasMaxLength(100);
        });

        modelBuilder.Entity<ViewCoSoTongQuan>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("View_CoSo_TongQuan");

            entity.Property(e => e.DiaChi).HasMaxLength(255);
            entity.Property(e => e.TenCoSo).HasMaxLength(150);
        });

        modelBuilder.Entity<ViewHoaDonUi>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("View_HoaDon_UI");

            entity.Property(e => e.PhuPhi).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.SoPhong).HasMaxLength(20);
            entity.Property(e => e.TenCoSo).HasMaxLength(150);
            entity.Property(e => e.TenKhachThu).HasMaxLength(100);
            entity.Property(e => e.TienDichVu).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TienDien).HasColumnType("decimal(29, 2)");
            entity.Property(e => e.TienNuoc).HasColumnType("decimal(29, 2)");
            entity.Property(e => e.TienPhong).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TongTien).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TrangThai).HasMaxLength(50);
        });

        modelBuilder.Entity<ViewPhongUi>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("View_Phong_UI");

            entity.Property(e => e.DiaChi).HasMaxLength(255);
            entity.Property(e => e.GiaThue).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.SoPhong).HasMaxLength(20);
            entity.Property(e => e.TenCoSo).HasMaxLength(150);
            entity.Property(e => e.TrangThai).HasMaxLength(50);
            entity.Property(e => e.TrangThaiHienThi).HasMaxLength(50);
        });

        modelBuilder.Entity<LichHenXemPhong>(entity =>
        {
            entity.HasKey(e => e.MaLichHen).HasName("PK__LichHenX__ABC12345"); // Tên khóa mặc định

            entity.ToTable("LichHenXemPhong");

            entity.Property(e => e.HoTenKhach).HasMaxLength(100);
            
            entity.Property(e => e.SdtKhach)
                .HasMaxLength(15)
                .IsUnicode(false)
                .HasColumnName("SDTKhach");

            entity.Property(e => e.ThoiGianHen).HasColumnType("datetime");
            
            entity.Property(e => e.GhiChu).HasMaxLength(255);

            entity.Property(e => e.TrangThai)
                .HasMaxLength(50)
                .HasDefaultValue("Chờ xác nhận");

            entity.Property(e => e.NgayTao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            // Khấu ngoại nối sang bảng Khách Thuê
            entity.HasOne(d => d.MaKhachNavigation).WithMany(p => p.LichHenXemPhongs)
                .HasForeignKey(d => d.MaKhach)
                .OnDelete(DeleteBehavior.SetNull) // Nếu xóa khách, giữ lại lịch hẹn dạng ẩn
                .HasConstraintName("FK__LichHenXe__MaKha__70A8B953");

            // Khóa ngoại nối sang bảng Phòng
            entity.HasOne(d => d.MaPhongNavigation).WithMany(p => p.LichHenXemPhongs)
                .HasForeignKey(d => d.MaPhong)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LichHenXe__MaPho__719CDDE2");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
