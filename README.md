# LibMan

LibMan là Java Dynamic Web Project theo mẫu Eclipse, dùng JSP, JDBC và HTTP. Cấu hình ban đầu theo Java 8/Tomcat 9/MySQL 8, nhưng script VS Code không ép hạ phiên bản và dùng các bản đang có trên máy. Project không dùng Maven, Spring hay Servlet tự viết.

Project cũng chạy trực tiếp bằng VS Code với Java/Tomcat/MySQL đang có trên máy. Chạy `powershell -ExecutionPolicy Bypass -File .\run-libman.ps1` trong terminal để tự lấy Connector/J trong Maven cache, kiểm tra/import database, biên dịch, deploy vào Tomcat và mở Reader UI.

Mã nguồn nằm trong `src/dao`, `src/model`, `src/unittest`; giao diện nằm trong `WebContent/bd` (Reader), `WebContent/ql` (Manager), `WebContent/css`, `WebContent/header.jsp` và `WebContent/WEB-INF/lib`.

Module Reader có tìm kiếm title và xem bản sao. Module Manager có thống kê độc giả, lịch sử mượn và chi tiết phiếu. JSP gọi trực tiếp DAO theo sequence V3, giữ nguyên tên lớp, phương thức và tham số đã định nghĩa.

Banner dùng tiêu đề `LibMan - Hệ thống Quản lý Thư viện`. Các mã `DT`, `DG`, `PM`, `CP`, `NV` được hiển thị từ ID `INT` bằng `LPAD`; không lưu ID dạng chuỗi thay thế.

Xem [SETUP.md](SETUP.md) để import Eclipse, tạo database, cấu hình JDBC, chạy Tomcat HTTP và dùng tài khoản demo. Các điểm không thống nhất trong tài liệu Word được ghi tại [DESIGN_INCONSISTENCIES.md](DESIGN_INCONSISTENCIES.md) và không tự sửa sơ đồ.
