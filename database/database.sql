/* HaUI - CSDL hệ thống đăng ký học phần
   SQL Server (T-SQL). Dữ liệu minh họa, không phải CSDL chính thức của HaUI. */
IF DB_ID(N'HaUIDangKyHocPhan') IS NULL CREATE DATABASE HaUIDangKyHocPhan;
GO
USE HaUIDangKyHocPhan;
GO
CREATE TABLE TAI_KHOAN(
 id INT IDENTITY(1,1) PRIMARY KEY,
 ten_dang_nhap NVARCHAR(50) NOT NULL UNIQUE,
 mat_khau_hash NVARCHAR(255) NOT NULL,
 vai_tro NVARCHAR(20) NOT NULL CHECK(vai_tro IN (N'SINH_VIEN',N'CAN_BO_DAO_TAO',N'QUAN_TRI_VIEN')),
 trang_thai NVARCHAR(20) NOT NULL DEFAULT N'HOAT_DONG' CHECK(trang_thai IN (N'HOAT_DONG',N'BI_KHOA',N'NGUNG_HOAT_DONG')),
 ngay_tao DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
CREATE TABLE SINH_VIEN(
 ma_sv NVARCHAR(20) PRIMARY KEY,
 ho_ten NVARCHAR(120) NOT NULL,
 lop NVARCHAR(50) NULL,
 khoa NVARCHAR(100) NULL,
 tai_khoan_id INT NULL UNIQUE,
 CONSTRAINT FK_SINHVIEN_TAIKHOAN FOREIGN KEY(tai_khoan_id) REFERENCES TAI_KHOAN(id)
);
CREATE TABLE GIANG_VIEN(
 ma_gv NVARCHAR(20) PRIMARY KEY,
 ho_ten NVARCHAR(120) NOT NULL,
 bo_mon NVARCHAR(100) NULL
);
CREATE TABLE HOC_KY(
 id INT IDENTITY(1,1) PRIMARY KEY,
 ten_hoc_ky NVARCHAR(50) NOT NULL,
 nam_hoc NVARCHAR(20) NOT NULL,
 trang_thai NVARCHAR(20) NOT NULL DEFAULT N'DANG_HOC',
 UNIQUE(ten_hoc_ky,nam_hoc)
);
CREATE TABLE HOC_PHAN(
 ma_hp NVARCHAR(20) PRIMARY KEY,
 ten_hp NVARCHAR(150) NOT NULL,
 tc_ly_thuyet TINYINT NOT NULL DEFAULT 0 CHECK(tc_ly_thuyet BETWEEN 0 AND 20),
 tc_thuc_hanh TINYINT NOT NULL DEFAULT 0 CHECK(tc_thuc_hanh BETWEEN 0 AND 20),
 mo_ta NVARCHAR(1000) NULL,
 trang_thai NVARCHAR(20) NOT NULL DEFAULT N'DANG_HOAT_DONG'
 CHECK(trang_thai IN (N'DANG_HOAT_DONG',N'NGUNG_HOAT_DONG')),
 CONSTRAINT CK_HOCPHAN_TINCHI CHECK(tc_ly_thuyet+tc_thuc_hanh>0)
);
CREATE TABLE LOP_HOC_PHAN(
 ma_lop NVARCHAR(30) PRIMARY KEY,
 ma_hp NVARCHAR(20) NOT NULL,
 ma_gv NVARCHAR(20) NULL,
 hoc_ky_id INT NOT NULL,
 si_so_toi_da INT NOT NULL CHECK(si_so_toi_da>0),
 trang_thai NVARCHAR(20) NOT NULL DEFAULT N'DANG_MO'
 CHECK(trang_thai IN (N'DANG_MO',N'DA_DU',N'DA_DONG',N'NGUNG_HOAT_DONG')),
 CONSTRAINT FK_LOPHP_HOCPHAN FOREIGN KEY(ma_hp) REFERENCES HOC_PHAN(ma_hp),
 CONSTRAINT FK_LOPHP_GIANGVIEN FOREIGN KEY(ma_gv) REFERENCES GIANG_VIEN(ma_gv),
 CONSTRAINT FK_LOPHP_HOCKY FOREIGN KEY(hoc_ky_id) REFERENCES HOC_KY(id)
);
CREATE TABLE LICH_HOC(
 id INT IDENTITY(1,1) PRIMARY KEY,
 ma_lop NVARCHAR(30) NOT NULL,
 thu TINYINT NOT NULL CHECK(thu BETWEEN 2 AND 8),
 tiet_bat_dau TINYINT NOT NULL CHECK(tiet_bat_dau BETWEEN 1 AND 12),
 so_tiet TINYINT NOT NULL CHECK(so_tiet BETWEEN 1 AND 12),
 phong NVARCHAR(50) NULL,
 ngay_bat_dau DATE NULL,
 ngay_ket_thuc DATE NULL,
 CONSTRAINT FK_LICHHOC_LOP FOREIGN KEY(ma_lop) REFERENCES LOP_HOC_PHAN(ma_lop)
);
CREATE TABLE DOT_DANG_KY(
 id INT IDENTITY(1,1) PRIMARY KEY,
 hoc_ky_id INT NOT NULL,
 ten_dot NVARCHAR(100) NOT NULL,
 bat_dau DATETIME2 NOT NULL,
 ket_thuc DATETIME2 NOT NULL,
 trang_thai NVARCHAR(20) NOT NULL DEFAULT N'CHUA_MO'
 CHECK(trang_thai IN (N'CHUA_MO',N'DANG_MO',N'DA_DONG')),
 CONSTRAINT FK_DOT_HOCKY FOREIGN KEY(hoc_ky_id) REFERENCES HOC_KY(id),
 CONSTRAINT CK_DOT_THOIGIAN CHECK(ket_thuc>bat_dau)
);
CREATE TABLE DANG_KY(
 id BIGINT IDENTITY(1,1) PRIMARY KEY,
 ma_sv NVARCHAR(20) NOT NULL,
 ma_lop NVARCHAR(30) NOT NULL,
 thoi_gian DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
 trang_thai NVARCHAR(20) NOT NULL DEFAULT N'DANG_HIEU_LUC'
 CHECK(trang_thai IN (N'DANG_HIEU_LUC',N'DA_HUY')),
 thoi_gian_huy DATETIME2 NULL,
 CONSTRAINT FK_DANGKY_SV FOREIGN KEY(ma_sv) REFERENCES SINH_VIEN(ma_sv),
 CONSTRAINT FK_DANGKY_LOP FOREIGN KEY(ma_lop) REFERENCES LOP_HOC_PHAN(ma_lop)
);
CREATE UNIQUE INDEX UX_DANGKY_SV_LOP_HIEULUC
ON DANG_KY(ma_sv,ma_lop) WHERE trang_thai=N'DANG_HIEU_LUC';
CREATE TABLE TIEN_QUYET(
 ma_hp NVARCHAR(20) NOT NULL,
 ma_hp_tien_quyet NVARCHAR(20) NOT NULL,
 PRIMARY KEY(ma_hp,ma_hp_tien_quyet),
 FOREIGN KEY(ma_hp) REFERENCES HOC_PHAN(ma_hp),
 FOREIGN KEY(ma_hp_tien_quyet) REFERENCES HOC_PHAN(ma_hp),
 CHECK(ma_hp<>ma_hp_tien_quyet)
);
GO
/* Dữ liệu mẫu để thử giao diện quản lý học phần */
INSERT INTO HOC_KY(ten_hoc_ky,nam_hoc,trang_thai)
VALUES(N'Học kỳ 1',N'2026-2027',N'DANG_HOC');
INSERT INTO HOC_PHAN(ma_hp,ten_hp,tc_ly_thuyet,tc_thuc_hanh,mo_ta,trang_thai) VALUES
(N'IT6040',N'Phân tích và thiết kế hệ thống',3,1,N'Phương pháp phân tích yêu cầu, UML và thiết kế hệ thống thông tin.',N'DANG_HOAT_DONG'),
(N'IT6021',N'Lập trình hướng đối tượng',3,1,N'Lớp, kế thừa, đa hình và xử lý ngoại lệ.',N'DANG_HOAT_DONG'),
(N'IT6034',N'Cơ sở dữ liệu',3,1,N'Mô hình dữ liệu quan hệ, SQL và chuẩn hóa dữ liệu.',N'DANG_HOAT_DONG'),
(N'IT6018',N'Cấu trúc dữ liệu và giải thuật',3,1,N'Cấu trúc dữ liệu và thiết kế giải thuật.',N'DANG_HOAT_DONG'),
(N'IT6050',N'Phát triển ứng dụng Web',2,2,N'Xây dựng giao diện web và xử lý tương tác.',N'DANG_HOAT_DONG');
GO


/* Bổ sung thêm dữ liệu mẫu đầy đủ cho Giảng viên, Lớp học phần, Tài khoản, Sinh viên */
INSERT INTO HOC_PHAN(ma_hp,ten_hp,tc_ly_thuyet,tc_thuc_hanh,mo_ta,trang_thai) VALUES
(N'IT6062',N'Mạng máy tính',3,0,N'Mô hình mạng, giao thức truyền thông và kiến trúc mạng máy tính.',N'DANG_HOAT_DONG'),
(N'IT6071',N'Trí tuệ nhân tạo',3,0,N'Tổng quan về tìm kiếm, biểu diễn tri thức và các phương pháp AI.',N'DANG_HOAT_DONG'),
(N'IT6080',N'Kiểm thử phần mềm',2,1,N'Quy trình, kỹ thuật và công cụ kiểm thử phần mềm.',N'NGUNG_HOAT_DONG');
GO

INSERT INTO GIANG_VIEN(ma_gv, ho_ten, bo_mon) VALUES
(N'GV001', N'ThS. Nguyễn Minh Anh', N'Hệ thống thông tin'),
(N'GV002', N'TS. Trần Quốc Việt', N'Hệ thống thông tin'),
(N'GV003', N'ThS. Lê Thu Hà', N'Công nghệ phần mềm'),
(N'GV004', N'TS. Phạm Đức Long', N'Hệ thống thông tin'),
(N'GV005', N'ThS. Vũ Hoàng Nam', N'Công nghệ phần mềm'),
(N'GV006', N'ThS. Đỗ Hải Yến', N'Khoa học máy tính'),
(N'GV007', N'TS. Nguyễn Thành Công', N'Mạng máy tính'),
(N'GV008', N'TS. Bùi Thanh Tùng', N'Khoa học máy tính');
GO

INSERT INTO LOP_HOC_PHAN(ma_lop, ma_hp, ma_gv, hoc_ky_id, si_so_toi_da, trang_thai) VALUES
(N'LHP-26001', N'IT6040', N'GV001', 1, 60, N'DANG_MO'),
(N'LHP-26002', N'IT6040', N'GV002', 1, 55, N'DA_DU'),
(N'LHP-26003', N'IT6021', N'GV003', 1, 50, N'DANG_MO'),
(N'LHP-26004', N'IT6034', N'GV004', 1, 45, N'DANG_MO'),
(N'LHP-26005', N'IT6050', N'GV005', 1, 35, N'DANG_MO'),
(N'LHP-26006', N'IT6018', N'GV006', 1, 50, N'DA_DU'),
(N'LHP-26007', N'IT6062', N'GV007', 1, 55, N'DANG_MO'),
(N'LHP-26008', N'IT6071', N'GV008', 1, 40, N'DANG_MO');
GO

INSERT INTO TAI_KHOAN(ten_dang_nhap, mat_khau_hash, vai_tro, trang_thai) VALUES
(N'2024607392', N'123456', N'SINH_VIEN', N'HOAT_DONG'),
(N'admin', N'admin123', N'QUAN_TRI_VIEN', N'HOAT_DONG');
GO

INSERT INTO SINH_VIEN(ma_sv, ho_ten, lop, khoa, tai_khoan_id) VALUES
(N'2024607392', N'Bùi Trung Hiếu', N'CNTT01-K19', N'Công nghệ thông tin', 1);
GO
