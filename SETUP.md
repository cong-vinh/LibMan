# LibMan: hướng dẫn chạy

## Yêu cầu

- VS Code (hoặc Eclipse) và một JDK đang hoạt động.
- Apache Tomcat đang có trên máy (script tự dò `CATALINA_HOME`, `C:\apache-tomcat-8.5.99` và Tomcat 9).
- MySQL Server đang chạy và MySQL Connector/J. Script tự lấy Connector/J từ `%USERPROFILE%\.m2` nếu có.
- Ứng dụng chạy HTTP; không cần HTTPS, Maven, Spring hoặc Servlet tự viết.

## Import vào Eclipse

1. Chọn `File > Import > General > Existing Projects into Workspace`.
2. Chọn thư mục gốc chứa `.project`, giữ project name `LibMan`, rồi chọn `Finish`.
3. Trong `Project > Properties > Targeted Runtimes`, chọn Tomcat 9 và Java 8.
4. Đặt file `mysql-connector-j-8.x.x.jar` vào `WebContent/WEB-INF/lib` rồi refresh project.
5. Kiểm tra `Java Build Path`: source folder là `src`, output folder là `build/classes`.

## Tạo cơ sở dữ liệu

Chạy toàn bộ file `database/libman.sql` bằng MySQL Workbench hoặc lệnh:

```text
mysql -u root -p < database/libman.sql
```

Script tạo database `libman`, các bảng `tbl...8`, khóa ngoại và dữ liệu demo tháng 10/2026.

## Cấu hình JDBC

DAO đọc các giá trị sau theo thứ tự system property rồi đến biến môi trường:

```text
libman.jdbc.url=jdbc:mysql://localhost:3306/libman?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Bangkok
libman.jdbc.user=root
libman.jdbc.password=<mật khẩu MySQL>
```

Trong Eclipse, đặt các giá trị này ở cấu hình Tomcat trong `Run Configurations > Arguments > VM arguments`. Có thể dùng `LIBMAN_DB_URL`, `LIBMAN_DB_USER`, `LIBMAN_DB_PASSWORD` thay cho system properties.

## Chạy ứng dụng

### VS Code, một lệnh

Mở terminal tại thư mục project và chạy:

```powershell
powershell -ExecutionPolicy Bypass -File .\run-libman.ps1
```

Script dùng JDK/Tomcat hiện có, kiểm tra kết nối MySQL, chỉ import `database/libman.sql` khi database `libman` chưa tồn tại, sau đó chạy `database/libman_repair_and_more.sql` bằng byte UTF-8 để khôi phục tiếng Việt và bổ sung dữ liệu demo. Script không xóa database hiện có. Nó tiếp tục biên dịch Java, deploy vào `webapps\LibMan`, chờ Tomcat phản hồi và mở trình duyệt. Có thể chạy không mở trình duyệt bằng `-NoBrowser`.

Trong VS Code cũng có thể chọn `Terminal > Run Task > Run LibMan`.

Nếu MySQL chưa chạy, script dừng với thông báo rõ ràng; khởi động MySQL rồi chạy lại lệnh. Máy hiện không có dịch vụ MySQL lắng nghe cổng 3306, nên cần hoàn tất bước đó trước khi chạy website.

Thêm project vào Tomcat, chọn `Run on Server`, rồi mở `http://localhost:8080/LibMan/`.

Project không có màn hình đăng nhập trong sơ đồ. Để chạy đúng quyền của dữ liệu seed, mở trực tiếp:

- Reader: `bd/ReaderMainUI8.jsp?readerId=1`.
- Manager: `ql/ManagerMainUI8.jsp?employeeId=1`.

Các trang kiểm tra `readerId` với `tblReader8` và `employeeId` với `tblManager8`. Tham số không hợp lệ sẽ bị từ chối.

## Tài khoản và mã demo

| Vai trò | username | password | mã dùng trong URL |
|---|---|---|---|
| Manager8 | `manager` | `123456` | `employeeId=1` (`NV01`) |
| Librarian8 | `librarian` | `123456` | `employeeId=2` (`NV02`) |
| Reader8 | `reader01` | `123456` | `readerId=1` (`DG01`) |
| Reader8 | `reader02` | `123456` | `readerId=2` (`DG02`) |
| Reader8 | `reader03` | `123456` | `readerId=3` (`DG03`) |

Ứng dụng giữ ID model là `INT`; mã `DT`, `DG`, `PM`, `CP`, `NV` chỉ là cách hiển thị bằng `LPAD`.

## Kiểm tra

Biên dịch Java 8:

```text
javac -encoding UTF-8 -source 8 -target 8 -d build/classes src/dao/*.java src/model/*.java src/unittest/*.java
```

Sau khi MySQL và Connector/J hoạt động, chạy `unittest.DaoIntegrationTest8` để kiểm tra từng DAO với dữ liệu seed.
