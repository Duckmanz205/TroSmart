CREATE DATABASE [QuanLyPhongTro]
GO
USE [QuanLyPhongTro]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================
-- 1. TẠO CÁC BẢNG (TABLES)
-- =========================================================

CREATE TABLE [dbo].[NguoiQuanLy](
	[MaQuanLy] [int] IDENTITY(1,1) NOT NULL,
	[HoTen] [nvarchar](100) NOT NULL,
	[SDT] [varchar](15) NULL,
	[Email] [varchar](100) NULL,
	[TrangThai] [nvarchar](50) NULL,
	[NgayTao] [datetime] NULL,
PRIMARY KEY CLUSTERED ([MaQuanLy] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CoSo](
	[MaCoSo] [int] IDENTITY(1,1) NOT NULL,
	[TenCoSo] [nvarchar](150) NOT NULL,
	[DiaChi] [nvarchar](255) NOT NULL,
	[MoTa] [nvarchar](max) NULL,
	[LoaiHinh] [nvarchar](100) NULL,
	[MaQuanLy] [int] NULL,
	[Latitude] [float] NULL,
	[Longitude] [float] NULL,
	[DanhGia] [float] NULL,
	[TrangThai] [nvarchar](50) NULL,
	[NgayTao] [datetime] NULL,
PRIMARY KEY CLUSTERED ([MaCoSo] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Phong](
	[MaPhong] [int] IDENTITY(1,1) NOT NULL,
	[MaCoSo] [int] NOT NULL,
	[SoPhong] [nvarchar](20) NOT NULL,
	[Tang] [int] NULL,
	[DienTich] [float] NULL,
	[GiaThue] [decimal](18, 2) NOT NULL,
	[SoNguoiToiDa] [int] NULL,
	[TrangThai] [nvarchar](50) NULL,
	[MoTa] [nvarchar](max) NULL,
	[NgayTao] [datetime] NULL,
PRIMARY KEY CLUSTERED ([MaPhong] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[KhachThue](
	[MaKhach] [int] IDENTITY(1,1) NOT NULL,
	[HoTen] [nvarchar](100) NULL,
	[SDT] [varchar](15) NULL,
	[CCCD] [varchar](20) NULL,
PRIMARY KEY CLUSTERED ([MaKhach] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TienIch](
	[MaTienIch] [int] IDENTITY(1,1) NOT NULL,
	[TenTienIch] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED ([MaTienIch] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CoSo_TienIch](
	[MaCoSo] [int] NOT NULL,
	[MaTienIch] [int] NOT NULL,
PRIMARY KEY CLUSTERED ([MaCoSo] ASC, [MaTienIch] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Phong_TienIch](
	[MaPhong] [int] NOT NULL,
	[MaTienIch] [int] NOT NULL,
PRIMARY KEY CLUSTERED ([MaPhong] ASC, [MaTienIch] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[HinhAnhCoSo](
	[MaAnh] [int] IDENTITY(1,1) NOT NULL,
	[MaCoSo] [int] NOT NULL,
	[UrlAnh] [nvarchar](max) NULL,
	[IsMain] [bit] NOT NULL,
PRIMARY KEY CLUSTERED ([MaAnh] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[HinhAnhPhong](
	[MaAnh] [int] IDENTITY(1,1) NOT NULL,
	[MaPhong] [int] NOT NULL,
	[UrlAnh] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED ([MaAnh] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- BẢNG MỚI: Hợp đồng thuê
CREATE TABLE [dbo].[HopDongThue](
    [MaHopDong] [int] IDENTITY(1,1) NOT NULL,
    [MaPhong] [int] NOT NULL,
    [MaKhach] [int] NOT NULL,
    [NgayBatDau] [date] NOT NULL,
    [NgayKetThuc] [date] NULL,
    [TienCoc] [decimal](18, 2) NULL,
    [TrangThai] [nvarchar](50) NULL,
    [NgayTao] [datetime] NULL,
PRIMARY KEY CLUSTERED ([MaHopDong] ASC)
) ON [PRIMARY]
GO

-- BẢNG MỚI: Hóa Đơn
CREATE TABLE [dbo].[HoaDon](
    [MaHoaDon] [int] IDENTITY(1,1) NOT NULL,
    [MaPhong] [int] NOT NULL,
    [MaKhach] [int] NULL,
    [Thang] [int] NOT NULL,
    [Nam] [int] NOT NULL,
    [TienPhong] [decimal](18, 2) NOT NULL,
    [ChiSoDienCu] [int] NOT NULL,
    [ChiSoDienMoi] [int] NOT NULL,
    [DonGiaDien] [decimal](18, 2) NOT NULL,
    [ChiSoNuocCu] [int] NOT NULL,
    [ChiSoNuocMoi] [int] NOT NULL,
    [DonGiaNuoc] [decimal](18, 2) NOT NULL,
    [TienDichVu] [decimal](18, 2) NULL,
    [MoTaDichVu] [nvarchar](255) NULL,
    [PhuPhi] [decimal](18, 2) NULL,
    [MoTaPhuPhi] [nvarchar](255) NULL,
    [TongTien] [decimal](18, 2) NOT NULL,
    [TrangThai] [nvarchar](50) NULL,
    [NgayLap] [date] NULL,
    [HanThanhToan] [date] NULL,
    [NgayThanhToan] [date] NULL,
PRIMARY KEY CLUSTERED ([MaHoaDon] ASC)
) ON [PRIMARY]
GO


-- =========================================================
-- 2. TẠO CÁC VIEWS
-- =========================================================

CREATE VIEW [dbo].[View_CoSo_TongQuan] AS
SELECT 
    cs.MaCoSo,
    cs.TenCoSo,
    cs.DiaChi,
    COUNT(p.MaPhong) AS TongPhong,
    SUM(CASE WHEN p.TrangThai = N'Trống' THEN 1 ELSE 0 END) AS PhongTrong,
    SUM(CASE WHEN p.TrangThai = N'Đang thuê' THEN 1 ELSE 0 END) AS DangThue,
    SUM(CASE WHEN p.TrangThai = N'Bảo trì' THEN 1 ELSE 0 END) AS BaoTri
FROM CoSo cs
LEFT JOIN Phong p ON cs.MaCoSo = p.MaCoSo
GROUP BY cs.MaCoSo, cs.TenCoSo, cs.DiaChi;
GO

CREATE VIEW [dbo].[View_Phong_UI] AS
SELECT 
    p.MaPhong,
    p.MaCoSo,
    cs.TenCoSo,
    cs.DiaChi,
    p.SoPhong,
    p.Tang,
    p.DienTich,
    p.GiaThue,
    p.SoNguoiToiDa,
    p.TrangThai,
    p.MoTa,
    p.TrangThai AS TrangThaiHienThi
FROM Phong p
JOIN CoSo cs ON p.MaCoSo = cs.MaCoSo;
GO

CREATE VIEW [dbo].[View_HoaDon_UI] AS
SELECT 
    hd.MaHoaDon,
    hd.Thang,
    hd.Nam,
    hd.TongTien,
    hd.TrangThai,
    hd.HanThanhToan,
    p.SoPhong,
    cs.TenCoSo,
    k.HoTen AS TenKhachThu,
    hd.TienPhong,
    (hd.ChiSoDienMoi - hd.ChiSoDienCu) * hd.DonGiaDien AS TienDien,
    (hd.ChiSoNuocMoi - hd.ChiSoNuocCu) * hd.DonGiaNuoc AS TienNuoc,
    hd.TienDichVu,
    hd.PhuPhi
FROM [dbo].[HoaDon] hd
JOIN [dbo].[Phong] p ON hd.MaPhong = p.MaPhong
JOIN [dbo].[CoSo] cs ON p.MaCoSo = cs.MaCoSo
JOIN [dbo].[KhachThue] k ON hd.MaKhach = k.MaKhach;
GO


-- =========================================================
-- 3. INSERT DỮ LIỆU (DATA MẪU)
-- =========================================================

-- Người quản lý
SET IDENTITY_INSERT [dbo].[NguoiQuanLy] ON 
INSERT [dbo].[NguoiQuanLy] ([MaQuanLy], [HoTen], [SDT], [Email], [TrangThai], [NgayTao]) VALUES (1, N'Nguyễn Văn A', N'0900000001', N'a@gmail.com', N'Hoạt động', CAST(N'2026-05-05T15:11:41.920' AS DateTime))
INSERT [dbo].[NguoiQuanLy] ([MaQuanLy], [HoTen], [SDT], [Email], [TrangThai], [NgayTao]) VALUES (2, N'Trần Văn B', N'0900000002', N'b@gmail.com', N'Hoạt động', CAST(N'2026-05-05T15:11:41.920' AS DateTime))
SET IDENTITY_INSERT [dbo].[NguoiQuanLy] OFF
GO

-- Cơ sở
SET IDENTITY_INSERT [dbo].[CoSo] ON 
INSERT [dbo].[CoSo] ([MaCoSo], [TenCoSo], [DiaChi], [MoTa], [LoaiHinh], [MaQuanLy], [Latitude], [Longitude], [DanhGia], [TrangThai], [NgayTao]) VALUES (1, N'KTX Sinh Viên A', N'Quận 1', N'quy tac', N'KTX', 1, 10.759842459095909, 106.69904139371432, 4.5, N'Hoạt động', CAST(N'2026-05-05T15:11:41.920' AS DateTime))
INSERT [dbo].[CoSo] ([MaCoSo], [TenCoSo], [DiaChi], [MoTa], [LoaiHinh], [MaQuanLy], [Latitude], [Longitude], [DanhGia], [TrangThai], [NgayTao]) VALUES (2, N'Nhà trọ Trung Tâm B', N'Quận 3', N'', N'Nhà trọ', 1, 10.7868, 106.6822, 4.2, N'Hoạt động', CAST(N'2026-05-05T15:11:41.920' AS DateTime))
INSERT [dbo].[CoSo] ([MaCoSo], [TenCoSo], [DiaChi], [MoTa], [LoaiHinh], [MaQuanLy], [Latitude], [Longitude], [DanhGia], [TrangThai], [NgayTao]) VALUES (3, N'Chung cư mini C', N'Thủ Đức', NULL, N'Chung cư', 2, 10.8506, 106.7719, 4.7, N'Hoạt động', CAST(N'2026-05-05T15:11:41.920' AS DateTime))
INSERT [dbo].[CoSo] ([MaCoSo], [TenCoSo], [DiaChi], [MoTa], [LoaiHinh], [MaQuanLy], [Latitude], [Longitude], [DanhGia], [TrangThai], [NgayTao]) VALUES (5, N't1', N'111', NULL, N'Nhà trọ', NULL, 10.775654529488586, 106.70153376752974, 0, N'Hoạt động', CAST(N'2026-05-07T14:10:36.947' AS DateTime))
SET IDENTITY_INSERT [dbo].[CoSo] OFF
GO

-- Tiện ích
SET IDENTITY_INSERT [dbo].[TienIch] ON 
INSERT [dbo].[TienIch] ([MaTienIch], [TenTienIch]) VALUES (1, N'Wifi'), (2, N'Máy lạnh'), (3, N'Chỗ để xe'), (4, N'Camera'), (5, N'Giặt đồ'), (6, N'Bếp'), (7, N'Tủ lạnh'), (8, N'Ban công'), (9, N'Nội thất'), (10, N'Bảo vệ'), (11, N'Gym')
SET IDENTITY_INSERT [dbo].[TienIch] OFF
GO

-- Cơ sở_Tiện Ích
INSERT [dbo].[CoSo_TienIch] ([MaCoSo], [MaTienIch]) VALUES (1, 1), (1, 3), (1, 4), (1, 5), (1, 10), (2, 1), (2, 3), (2, 4), (3, 1), (3, 2), (3, 3), (3, 4), (3, 7), (3, 9), (3, 10), (5, 2), (5, 11)
GO

-- Khách Thuê (Dữ liệu mới)
SET IDENTITY_INSERT [dbo].[KhachThue] ON 
INSERT [dbo].[KhachThue] ([MaKhach], [HoTen], [SDT], [CCCD]) VALUES (1, N'Nguyễn Văn An', '0901234567', '079099001122')
INSERT [dbo].[KhachThue] ([MaKhach], [HoTen], [SDT], [CCCD]) VALUES (2, N'Trần Thị Bích', '0912345678', '079099001133')
INSERT [dbo].[KhachThue] ([MaKhach], [HoTen], [SDT], [CCCD]) VALUES (3, N'Lê Minh Tuấn', '0923456789', '079099001144')
SET IDENTITY_INSERT [dbo].[KhachThue] OFF
GO

-- Phòng
SET IDENTITY_INSERT [dbo].[Phong] ON 
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (1, 1, N'A101', 1, 20, CAST(2000000.00 AS Decimal(18, 2)), 2, N'Trống', N'oki', CAST(N'2026-05-05T15:11:41.920' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (2, 1, N'A102', 1, 22, CAST(2200000.00 AS Decimal(18, 2)), 2, N'Đang thuê', NULL, CAST(N'2026-05-05T15:11:41.920' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (3, 1, N'A103', 1, 25, CAST(2500000.00 AS Decimal(18, 2)), 3, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.920' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (4, 1, N'A104', 2, 30, CAST(3000000.00 AS Decimal(18, 2)), 4, N'Bảo trì', NULL, CAST(N'2026-05-05T15:11:41.920' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (5, 1, N'A105', 2, 28, CAST(2800000.00 AS Decimal(18, 2)), 3, N'Đang thuê', NULL, CAST(N'2026-05-05T15:11:41.920' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (6, 1, N'A106', 2, 18, CAST(1800000.00 AS Decimal(18, 2)), 2, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.920' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (7, 1, N'A107', 3, 35, CAST(3500000.00 AS Decimal(18, 2)), 4, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.920' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (8, 1, N'A108', 3, 40, CAST(4000000.00 AS Decimal(18, 2)), 5, N'Đang thuê', NULL, CAST(N'2026-05-05T15:11:41.920' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (9, 1, N'A109', 3, 22, CAST(2200000.00 AS Decimal(18, 2)), 2, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.920' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (10, 1, N'A110', 4, 45, CAST(4500000.00 AS Decimal(18, 2)), 5, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.920' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (11, 2, N'B101', 1, 18, CAST(1800000.00 AS Decimal(18, 2)), 2, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (12, 2, N'B102', 1, 20, CAST(2000000.00 AS Decimal(18, 2)), 2, N'Đang thuê', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (13, 2, N'B103', 2, 22, CAST(2200000.00 AS Decimal(18, 2)), 2, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (14, 2, N'B104', 2, 25, CAST(2500000.00 AS Decimal(18, 2)), 3, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (15, 2, N'B105', 2, 27, CAST(2700000.00 AS Decimal(18, 2)), 3, N'Đang thuê', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (16, 2, N'B106', 3, 30, CAST(3000000.00 AS Decimal(18, 2)), 4, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (17, 2, N'B107', 3, 32, CAST(3200000.00 AS Decimal(18, 2)), 4, N'Bảo trì', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (18, 2, N'B108', 3, 35, CAST(3500000.00 AS Decimal(18, 2)), 4, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (19, 3, N'C101', 1, 20, CAST(2100000.00 AS Decimal(18, 2)), 2, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (20, 3, N'C102', 1, 22, CAST(2300000.00 AS Decimal(18, 2)), 2, N'Đang thuê', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (21, 3, N'C103', 2, 25, CAST(2600000.00 AS Decimal(18, 2)), 3, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (22, 3, N'C104', 2, 28, CAST(2900000.00 AS Decimal(18, 2)), 3, N'Đang thuê', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (23, 3, N'C105', 2, 30, CAST(3100000.00 AS Decimal(18, 2)), 4, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (24, 3, N'C106', 3, 35, CAST(3600000.00 AS Decimal(18, 2)), 4, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (25, 3, N'C107', 3, 38, CAST(3800000.00 AS Decimal(18, 2)), 4, N'Bảo trì', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
INSERT [dbo].[Phong] ([MaPhong], [MaCoSo], [SoPhong], [Tang], [DienTich], [GiaThue], [SoNguoiToiDa], [TrangThai], [MoTa], [NgayTao]) VALUES (26, 3, N'C108', 3, 40, CAST(4000000.00 AS Decimal(18, 2)), 5, N'Trống', NULL, CAST(N'2026-05-05T15:11:41.923' AS DateTime))
SET IDENTITY_INSERT [dbo].[Phong] OFF
GO

-- Phong_TienIch
INSERT [dbo].[Phong_TienIch] ([MaPhong], [MaTienIch]) VALUES (1, 1), (1, 2), (1, 8), (1, 9), (2, 1), (3, 2), (4, 3), (5, 4), (6, 5), (7, 6), (8, 7), (9, 8), (10, 9)
GO

-- Hình Ảnh Cơ Sở
SET IDENTITY_INSERT [dbo].[HinhAnhCoSo] ON 
INSERT [dbo].[HinhAnhCoSo] ([MaAnh], [MaCoSo], [UrlAnh], [IsMain]) VALUES (1, 1, N'assets/images/co_so/co_so_1.jpg', 0)
INSERT [dbo].[HinhAnhCoSo] ([MaAnh], [MaCoSo], [UrlAnh], [IsMain]) VALUES (2, 1, N'assets/images/co_so/co_so_1_2.jpg', 0)
INSERT [dbo].[HinhAnhCoSo] ([MaAnh], [MaCoSo], [UrlAnh], [IsMain]) VALUES (3, 2, N'assets/images/co_so/co_so_2.jpg', 0)
INSERT [dbo].[HinhAnhCoSo] ([MaAnh], [MaCoSo], [UrlAnh], [IsMain]) VALUES (4, 2, N'assets/images/co_so/co_so_2_2.jpg', 0)
INSERT [dbo].[HinhAnhCoSo] ([MaAnh], [MaCoSo], [UrlAnh], [IsMain]) VALUES (5, 3, N'assets/images/co_so/co_so_3.jpg', 1)
INSERT [dbo].[HinhAnhCoSo] ([MaAnh], [MaCoSo], [UrlAnh], [IsMain]) VALUES (6, 3, N'assets/images/co_so/co_so_3_2.jpg', 0)
INSERT [dbo].[HinhAnhCoSo] ([MaAnh], [MaCoSo], [UrlAnh], [IsMain]) VALUES (7, 2, N'http://localhost:5137/uploads/co_so/aa886217b8bd47fa9aed71ed772bc24e.jpg', 0)
INSERT [dbo].[HinhAnhCoSo] ([MaAnh], [MaCoSo], [UrlAnh], [IsMain]) VALUES (8, 2, N'http://localhost:5137/uploads/co_so/d78ec6aba78b455dbafa1a5fa292c004.jpg', 0)
INSERT [dbo].[HinhAnhCoSo] ([MaAnh], [MaCoSo], [UrlAnh], [IsMain]) VALUES (9, 2, N'http://localhost:5137/uploads/co_so/e35e1dfd2cf9408eb7ea0527a2ebf037.jpg', 1)
INSERT [dbo].[HinhAnhCoSo] ([MaAnh], [MaCoSo], [UrlAnh], [IsMain]) VALUES (11, 5, N'http://localhost:5137/uploads/co_so/cbb6293dfa3f4acd974cbeff04c8bc3c.jpg', 1)
INSERT [dbo].[HinhAnhCoSo] ([MaAnh], [MaCoSo], [UrlAnh], [IsMain]) VALUES (12, 1, N'http://localhost:5137/uploads/co_so/f99e54465dae432aa258153d0d288143.jpg', 1)
SET IDENTITY_INSERT [dbo].[HinhAnhCoSo] OFF
GO

-- Hình Ảnh Phòng
SET IDENTITY_INSERT [dbo].[HinhAnhPhong] ON 
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (2, 2, N'assets/images/phong/a102.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (3, 3, N'assets/images/phong/a103.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (4, 4, N'assets/images/phong/a104.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (5, 5, N'assets/images/phong/a105.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (6, 6, N'assets/images/phong/a106.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (7, 7, N'assets/images/phong/a107.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (8, 8, N'assets/images/phong/a108.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (9, 9, N'assets/images/phong/a109.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (11, 11, N'assets/images/phong/b101.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (12, 12, N'assets/images/phong/b102.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (13, 13, N'assets/images/phong/b103.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (14, 14, N'assets/images/phong/b104.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (15, 15, N'assets/images/phong/b105.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (16, 16, N'assets/images/phong/b106.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (17, 17, N'assets/images/phong/b107.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (18, 18, N'assets/images/phong/b108.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (19, 19, N'assets/images/phong/c101.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (20, 20, N'assets/images/phong/c102.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (21, 21, N'assets/images/phong/c103.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (22, 22, N'assets/images/phong/c104.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (23, 23, N'assets/images/phong/c105.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (24, 24, N'assets/images/phong/c106.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (25, 25, N'assets/images/phong/c107.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (26, 26, N'assets/images/phong/c108.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (30, 1, N'http://localhost:5137/uploads/phong/scaled_co_so_2_2_1_e38412914930425289b3ebe2ee5902e8.jpg')
INSERT [dbo].[HinhAnhPhong] ([MaAnh], [MaPhong], [UrlAnh]) VALUES (31, 10, N'http://localhost:5137/uploads/phong/scaled_co_so_2_2_1_07ebe15911cf411dabcd96a1407a53e9.jpg')
SET IDENTITY_INSERT [dbo].[HinhAnhPhong] OFF
GO


-- Hợp Đồng Thuê (Dữ liệu mới)
SET IDENTITY_INSERT [dbo].[HopDongThue] ON 
INSERT [dbo].[HopDongThue] ([MaHopDong], [MaPhong], [MaKhach], [NgayBatDau], [TienCoc], [TrangThai], [NgayTao]) VALUES (1, 2, 1, CAST(N'2023-01-01' AS Date), CAST(2200000.00 AS Decimal(18, 2)), N'Đang hiệu lực', GETDATE())
INSERT [dbo].[HopDongThue] ([MaHopDong], [MaPhong], [MaKhach], [NgayBatDau], [TienCoc], [TrangThai], [NgayTao]) VALUES (2, 12, 2, CAST(N'2023-05-15' AS Date), CAST(2000000.00 AS Decimal(18, 2)), N'Đang hiệu lực', GETDATE())
INSERT [dbo].[HopDongThue] ([MaHopDong], [MaPhong], [MaKhach], [NgayBatDau], [TienCoc], [TrangThai], [NgayTao]) VALUES (3, 24, 3, CAST(N'2024-02-10' AS Date), CAST(2900000.00 AS Decimal(18, 2)), N'Đang hiệu lực', GETDATE())
SET IDENTITY_INSERT [dbo].[HopDongThue] OFF
GO

-- Hóa Đơn (Dữ liệu mới)
SET IDENTITY_INSERT [dbo].[HoaDon] ON 
INSERT [dbo].[HoaDon] ([MaHoaDon], [MaPhong], [MaKhach], [Thang], [Nam], [TienPhong], [ChiSoDienCu], [ChiSoDienMoi], [DonGiaDien], [ChiSoNuocCu], [ChiSoNuocMoi], [DonGiaNuoc], [TienDichVu], [MoTaDichVu], [PhuPhi], [MoTaPhuPhi], [TongTien], [TrangThai], [NgayLap], [HanThanhToan], [NgayThanhToan])
VALUES (1, 2, 1, 10, 2024, CAST(2200000.00 AS Decimal(18,2)), 1250, 1342, CAST(3500.00 AS Decimal(18,2)), 430, 438, CAST(20000.00 AS Decimal(18,2)), CAST(100000.00 AS Decimal(18,2)), N'Wifi: 100.000đ', CAST(0.00 AS Decimal(18,2)), NULL, CAST(2782000.00 AS Decimal(18,2)), N'Đã thanh toán', GETDATE(), CAST(N'2024-10-05' AS Date), CAST(N'2024-10-04' AS Date))

INSERT [dbo].[HoaDon] ([MaHoaDon], [MaPhong], [MaKhach], [Thang], [Nam], [TienPhong], [ChiSoDienCu], [ChiSoDienMoi], [DonGiaDien], [ChiSoNuocCu], [ChiSoNuocMoi], [DonGiaNuoc], [TienDichVu], [MoTaDichVu], [PhuPhi], [MoTaPhuPhi], [TongTien], [TrangThai], [NgayLap], [HanThanhToan], [NgayThanhToan])
VALUES (2, 12, 2, 10, 2024, CAST(2000000.00 AS Decimal(18,2)), 2100, 2185, CAST(3500.00 AS Decimal(18,2)), 150, 156, CAST(20000.00 AS Decimal(18,2)), CAST(150000.00 AS Decimal(18,2)), N'Wifi: 100k, Rác: 50k', CAST(50000.00 AS Decimal(18,2)), N'Phạt vứt rác sai quy định', CAST(2617500.00 AS Decimal(18,2)), N'Chưa thanh toán', GETDATE(), CAST(N'2024-10-05' AS Date), NULL)

INSERT [dbo].[HoaDon] ([MaHoaDon], [MaPhong], [MaKhach], [Thang], [Nam], [TienPhong], [ChiSoDienCu], [ChiSoDienMoi], [DonGiaDien], [ChiSoNuocCu], [ChiSoNuocMoi], [DonGiaNuoc], [TienDichVu], [MoTaDichVu], [PhuPhi], [MoTaPhuPhi], [TongTien], [TrangThai], [NgayLap], [HanThanhToan], [NgayThanhToan])
VALUES (3, 24, 3, 9, 2024, CAST(2900000.00 AS Decimal(18,2)), 300, 450, CAST(3500.00 AS Decimal(18,2)), 80, 92, CAST(20000.00 AS Decimal(18,2)), CAST(100000.00 AS Decimal(18,2)), N'Wifi', CAST(0.00 AS Decimal(18,2)), NULL, CAST(3765000.00 AS Decimal(18,2)), N'Quá hạn', GETDATE(), CAST(N'2024-09-05' AS Date), NULL)
SET IDENTITY_INSERT [dbo].[HoaDon] OFF
GO

-- =========================================================
-- 4. TẠO CONSTRAINTS, MẶC ĐỊNH VÀ FOREIGN KEYS
-- =========================================================

ALTER TABLE [dbo].[NguoiQuanLy] ADD UNIQUE NONCLUSTERED ([SDT] ASC)
GO
ALTER TABLE [dbo].[CoSo] ADD  DEFAULT ((0)) FOR [DanhGia]
GO
ALTER TABLE [dbo].[CoSo] ADD  DEFAULT (N'Hoạt động') FOR [TrangThai]
GO
ALTER TABLE [dbo].[CoSo] ADD  DEFAULT (getdate()) FOR [NgayTao]
GO
ALTER TABLE [dbo].[HinhAnhCoSo] ADD  CONSTRAINT [DF_HinhAnhCoSo_IsMain]  DEFAULT ((0)) FOR [IsMain]
GO
ALTER TABLE [dbo].[NguoiQuanLy] ADD  DEFAULT (N'Hoạt động') FOR [TrangThai]
GO
ALTER TABLE [dbo].[NguoiQuanLy] ADD  DEFAULT (getdate()) FOR [NgayTao]
GO
ALTER TABLE [dbo].[Phong] ADD  DEFAULT (N'Trống') FOR [TrangThai]
GO
ALTER TABLE [dbo].[Phong] ADD  DEFAULT (getdate()) FOR [NgayTao]
GO

-- Defaults MỚI cho Hợp Đồng Thuê
ALTER TABLE [dbo].[HopDongThue] ADD DEFAULT ((0)) FOR [TienCoc]
GO
ALTER TABLE [dbo].[HopDongThue] ADD DEFAULT (N'Đang hiệu lực') FOR [TrangThai]
GO
ALTER TABLE [dbo].[HopDongThue] ADD DEFAULT (getdate()) FOR [NgayTao]
GO

-- Defaults MỚI cho Hóa Đơn
ALTER TABLE [dbo].[HoaDon] ADD DEFAULT ((0)) FOR [TienDichVu]
GO
ALTER TABLE [dbo].[HoaDon] ADD DEFAULT ((0)) FOR [PhuPhi]
GO
ALTER TABLE [dbo].[HoaDon] ADD DEFAULT (N'Chưa thanh toán') FOR [TrangThai]
GO
ALTER TABLE [dbo].[HoaDon] ADD DEFAULT (getdate()) FOR [NgayLap]
GO

-- KHÓA NGOẠI (Foreign Keys)
ALTER TABLE [dbo].[CoSo]  WITH CHECK ADD FOREIGN KEY([MaQuanLy]) REFERENCES [dbo].[NguoiQuanLy] ([MaQuanLy])
GO
ALTER TABLE [dbo].[CoSo_TienIch]  WITH CHECK ADD FOREIGN KEY([MaCoSo]) REFERENCES [dbo].[CoSo] ([MaCoSo])
GO
ALTER TABLE [dbo].[CoSo_TienIch]  WITH CHECK ADD FOREIGN KEY([MaTienIch]) REFERENCES [dbo].[TienIch] ([MaTienIch])
GO
ALTER TABLE [dbo].[HinhAnhCoSo]  WITH CHECK ADD FOREIGN KEY([MaCoSo]) REFERENCES [dbo].[CoSo] ([MaCoSo])
GO
ALTER TABLE [dbo].[HinhAnhPhong]  WITH CHECK ADD FOREIGN KEY([MaPhong]) REFERENCES [dbo].[Phong] ([MaPhong])
GO
ALTER TABLE [dbo].[Phong]  WITH CHECK ADD FOREIGN KEY([MaCoSo]) REFERENCES [dbo].[CoSo] ([MaCoSo])
GO
ALTER TABLE [dbo].[Phong_TienIch]  WITH CHECK ADD FOREIGN KEY([MaPhong]) REFERENCES [dbo].[Phong] ([MaPhong])
GO
ALTER TABLE [dbo].[Phong_TienIch]  WITH CHECK ADD FOREIGN KEY([MaTienIch]) REFERENCES [dbo].[TienIch] ([MaTienIch])
GO
ALTER TABLE [dbo].[Phong]  WITH CHECK ADD  CONSTRAINT [CK_TrangThai] CHECK  (([TrangThai]=N'Bảo trì' OR [TrangThai]=N'Đang thuê' OR [TrangThai]=N'Trống'))
GO
ALTER TABLE [dbo].[Phong] CHECK CONSTRAINT [CK_TrangThai]
GO

-- KHÓA NGOẠI MỚI 
ALTER TABLE [dbo].[HopDongThue] WITH CHECK ADD FOREIGN KEY([MaPhong]) REFERENCES [dbo].[Phong] ([MaPhong])
GO
ALTER TABLE [dbo].[HopDongThue] WITH CHECK ADD FOREIGN KEY([MaKhach]) REFERENCES [dbo].[KhachThue] ([MaKhach])
GO
ALTER TABLE [dbo].[HoaDon] WITH CHECK ADD FOREIGN KEY([MaPhong]) REFERENCES [dbo].[Phong] ([MaPhong])
GO
ALTER TABLE [dbo].[HoaDon] WITH CHECK ADD FOREIGN KEY([MaKhach]) REFERENCES [dbo].[KhachThue] ([MaKhach])
GO