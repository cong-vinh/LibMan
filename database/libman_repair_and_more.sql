USE libman;
SET NAMES utf8mb4;
ALTER DATABASE libman CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE tblUser8 CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE tblReader8 CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE tblLibraryCard8 CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE tblSupplier8 CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE tblDocumentType8 CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE tblDocumentTypeCopy8 CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE tblFineRecord8 CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE tblLoanRecord8 CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE tblReturnRecord8 CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE tblReturnDetail8 CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Restore the original Vietnamese seed text by stable numeric IDs.
UPDATE tblUser8 SET fullName = 'Nguyễn Văn Quản Lý', address = 'Hà Nội' WHERE id = 1;
UPDATE tblUser8 SET fullName = 'Trần Văn B', address = 'Hà Nội' WHERE id = 2;
UPDATE tblUser8 SET fullName = 'Nguyễn Văn An', address = 'Hà Nội' WHERE id = 101;
UPDATE tblUser8 SET fullName = 'Trần Thị Phương', address = 'Hà Nội' WHERE id = 102;
UPDATE tblUser8 SET fullName = 'Đinh Công Vinh', address = 'Hà Nội' WHERE id = 103;
UPDATE tblReader8 SET readerStatus = 'Đang hoạt động' WHERE readerId IN (1, 2, 3);
UPDATE tblLibraryCard8 SET status = 'Còn hiệu lực' WHERE cardId IN (1, 2, 3);
UPDATE tblSupplier8 SET name = 'Nhà sách Đại học', address = 'Hà Nội', description = 'Nhà cung cấp demo' WHERE supplierId = 1;
UPDATE tblDocumentType8 SET title = 'Lập trình Java', author = 'Nguyễn Văn A', publisher = 'NXB Giáo Dục', description = 'Giáo trình nhập môn lập trình Java cho sinh viên đại học.' WHERE documentTypeId = 1;
UPDATE tblDocumentType8 SET title = 'Cơ sở dữ liệu', author = 'Trần Văn B', publisher = 'NXB Khoa Học', description = 'Giáo trình' WHERE documentTypeId = 2;
UPDATE tblDocumentType8 SET title = 'Mạng máy tính', author = 'Lê Công C', publisher = 'NXB Bách Khoa', description = 'Sách' WHERE documentTypeId = 3;
UPDATE tblDocumentTypeCopy8 SET status = 'Sẵn có', copyCondition = 'Tốt' WHERE copyId IN (1, 2, 3, 4, 6, 7, 8, 9, 10);
UPDATE tblDocumentTypeCopy8 SET status = 'Đang mượn', copyCondition = 'Tốt' WHERE copyId = 5;
UPDATE tblLoanRecord8 SET status = 'Đã trả' WHERE loanRecordId IN (1, 2, 4, 5, 6);
UPDATE tblLoanRecord8 SET status = 'Quá hạn' WHERE loanRecordId = 3;
UPDATE tblReturnRecord8 SET returnDate = '2026-10-12' WHERE returnRecordId = 1;
UPDATE tblReturnRecord8 SET returnDate = '2026-10-19' WHERE returnRecordId = 2;
UPDATE tblReturnDetail8 SET copyCondition = 'Tốt' WHERE returnDetailId IN (1, 2, 3, 4, 5, 6);

-- Additional Vietnamese demo data. INSERT IGNORE keeps reruns idempotent.
INSERT IGNORE INTO tblUser8
    (id, username, password, fullName, dateOfBirth, address, email, phoneNumber)
VALUES
    (104, 'reader04', '123456', 'Phạm Minh Anh', '2001-06-17', 'Đà Nẵng', 'anh@libman.local', '0900000104'),
    (105, 'reader05', '123456', 'Lê Hoàng Nam', '1999-07-18', 'Hải Phòng', 'nam@libman.local', '0900000105'),
    (106, 'reader06', '123456', 'Vũ Thu Hà', '2002-08-19', 'Huế', 'ha@libman.local', '0900000106'),
    (107, 'reader07', '123456', 'Đỗ Quang Huy', '2000-09-20', 'Cần Thơ', 'huy@libman.local', '0900000107'),
    (108, 'reader08', '123456', 'Bùi Ngọc Lan', '2001-10-21', 'Hà Nội', 'lan@libman.local', '0900000108');

