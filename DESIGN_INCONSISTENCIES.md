# Các điểm không thống nhất trong tài liệu Word

Tệp này chỉ ghi nhận; không tự sửa sơ đồ.

1. Phần bảng từ khóa và mô tả phân tích dùng tên không có hậu tố `8` (`User`, `Reader`, `DocumentType`…), trong khi sơ đồ lớp chi tiết, UI và sequence V3 dùng `User8`, `Reader8`, `DocumentType8`… Skeleton dùng bộ tên của sơ đồ chi tiết/sequence V3.
2. Tên lớp thống kê thay đổi giữa các phần: `DocumentTypeBorrowingStatistic` / `DocumentBorrowStatistics8` và `SupplierImportStatistic` / `SupplierImportStatistics8`. Skeleton giữ tên xuất hiện trong sơ đồ lớp chi tiết (`DocumentBorrowStatistics8`, `SupplierImportStatistics8`).
3. `User8.id` được bổ sung ở bước thiết kế CSDL, nhưng không xuất hiện trong hộp lớp phân tích ban đầu. Skeleton giữ `id` theo bước thiết kế.
4. `DocumentTypeCopy` ở phần mô tả khái niệm còn nêu `barcode`, `shelfLocation`, `acquiredDate`, `documentTypeId`; hộp lớp chi tiết chỉ có `copyId`, `status`, `copyCondition`. Skeleton giữ đúng hộp lớp chi tiết và quan hệ `DocumentType8.copies`.
5. Các hộp lớp phân tích module 1/2 gán thao tác tìm kiếm/thống kê cho lớp thực thể (`DocumentType8`, `LoanRecord8`). Sequence V3 và hộp lớp chi tiết gán thao tác truy vấn cho DAO (`DocumentTypeDAO8`, `ReaderStatisticDAO8`, `LoanRecordDAO8`, `LoanDetailDAO8`). Skeleton giữ chữ ký DAO theo sequence V3.
6. Tên/thuộc tính UI ở sơ đồ phân tích khác với UI chi tiết: ví dụ `inDocumentTypeName`, `outDocumentTypeList`, `outMessage` so với `keyword`, `resultList`, `resultCategories`; module 2 cũng có các trường khác nhau giữa hai hình. Skeleton dùng UI chi tiết và sequence V3.
7. Bước thiết kế nói các lớp thống kê là thuộc tính dẫn xuất và loại bỏ bảng thống kê, nhưng ERD/CSDL vẫn vẽ `tblReaderBorrowStatistics8`, `tblDocumentBorrowStatistics8`, `tblSupplierImportStatistics8`. `database/libman.sql` theo yêu cầu hiện tại chọn cách tính trực tiếp từ `tblLoanRecord8` và không tạo ba bảng này.
8. Quan hệ Reader–ReturnRecord xuất hiện trong phần quan hệ phân tích, nhưng hộp lớp chi tiết không thể hiện thuộc tính `returnRecords` trong `Reader8`; skeleton giữ các thuộc tính chứa được nêu ở bước thiết kế cuối và không thêm trường Reader ngoài sơ đồ.
9. Hộp lớp `LoanDetail8` chỉ hiển thị `loanDetailId`, còn phần CSDL và mô tả nghiệp vụ yêu cầu FK `copyId` để nhận diện đúng bản mượn. `LoanDetail8` và `tblLoanDetail8` giữ `copyId` theo phần CSDL/sequence.
10. Tài liệu không mô tả màn hình đăng nhập/session, trong khi luồng UI truyền `readerId` và `employeeId`. Ứng dụng dùng hai ID này để kiểm tra quyền với `tblReader8` và `tblManager8`, không tự thêm màn hình đăng nhập.
11. UI chi tiết phiếu yêu cầu tên độc giả, tên thủ thư và title/số lượng, nhưng hộp `LoanRecord8`/`LoanDetail8` chưa khai báo các thuộc tính hiển thị này. Ứng dụng giữ nguyên model và lấy các cột liên quan bằng JOIN khi dựng trang chi tiết.
