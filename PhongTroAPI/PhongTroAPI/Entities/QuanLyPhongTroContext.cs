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

    public virtual DbSet<CoSo> CoSos { get; set; }

    public virtual DbSet<HinhAnhCoSo> HinhAnhCoSos { get; set; }

    public virtual DbSet<HinhAnhPhong> HinhAnhPhongs { get; set; }

    public virtual DbSet<HoaDon> HoaDons { get; set; }

    public virtual DbSet<HopDongThue> HopDongThues { get; set; }

    public virtual DbSet<KhachThue> KhachThues { get; set; }

    public virtual DbSet<NguoiQuanLy> NguoiQuanLies { get; set; }

    public virtual DbSet<Phong> Phongs { get; set; }

    public virtual DbSet<TienIch> TienIches { get; set; }

    public virtual DbSet<ViewCoSoTongQuan> ViewCoSoTongQuans { get; set; }

    public virtual DbSet<ViewHoaDonUi> ViewHoaDonUis { get; set; }

    public virtual DbSet<ViewPhongUi> ViewPhongUis { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseSqlServer("Server=.;Database=QuanLyPhongTro;Integrated Security=True;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<CoSo>(entity =>
        {
            entity.HasKey(e => e.MaCoSo).HasName("PK__CoSo__152D0634430CCDF6");

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
                .HasConstraintName("FK__CoSo__MaQuanLy__5CD6CB2B");

            entity.HasMany(d => d.MaTienIches).WithMany(p => p.MaCoSos)
                .UsingEntity<Dictionary<string, object>>(
                    "CoSoTienIch",
                    r => r.HasOne<TienIch>().WithMany()
                        .HasForeignKey("MaTienIch")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__CoSo_Tien__MaTie__5EBF139D"),
                    l => l.HasOne<CoSo>().WithMany()
                        .HasForeignKey("MaCoSo")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__CoSo_Tien__MaCoS__5DCAEF64"),
                    j =>
                    {
                        j.HasKey("MaCoSo", "MaTienIch").HasName("PK__CoSo_Tie__A1447BBA3CAA2175");
                        j.ToTable("CoSo_TienIch");
                    });
        });

        modelBuilder.Entity<HinhAnhCoSo>(entity =>
        {
            entity.HasKey(e => e.MaAnh).HasName("PK__HinhAnhC__356240DF32B57065");

            entity.ToTable("HinhAnhCoSo");

            entity.HasOne(d => d.MaCoSoNavigation).WithMany(p => p.HinhAnhCoSos)
                .HasForeignKey(d => d.MaCoSo)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HinhAnhCo__MaCoS__5FB337D6");
        });

        modelBuilder.Entity<HinhAnhPhong>(entity =>
        {
            entity.HasKey(e => e.MaAnh).HasName("PK__HinhAnhP__356240DFDF0076F3");

            entity.ToTable("HinhAnhPhong");

            entity.HasOne(d => d.MaPhongNavigation).WithMany(p => p.HinhAnhPhongs)
                .HasForeignKey(d => d.MaPhong)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HinhAnhPh__MaPho__60A75C0F");
        });

        modelBuilder.Entity<HoaDon>(entity =>
        {
            entity.HasKey(e => e.MaHoaDon).HasName("PK__HoaDon__835ED13B30113C0F");

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
                .HasConstraintName("FK__HoaDon__MaKhach__68487DD7");

            entity.HasOne(d => d.MaPhongNavigation).WithMany(p => p.HoaDons)
                .HasForeignKey(d => d.MaPhong)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HoaDon__MaPhong__6754599E");
        });

        modelBuilder.Entity<HopDongThue>(entity =>
        {
            entity.HasKey(e => e.MaHopDong).HasName("PK__HopDongT__36DD4342EB12F812");

            entity.ToTable("HopDongThue");

            entity.Property(e => e.NgayTao)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.TienCoc)
                .HasDefaultValue(0m)
                .HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TrangThai)
                .HasMaxLength(50)
                .HasDefaultValue("Đang hiệu lực");

            entity.HasOne(d => d.MaKhachNavigation).WithMany(p => p.HopDongThues)
                .HasForeignKey(d => d.MaKhach)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HopDongTh__MaKha__66603565");

            entity.HasOne(d => d.MaPhongNavigation).WithMany(p => p.HopDongThues)
                .HasForeignKey(d => d.MaPhong)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__HopDongTh__MaPho__656C112C");
        });

        modelBuilder.Entity<KhachThue>(entity =>
        {
            entity.HasKey(e => e.MaKhach).HasName("PK__KhachThu__D0CB8DDDBD6E1744");

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

        modelBuilder.Entity<NguoiQuanLy>(entity =>
        {
            entity.HasKey(e => e.MaQuanLy).HasName("PK__NguoiQua__2AB9EAF86B7D9B16");

            entity.ToTable("NguoiQuanLy");

            entity.HasIndex(e => e.Sdt, "UQ__NguoiQua__CA1930A52180BE71").IsUnique();

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
            entity.HasKey(e => e.MaPhong).HasName("PK__Phong__20BD5E5B02E7A699");

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
                .HasConstraintName("FK__Phong__MaCoSo__619B8048");

            entity.HasMany(d => d.MaTienIches).WithMany(p => p.MaPhongs)
                .UsingEntity<Dictionary<string, object>>(
                    "PhongTienIch",
                    r => r.HasOne<TienIch>().WithMany()
                        .HasForeignKey("MaTienIch")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Phong_Tie__MaTie__6383C8BA"),
                    l => l.HasOne<Phong>().WithMany()
                        .HasForeignKey("MaPhong")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__Phong_Tie__MaPho__628FA481"),
                    j =>
                    {
                        j.HasKey("MaPhong", "MaTienIch").HasName("PK__Phong_Ti__94D423D53470DBC5");
                        j.ToTable("Phong_TienIch");
                    });
        });

        modelBuilder.Entity<TienIch>(entity =>
        {
            entity.HasKey(e => e.MaTienIch).HasName("PK__TienIch__4697D8EA907A9963");

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

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
