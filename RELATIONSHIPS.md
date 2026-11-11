# Quan hệ lớp theo sơ đồ chi tiết

Các quan hệ dưới đây được ghi lại theo bước thiết kế trong tài liệu Word; skeleton không thêm nghiệp vụ để thực hiện chúng.

- `Manager8`, `Librarian8`, `Reader8` kế thừa `User8`.
- `Reader8` chứa `LibraryCard8` (composition, 1 - 0..1) và `LoanRecord8[]` (aggregation, 1 - n).
- `DocumentType8` chứa `DocumentTypeCopy8[]` (composition, 1 - n).
- `Librarian8` chứa `LoanRecord8[]`, `ReturnRecord8[]`, `ImportRecord8[]` (aggregation).
- `LoanRecord8` chứa `LoanDetail8[]` (composition); `DocumentTypeCopy8` liên kết `LoanDetail8[]`.
- `ReturnRecord8` chứa `ReturnDetail8[]` (composition); `DocumentTypeCopy8` liên kết `ReturnDetail8[]`.
- `ReturnDetail8` liên kết `FineRecord8` (aggregation, tùy chọn).
- `Supplier8` chứa `ImportRecord8[]`; `ImportRecord8` chứa `ImportDetail8[]` (composition); `DocumentTypeCopy8` liên kết `ImportDetail8[]`.
- `ReaderBorrowStatistics8` kế thừa `Reader8`; `DocumentBorrowStatistics8` kế thừa `DocumentType8`; `SupplierImportStatistics8` kế thừa `Supplier8`.

Các quan hệ khóa ngoại trong ERD (`tblUser8`, `tblReader8`, `tblLoanRecord8` và các bảng `tbl...8`) chưa được chuyển thành SQL ở giai đoạn dựng khung.
