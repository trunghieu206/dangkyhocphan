# HaUI – Hệ thống Quản lý và Đăng ký Học phần (Full-Stack IntelliJ + SQL Server)

Dự án đã được nâng cấp đầy đủ để đáp ứng toàn bộ **8 yêu cầu nghiệm thu**:
1. **Mã nguồn dự án:** Đầy đủ Frontend (`index.html`), Backend Java Spring Boot (`src/main/java/...`) và tệp cấu hình Maven (`pom.xml`), cấu hình kết nối (`application.properties`).
2. **Cơ sở dữ liệu:** File `database/database.sql` tạo đầy đủ 10 bảng và dữ liệu mẫu trên SQL Server.
3. **Giao diện chương trình:** Màn hình Đăng nhập, Tổng quan, Tra cứu học phần, Đăng ký/Hủy đăng ký (Sinh viên), Quản lý học phần (Quản trị viên).
4. **Chức năng quản lý chính:** Xem danh sách, tìm kiếm/lọc, Thêm mới, Chỉnh sửa, Xóa (chặn xóa khi có lớp liên kết) và chuyển trạng thái Ngừng hoạt động.
5. **Kết nối dữ liệu thực tế:** Kết nối đọc/ghi trực tiếp vào SQL Server thông qua Spring Data JPA & REST API (`/api/courses`).
6. **Bảng kiểm thử:** File `docs/bang_kiem_thu_test_cases.xlsx` chứa 10 Test Cases chi tiết kèm kết quả thực tế.
7. **Tài liệu hướng dẫn:** Quy trình cài đặt và chạy hệ thống chi tiết bên dưới.
8. **Hỗ trợ Demo trực tiếp:** Có thể chạy trực tiếp trên IntelliJ IDEA (`http://localhost:8080`) hoặc mở nhanh `index.html`.

---

## Cấu trúc thư mục dự án (IntelliJ IDEA)
```text
haui_dang_ky_hoc_phan_intellij/
├── pom.xml                                      # Tệp cấu hình Maven cho IntelliJ IDEA
├── database/
│   └── database.sql                             # Script tạo CSDL SQL Server & dữ liệu mẫu
├── docs/
│   └── bang_kiem_thu_test_cases.xlsx            # Bảng kiểm thử (Test Cases)
├── src/main/
│   ├── java/com/haui/dangkyhocphan/
│   │   ├── DangKyHocPhanApplication.java        # Class khởi chạy Spring Boot
│   │   ├── entity/HocPhan.java                  # Entity ánh xạ bảng HOC_PHAN
│   │   ├── repository/HocPhanRepository.java    # Giao tiếp CSDL qua Spring Data JPA
│   │   └── controller/HocPhanController.java    # REST API Đọc/Thêm/Sửa/Xóa học phần
│   └── resources/
│       ├── application.properties               # Cấu hình cổng 8080 và kết nối SQL Server
│       └── static/index.html                    # Giao diện chương trình kết nối API Backend
└── index.html                                   # Bản sao giao diện ở thư mục gốc
```

---

## Hướng dẫn cài đặt và chạy hệ thống trên IntelliJ IDEA

### Bước 1: Khởi tạo Cơ sở dữ liệu SQL Server
1. Mở **SQL Server Management Studio (SSMS)**.
2. Mở file `database/database.sql` và nhấn **Execute (F5)** để tạo CSDL `HaUIDangKyHocPhan` cùng toàn bộ bảng và dữ liệu mẫu.
3. Đảm bảo SQL Server đã bật giao thức **TCP/IP** ở cổng `1433`.

### Bước 2: Mở và cấu hình dự án trong IntelliJ IDEA
1. Mở **IntelliJ IDEA** -> chọn **Open** -> trỏ tới thư mục `haui_dang_ky_hoc_phan_intellij` (chứa file `pom.xml`).
2. Đợi IntelliJ tải xong các thư viện Maven (Spring Web, Spring Data JPA, MS SQL Server Driver).
3. Mở file `src/main/resources/application.properties` và cập nhật lại `username` / `password` SQL Server của máy bạn:
   ```properties
   spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=HaUIDangKyHocPhan;encrypt=false;trustServerCertificate=true
   spring.datasource.username=sa
   spring.datasource.password=MatKhauSQLCuaBan
   ```

### Bước 3: Chạy Backend & Giao diện chương trình
1. Trong IntelliJ IDEA, mở file `src/main/java/com/haui/dangkyhocphan/DangKyHocPhanApplication.java`.
2. Nhấn nút **Run (▶)** ở cạnh hàm `main`.
3. Khi Console hiện thông báo `Tomcat started on port 8080`, mở trình duyệt và truy cập:
   - **URL hệ thống:** `http://localhost:8080`
   - **API kiểm tra dữ liệu JSON:** `http://localhost:8080/api/courses`

### Tài khoản đăng nhập Demo
- **Quản trị viên:** `admin` / `admin123` (Quản lý thêm, sửa, xóa, đổi trạng thái học phần trực tiếp trên SQL Server).
- **Sinh viên:** `2024607392` / `123456` (Tra cứu học phần, đăng ký lớp học phần, hủy đăng ký).
