LibMan – Hệ thống Quản lý Thư viện
LibMan là website quản lý thư viện được xây dựng bằng Java, JSP, JDBC và MySQL. Dự án tập trung vào hai module theo bài tập phân tích thiết kế hệ thống: tìm kiếm thông tin tài liệu và thống kê độc giả theo số lần mượn.
1. Công nghệ sử dụng
Thành phần	Công nghệ
Giao diện	HTML5, CSS3, JavaScript, JSP
Xử lý nghiệp vụ	Java, các lớp DAO
Máy chủ ứng dụng	Apache Tomcat 9.x
Kết nối cơ sở dữ liệu	JDBC, MySQL Connector/J 9.1.0
Cơ sở dữ liệu	MySQL Server 8.0, schema libman
Môi trường phát triển	VS Code hoặc Eclipse trên Windows


- Dự án không cần Maven, Spring Boot, Node.js hoặc Servlet tự viết.
- Thư viện JDBC đã có trong WebContent/WEB-INF/lib/mysql-connector-j-9.1.0.jar.
- Dự án có script run-libman.ps1 để chạy trên Windows bằng PowerShell.
2. Chức năng chính
Module 1 – Tìm kiếm thông tin tài liệu (Bạn đọc)
1. Từ trang chính của bạn đọc, mở chức năng tìm kiếm tài liệu.
2. Nhập tên tài liệu và xem danh sách kết quả.
3. Chọn tài liệu để xem thông tin chi tiết và tình trạng các bản sao.
Module 2 – Thống kê độc giả theo số lần mượn (Nhân viên quản lý)
1. Từ trang chính quản lý, chọn Xem báo cáo → Thống kê độc giả theo số lần mượn.
2. Chọn khoảng thời gian, có thể lọc theo tên độc giả.
3. Xem danh sách độc giả và số lượt mượn.
4. Nhấp mã hoặc tên độc giả để xem lịch sử mượn; chọn phiếu mượn để xem chi tiết.
3. Cấu trúc thư mục
LibMan/
├── src/
│   ├── dao/                      # Các lớp truy xuất MySQL
│   ├── model/                    # Các lớp thực thể
│   └── unittest/                 # Kiểm thử DAO
├── WebContent/
│   ├── bd/                       # Giao diện bạn đọc
│   ├── ql/                       # Giao diện quản lý
│   ├── css/                      # Giao diện và định dạng
│   ├── header.jsp
│   └── WEB-INF/
│       ├── jspf/
│       ├── lib/                  # MySQL Connector/J 9.1.0
│       └── web.xml
├── database/
│   ├── libman.sql                # Tạo bảng và dữ liệu mẫu ban đầu
│   └── libman_repair_and_more.sql # Chuẩn hóa tiếng Việt, thêm dữ liệu
├── run-libman.ps1                # Script cài dữ liệu, biên dịch và chạy
└── README.md
4. Yêu cầu cài đặt trên Windows
Trước khi chạy, cài:
1. Git để clone mã nguồn.
2. JDK (khuyến nghị JDK 17 hoặc 21); lệnh java và javac phải hoạt động.
3. Apache Tomcat 9.x (không dùng Tomcat 10/11 vì khác namespace JSP/Servlet).
4. MySQL Server 8.0; để cổng mặc định 3306, tạo tài khoản root với mật khẩu do người cài đặt chọn.
5. VS Code (khuyến nghị) hoặc một công cụ hỗ trợ chạy PowerShell. MySQL Workbench là tùy chọn để xem dữ liệu.
Kiểm tra Java:
java -version
javac -version
Nếu chưa cấu hình, đặt biến môi trường cho phiên Terminal đang sử dụng (thay đường dẫn bằng đường dẫn cài đặt thực tế):
$env:JAVA_HOME = 'C:\Program Files\Java\jdk-17'
$env:CATALINA_HOME = 'C:\apache-tomcat-9.0.xx'
run-libman.ps1 yêu cầu javac có trong PATH, cần xác định được JAVA_HOME và thư mục Tomcat. Tomcat đặt ở vị trí khác thì phải cấu hình CATALINA_HOME đến thư mục chứa bin\startup.bat.

Script hiện tìm mysql.exe tại C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe hoặc thư mục MySQL Server 9.6 tương ứng. Với bản MySQL cài ở đường dẫn khác, cần sửa danh sách đường dẫn $mysqlExe trong run-libman.ps1.

5. Clone mã nguồn từ GitHub
Mở PowerShell hoặc Terminal của VS Code:
git clone https://github.com/cong-vinh/LibMan.git
cd LibMan
code .
Nếu chưa cài lệnh code, có thể mở thư mục LibMan thủ công trong VS Code bằng File → Open Folder.
6. Cấu hình cơ sở dữ liệu MySQL
Thông số kết nối mặc định trong src/dao/DAO8.java:
Thuộc tính	Giá trị
Host	localhost
Port	3306
Database	libman
User	root
JDBC URL	jdbc:mysql://localhost:3306/libman?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Bangkok
Password	Mật khẩu MySQL root đã đặt khi cài đặt