INSERT IGNORE INTO tblReader8 (userId, readerId, readerStatus) VALUES
    (104, 4, 'Đang hoạt động'), (105, 5, 'Đang hoạt động'),
    (106, 6, 'Đang hoạt động'), (107, 7, 'Đang hoạt động'),
    (108, 8, 'Đang hoạt động');

INSERT IGNORE INTO tblLibraryCard8 (cardId, readerUserId, issueDate, expiryDate, status) VALUES
    (4, 104, '2026-01-01', '2026-12-31', 'Còn hiệu lực'),
    (5, 105, '2026-01-01', '2026-12-31', 'Còn hiệu lực'),
    (6, 106, '2026-01-01', '2026-12-31', 'Còn hiệu lực'),
    (7, 107, '2026-01-01', '2026-12-31', 'Còn hiệu lực'),
    (8, 108, '2026-01-01', '2026-12-31', 'Còn hiệu lực');

INSERT IGNORE INTO tblDocumentType8
    (documentTypeId, title, author, publisher, publicationYear, description)
VALUES
    (4, 'Lập trình Python', 'Nguyễn Minh K', 'NXB Trẻ', 2024, 'Giáo trình lập trình Python.'),
    (5, 'Hệ điều hành', 'Phạm Quốc D', 'NXB Bách Khoa', 2022, 'Kiến thức về hệ điều hành.'),
    (6, 'Cấu trúc dữ liệu', 'Lê Thu H', 'NXB Giáo Dục', 2023, 'Giáo trình cấu trúc dữ liệu và giải thuật.'),
    (7, 'Phân tích thiết kế hệ thống', 'Vũ Anh T', 'NXB Khoa Học', 2021, 'Tài liệu phân tích và thiết kế hệ thống.'),
    (8, 'An toàn thông tin', 'Đỗ Minh P', 'NXB Thông Tin', 2024, 'Nhập môn an toàn thông tin.');

INSERT IGNORE INTO tblDocumentTypeCopy8
    (copyId, documentTypeId, status, copyCondition)
VALUES
    (11, 4, 'Sẵn có', 'Tốt'), (12, 4, 'Sẵn có', 'Tốt'),
    (13, 5, 'Sẵn có', 'Tốt'), (14, 5, 'Sẵn có', 'Tốt'),
    (15, 6, 'Sẵn có', 'Tốt'), (16, 6, 'Sẵn có', 'Tốt'),
    (17, 7, 'Sẵn có', 'Tốt'), (18, 7, 'Sẵn có', 'Tốt'),
    (19, 8, 'Sẵn có', 'Tốt'), (20, 8, 'Sẵn có', 'Tốt');

INSERT IGNORE INTO tblLoanRecord8
    (loanRecordId, readerUserId, librarianUserId, loanDate, status)
VALUES
    (7, 104, 2, '2026-10-03', 'Đã trả'),
    (8, 104, 2, '2026-10-18', 'Đang mượn'),
    (9, 105, 2, '2026-10-04', 'Đã trả'),
    (10, 105, 2, '2026-10-22', 'Đang mượn'),
    (11, 106, 2, '2026-10-07', 'Đã trả'),
    (12, 106, 2, '2026-10-24', 'Đang mượn'),
    (13, 107, 2, '2026-10-11', 'Đã trả'),
    (14, 107, 2, '2026-10-26', 'Đang mượn'),
    (15, 108, 2, '2026-10-14', 'Đã trả'),
    (16, 108, 2, '2026-10-28', 'Đang mượn');

INSERT IGNORE INTO tblLoanDetail8 (loanDetailId, loanRecordId, copyId) VALUES
    (11, 7, 11), (12, 8, 12), (13, 9, 13), (14, 10, 14),
    (15, 11, 15), (16, 12, 16), (17, 13, 17), (18, 14, 18),
    (19, 15, 19), (20, 16, 20);
