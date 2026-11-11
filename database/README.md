# database

`libman.sql` tạo schema MySQL 8 theo quy ước bảng `tbl...8`, giữ các khóa ID kiểu `INT` và seed dữ liệu demo cho hai module Reader/Manager.

Mã hiển thị DT/DG/PM/CP/NV được quy đổi bằng `LPAD` từ ID số nguyên của model. Không có bảng thống kê; số lượt mượn được tính từ `tblLoanRecord8`.
Các DAO đọc thông tin kết nối từ system properties `libman.jdbc.url`, `libman.jdbc.user`, `libman.jdbc.password` hoặc biến môi trường `LIBMAN_DB_URL`, `LIBMAN_DB_USER`, `LIBMAN_DB_PASSWORD`.