Bật dịch vụ MySQL và kiểm tra bằng PowerShell:
Get-Service *MySQL*
Nếu dịch vụ MySQL80 đang dừng, mở PowerShell Run as administrator rồi chạy:
Start-Service MySQL80
Tên dịch vụ có thể khác MySQL80, hãy dùng tên hiển thị bởi Get-Service.
Import dữ liệu
Nếu chạy bằng script ở bước 7, không cần import thủ công khi database libman chưa tồn tại. Script tự động:
- Tạo database và import database/libman.sql nếu schema libman chưa tồn tại.
- Chạy database/libman_repair_and_more.sql để sửa dữ liệu tiếng Việt và bổ sung dữ liệu mẫu.
Nếu database libman đã tồn tại nhưng rỗng hoặc thiếu bảng, mở MySQL Workbench, chạy lần lượt:
1. database/libman.sql
2. database/libman_repair_and_more.sql
Cảnh báo: File libman.sql có các lệnh DROP TABLE. Không chạy lại trên database có dữ liệu cần giữ, vì sẽ xóa và tạo lại các bảng. Tốt nhất dùng database mới dành riêng cho bài demo.
7. Khởi động website bằng một lệnh
Đảm bảo MySQL đã chạy. Nếu Tomcat đang chạy từ trước, hãy tắt Tomcat trước khi chạy script để Tomcat nhận biến môi trường mật khẩu JDBC mới.

Tại thư mục gốc LibMan trong PowerShell:
powershell -ExecutionPolicy Bypass -File .\run-libman.ps1
Nhập mật khẩu MySQL root khi được hỏi:
Enter the MySQL root password:
Script sẽ kiểm tra Java, Tomcat, MySQL và JDBC driver; import dữ liệu khi cần, biên dịch các file .java, triển khai ứng dụng vào webapps/LibMan, khởi động Tomcat tại cổng 8080 nếu cổng đang trống, sau đó mở trang chính bạn đọc.

Muốn chạy mà không tự mở trình duyệt:
powershell -ExecutionPolicy Bypass -File .\run-libman.ps1 -NoBrowser
Trong VS Code cũng có thể chọn Terminal → Run Task → Run LibMan.

Lưu ý: Cổng 8080 phải dùng đúng cho Tomcat. Nếu cổng đã bị ứng dụng khác chiếm, script sẽ không tự khởi động Tomcat mới. Kiểm tra cổng và dừng ứng dụng đang chiếm cổng trước khi chạy lại.
8. Đường dẫn truy cập hai module
Sau khi chạy thành công trên máy cục bộ:

Module 1 – Tìm kiếm tài liệu (Bạn đọc):
http://localhost:8080/LibMan/bd/ReaderMainUI8.jsp?readerId=1
Module 2 – Thống kê độc giả theo số lần mượn (Quản lý):
http://localhost:8080/LibMan/ql/ManagerMainUI8.jsp?employeeId=1
Đây là các địa chỉ trên máy đang chạy Tomcat, không phải website được GitHub lưu trữ trực tuyến.

Dự án chưa xây dựng màn hình đăng nhập. Các tham số readerId=1 (độc giả DG01) và employeeId=1 (quản lý NV01) dùng để chọn bản ghi demo trong MySQL; nếu bỏ tham số hoặc dùng ID không tồn tại, các nút chức năng có thể bị vô hiệu hóa.
9. Cách kiểm thử nhanh
Module 1: Mở link Reader → Tìm kiếm tài liệu → nhập từ khóa Java hoặc Cơ sở dữ liệu → chọn một tài liệu → xem chi tiết và bản sao.

Module 2: Mở link Manager → Xem báo cáo → Thống kê độc giả theo số lần mượn → chọn ngày từ 01/10/2026 đến 31/10/2026 → Xem thống kê → chọn tên/mã độc giả → xem lịch sử mượn và chi tiết phiếu mượn.

Có thể kiểm tra database trong MySQL Workbench:
USE libman;
SHOW TABLES;
SELECT COUNT(*) AS so_doc_gia FROM tblReader8;
SELECT COUNT(*) AS so_dau_tai_lieu FROM tblDocumentType8;
SELECT COUNT(*) AS so_phieu_muon FROM tblLoanRecord8;
Với database mới đã import đủ cả hai file SQL, dữ liệu mẫu có 15 bảng, 8 độc giả, 8 đầu tài liệu và 16 phiếu mượn.
10. Xử lý lỗi thường gặp
Lỗi	Cách xử lý
javac was not found	Cài JDK và thêm thư mục bin của JDK vào PATH.
JAVA_HOME was not found	Thiết lập JAVA_HOME đến thư mục JDK.
Tomcat was not found	Thiết lập CATALINA_HOME đến thư mục Tomcat 9.x.
mysql.exe was not found	Cài MySQL Server 8.0 đúng đường dẫn mà script kiểm tra, hoặc sửa $mysqlExe trong run-libman.ps1.
Không kết nối được MySQL	Kiểm tra dịch vụ MySQL, cổng 3306, tài khoản root và mật khẩu đã nhập.
Database có sẵn nhưng thiếu bảng	Import libman.sql rồi libman_repair_and_more.sql trên database demo (lưu ý dữ liệu cũ có thể bị xóa).
Trang báo 404	Kiểm tra Tomcat đang chạy cổng 8080 và có thư mục webapps/LibMan.
Trang hiển thị nhưng nút không hoạt động	Kiểm tra database, mật khẩu JDBC và các tham số readerId=1 hoặc employeeId=1.
Đã bật Tomcat trước khi chạy script	Tắt hẳn Tomcat, sau đó chạy lại run-libman.ps1 để nhận cấu hình JDBC.


Nếu Tomcat không phản hồi, xem nhật ký tại thư mục logs của Tomcat.
11. Ghi chú triển khai
- Dự án dùng HTTP nội bộ tại localhost:8080, chưa cấu hình HTTPS hoặc triển khai lên máy chủ công khai.
- Các mã DT, DG, PM, CP, NV là mã hiển thị được định dạng từ ID số nguyên trong cơ sở dữ liệu.
- Phần thống kê số lượt mượn được tính từ dữ liệu phiếu mượn, không có bảng thống kê lưu riêng.
- File SQL và dữ liệu tài khoản trong repository dùng cho mục đích học tập/demo. Không dùng mật khẩu mẫu khi triển khai sản phẩm thực tế.
Mã nguồn: https://github.com/cong-vinh/LibMan