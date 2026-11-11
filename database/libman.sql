-- LibMan / MySQL 8
-- Core schema follows the tbl...8 names in the Word ERD.
-- Statistical tables are intentionally absent: borrowing counts are calculated
-- from tblLoanRecord8 (one LoanRecord8 = one borrowing for a Reader).

CREATE DATABASE IF NOT EXISTS libman
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE libman;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS tblImportDetail8;
DROP TABLE IF EXISTS tblImportRecord8;
DROP TABLE IF EXISTS tblReturnDetail8;
DROP TABLE IF EXISTS tblReturnRecord8;
DROP TABLE IF EXISTS tblLoanDetail8;
DROP TABLE IF EXISTS tblLoanRecord8;
DROP TABLE IF EXISTS tblFineRecord8;
DROP TABLE IF EXISTS tblDocumentTypeCopy8;
DROP TABLE IF EXISTS tblDocumentType8;
DROP TABLE IF EXISTS tblLibraryCard8;
DROP TABLE IF EXISTS tblSupplier8;
DROP TABLE IF EXISTS tblReader8;
DROP TABLE IF EXISTS tblLibrarian8;
DROP TABLE IF EXISTS tblManager8;
DROP TABLE IF EXISTS tblUser8;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE tblUser8 (
    id           INT          NOT NULL AUTO_INCREMENT,
    username     VARCHAR(100) NOT NULL,
    password     VARCHAR(255) NOT NULL,
    fullName     VARCHAR(100) NOT NULL,
    dateOfBirth  DATE         NULL,
    address      VARCHAR(255) NULL,
    email        VARCHAR(100) NULL,
    phoneNumber  VARCHAR(20)  NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_tblUser8_username (username)
) ENGINE = InnoDB;

CREATE TABLE tblManager8 (
    userId       INT NOT NULL,
    employeeId   INT NOT NULL,
    PRIMARY KEY (userId),
    UNIQUE KEY uk_tblManager8_employeeId (employeeId),
    CONSTRAINT fk_tblManager8_user
        FOREIGN KEY (userId) REFERENCES tblUser8 (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE tblLibrarian8 (
    userId       INT NOT NULL,
    employeeId   INT NOT NULL,
    PRIMARY KEY (userId),
    UNIQUE KEY uk_tblLibrarian8_employeeId (employeeId),
    CONSTRAINT fk_tblLibrarian8_user
        FOREIGN KEY (userId) REFERENCES tblUser8 (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE tblReader8 (
    userId       INT         NOT NULL,
    readerId     INT         NOT NULL,
    readerStatus VARCHAR(30) NOT NULL,
    PRIMARY KEY (userId),
    UNIQUE KEY uk_tblReader8_readerId (readerId),
    CONSTRAINT fk_tblReader8_user
        FOREIGN KEY (userId) REFERENCES tblUser8 (id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE tblLibraryCard8 (
    cardId       INT         NOT NULL AUTO_INCREMENT,
    readerUserId  INT         NOT NULL,
    issueDate    DATE        NOT NULL,
    expiryDate   DATE        NOT NULL,
    status       VARCHAR(30) NOT NULL,
    PRIMARY KEY (cardId),
    UNIQUE KEY uk_tblLibraryCard8_reader (readerUserId),
    CONSTRAINT fk_tblLibraryCard8_reader
        FOREIGN KEY (readerUserId) REFERENCES tblReader8 (userId)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE tblSupplier8 (
    supplierId   INT          NOT NULL AUTO_INCREMENT,
    name         VARCHAR(150) NOT NULL,
    address      VARCHAR(255) NULL,
    phoneNumber  VARCHAR(20)  NULL,
    email        VARCHAR(100) NULL,
    description  TEXT         NULL,
    PRIMARY KEY (supplierId)
) ENGINE = InnoDB;

CREATE TABLE tblDocumentType8 (
    documentTypeId INT          NOT NULL AUTO_INCREMENT,
    title          VARCHAR(200) NOT NULL,
    author         VARCHAR(100) NULL,
    publisher      VARCHAR(150) NULL,
    publicationYear INT         NULL,
    description    TEXT         NULL,
    PRIMARY KEY (documentTypeId)
) ENGINE = InnoDB;

CREATE TABLE tblDocumentTypeCopy8 (
    copyId          INT         NOT NULL AUTO_INCREMENT,
    documentTypeId  INT         NOT NULL,
    status          VARCHAR(30) NOT NULL,
    copyCondition   VARCHAR(100) NULL,
    PRIMARY KEY (copyId),
    KEY ix_tblDocumentTypeCopy8_documentTypeId (documentTypeId),
    CONSTRAINT fk_tblDocumentTypeCopy8_documentType
        FOREIGN KEY (documentTypeId) REFERENCES tblDocumentType8 (documentTypeId)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE tblFineRecord8 (
    fineRecordId INT           NOT NULL AUTO_INCREMENT,
    fineDate     DATE          NOT NULL,
    reason       VARCHAR(255)  NOT NULL,
    fineAmount   DECIMAL(12,2) NOT NULL,
    status       VARCHAR(30)   NOT NULL,
    PRIMARY KEY (fineRecordId)
) ENGINE = InnoDB;

CREATE TABLE tblLoanRecord8 (
    loanRecordId   INT         NOT NULL AUTO_INCREMENT,
    readerUserId   INT         NOT NULL,
    librarianUserId INT         NOT NULL,
    loanDate       DATE        NOT NULL,
    status         VARCHAR(30) NOT NULL,
    PRIMARY KEY (loanRecordId),
    KEY ix_tblLoanRecord8_readerUserId (readerUserId),
    KEY ix_tblLoanRecord8_librarianUserId (librarianUserId),
    CONSTRAINT fk_tblLoanRecord8_reader
        FOREIGN KEY (readerUserId) REFERENCES tblReader8 (userId)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tblLoanRecord8_librarian
        FOREIGN KEY (librarianUserId) REFERENCES tblLibrarian8 (userId)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE tblLoanDetail8 (
    loanDetailId INT NOT NULL AUTO_INCREMENT,
    loanRecordId INT NOT NULL,
    copyId      INT NOT NULL,
    PRIMARY KEY (loanDetailId),
    UNIQUE KEY uk_tblLoanDetail8_record_copy (loanRecordId, copyId),
    KEY ix_tblLoanDetail8_copyId (copyId),
    CONSTRAINT fk_tblLoanDetail8_loanRecord
        FOREIGN KEY (loanRecordId) REFERENCES tblLoanRecord8 (loanRecordId)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tblLoanDetail8_copy
        FOREIGN KEY (copyId) REFERENCES tblDocumentTypeCopy8 (copyId)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE tblReturnRecord8 (
    returnRecordId INT  NOT NULL AUTO_INCREMENT,
    readerUserId   INT  NOT NULL,
    librarianUserId INT  NOT NULL,
    loanRecordId   INT  NOT NULL,
    returnDate     DATE NOT NULL,
    PRIMARY KEY (returnRecordId),
    KEY ix_tblReturnRecord8_readerUserId (readerUserId),
    KEY ix_tblReturnRecord8_librarianUserId (librarianUserId),
    KEY ix_tblReturnRecord8_loanRecordId (loanRecordId),
    CONSTRAINT fk_tblReturnRecord8_reader
        FOREIGN KEY (readerUserId) REFERENCES tblReader8 (userId)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tblReturnRecord8_librarian
        FOREIGN KEY (librarianUserId) REFERENCES tblLibrarian8 (userId)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tblReturnRecord8_loanRecord
        FOREIGN KEY (loanRecordId) REFERENCES tblLoanRecord8 (loanRecordId)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE tblReturnDetail8 (
    returnDetailId INT         NOT NULL AUTO_INCREMENT,
    returnRecordId INT         NOT NULL,
    loanDetailId   INT         NOT NULL,
    copyId         INT         NOT NULL,
    copyCondition  VARCHAR(100) NOT NULL,
    fineRecordId   INT         NULL,
    PRIMARY KEY (returnDetailId),
    UNIQUE KEY uk_tblReturnDetail8_loanDetail (loanDetailId),
    KEY ix_tblReturnDetail8_returnRecordId (returnRecordId),
    KEY ix_tblReturnDetail8_copyId (copyId),
    KEY ix_tblReturnDetail8_fineRecordId (fineRecordId),
    UNIQUE KEY uk_tblReturnDetail8_fineRecord (fineRecordId),
    CONSTRAINT fk_tblReturnDetail8_returnRecord
        FOREIGN KEY (returnRecordId) REFERENCES tblReturnRecord8 (returnRecordId)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tblReturnDetail8_loanDetail
        FOREIGN KEY (loanDetailId) REFERENCES tblLoanDetail8 (loanDetailId)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tblReturnDetail8_copy
        FOREIGN KEY (copyId) REFERENCES tblDocumentTypeCopy8 (copyId)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tblReturnDetail8_fine
        FOREIGN KEY (fineRecordId) REFERENCES tblFineRecord8 (fineRecordId)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE tblImportRecord8 (
    importRecordId  INT  NOT NULL AUTO_INCREMENT,
    supplierId      INT  NOT NULL,
    librarianUserId INT  NOT NULL,
    importDate      DATE NOT NULL,
    PRIMARY KEY (importRecordId),
    KEY ix_tblImportRecord8_supplierId (supplierId),
    KEY ix_tblImportRecord8_librarianUserId (librarianUserId),
    CONSTRAINT fk_tblImportRecord8_supplier
        FOREIGN KEY (supplierId) REFERENCES tblSupplier8 (supplierId)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tblImportRecord8_librarian
        FOREIGN KEY (librarianUserId) REFERENCES tblLibrarian8 (userId)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE tblImportDetail8 (
    importDetailId INT NOT NULL AUTO_INCREMENT,
    importRecordId INT NOT NULL,
    copyId        INT NOT NULL,
    quantity      INT NOT NULL,
    PRIMARY KEY (importDetailId),
    KEY ix_tblImportDetail8_importRecordId (importRecordId),
    KEY ix_tblImportDetail8_copyId (copyId),
    CONSTRAINT chk_tblImportDetail8_quantity CHECK (quantity > 0),
    CONSTRAINT fk_tblImportDetail8_importRecord
        FOREIGN KEY (importRecordId) REFERENCES tblImportRecord8 (importRecordId)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tblImportDetail8_copy
        FOREIGN KEY (copyId) REFERENCES tblDocumentTypeCopy8 (copyId)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = InnoDB;

-- UI code mapping keeps every model ID as INT:
-- documentTypeId 1 -> DT001, readerId 1 -> DG01, loanRecordId 1 -> PM001,
-- copyId 1 -> CP001, employeeId 1 -> NV01.
-- The UI derives these strings with LPAD; they are not stored as alternate IDs.

INSERT INTO tblUser8
    (id, username, password, fullName, dateOfBirth, address, email, phoneNumber)
VALUES
    (1,   'manager',   '123456', 'Nguyễn Văn Quản Lý', '1980-01-10', 'Hà Nội', 'manager@libman.local',   '0900000001'),
    (2,   'librarian', '123456', 'Trần Văn B',        '1985-02-20', 'Hà Nội', 'librarian@libman.local', '0900000002'),
    (101, 'reader01',  '123456', 'Nguyễn Văn An',     '2000-03-15', 'Hà Nội', 'an@libman.local',        '0900000101'),
    (102, 'reader02',  '123456', 'Trần Thị Phương',   '2001-04-16', 'Hà Nội', 'phuong@libman.local',    '0900000102'),
    (103, 'reader03',  '123456', 'Đinh Công Vinh',    '2000-05-17', 'Hà Nội', 'vinh@libman.local',      '0900000103');

INSERT INTO tblManager8 (userId, employeeId) VALUES (1, 1);
INSERT INTO tblLibrarian8 (userId, employeeId) VALUES (2, 2);

SELECT CONCAT('NV', LPAD(employeeId, 2, '0')) AS employeeCode,
       employeeId, userId, 'Manager8' AS roleName
FROM tblManager8
UNION ALL
SELECT CONCAT('NV', LPAD(employeeId, 2, '0')) AS employeeCode,
       employeeId, userId, 'Librarian8' AS roleName
FROM tblLibrarian8;

INSERT INTO tblReader8 (userId, readerId, readerStatus) VALUES
    (101, 1, 'Đang hoạt động'),
    (102, 2, 'Đang hoạt động'),
    (103, 3, 'Đang hoạt động');

INSERT INTO tblLibraryCard8 (cardId, readerUserId, issueDate, expiryDate, status) VALUES
    (1, 101, '2026-01-01', '2026-12-31', 'Còn hiệu lực'),
    (2, 102, '2026-01-01', '2026-12-31', 'Còn hiệu lực'),
    (3, 103, '2026-01-01', '2026-12-31', 'Còn hiệu lực');

INSERT INTO tblSupplier8 (supplierId, name, address, phoneNumber, email, description) VALUES
    (1, 'Nhà sách Đại học', 'Hà Nội', '0900000201', 'supplier@libman.local', 'Nhà cung cấp demo');

INSERT INTO tblDocumentType8
    (documentTypeId, title, author, publisher, publicationYear, description)
VALUES
    (1, 'Lập trình Java',  'Nguyễn Văn A', 'NXB Giáo Dục', 2024, 'Giáo trình nhập môn lập trình Java cho sinh viên đại học.'),
    (2, 'Cơ sở dữ liệu',   'Trần Văn B',   'NXB Khoa Học', 2023, 'Giáo trình'),
    (3, 'Mạng máy tính',   'Lê Công C',    'NXB Bách Khoa', 2022, 'Sách');

-- Ten physical copies have their own copyId. PM001 uses CP001..CP004:
-- DT001 x1, DT002 x1, DT003 x2, which renders as three titles with 1, 1, 2.
INSERT INTO tblDocumentTypeCopy8
    (copyId, documentTypeId, status, copyCondition)
VALUES
    (1,  1, 'Sẵn có',     'Tốt'),
    (2,  2, 'Sẵn có',     'Tốt'),
    (3,  3, 'Sẵn có',     'Tốt'),
    (4,  3, 'Sẵn có',     'Tốt'),
    (5,  1, 'Đang mượn',  'Tốt'),
    (6,  2, 'Sẵn có',     'Tốt'),
    (7,  3, 'Sẵn có',     'Tốt'),
    (8,  1, 'Sẵn có',     'Tốt'),
    (9,  2, 'Sẵn có',     'Tốt'),
    (10, 3, 'Sẵn có',     'Tốt');

-- All six demo borrowings are in October 2026: DG01=3, DG02=2, DG03=1.
INSERT INTO tblLoanRecord8
    (loanRecordId, readerUserId, librarianUserId, loanDate, status)
VALUES
    (1, 101, 2, '2026-10-02', 'Đã trả'),
    (2, 101, 2, '2026-10-09', 'Đã trả'),
    (3, 101, 2, '2026-10-21', 'Quá hạn'),
    (4, 102, 2, '2026-10-05', 'Đã trả'),
    (5, 102, 2, '2026-10-15', 'Đã trả'),
    (6, 103, 2, '2026-10-12', 'Đã trả');

INSERT INTO tblLoanDetail8
    (loanDetailId, loanRecordId, copyId)
VALUES
    -- PM001: DT001 x1, DT002 x1, DT003 x2
    (1,  1,  1),
    (2,  1,  2),
    (3,  1,  3),
    (4,  1,  4),
    -- Other demo history rows
    (5,  2,  5),
    (6,  2,  6),
    (7,  3,  5),
    (8,  4,  8),
    (9,  5,  9),
    (10, 6, 10);

-- Return history shown by the Manager UI.
INSERT INTO tblReturnRecord8
    (returnRecordId, readerUserId, librarianUserId, loanRecordId, returnDate)
VALUES
    (1, 101, 2, 1, '2026-10-12'),
    (2, 101, 2, 2, '2026-10-19');

INSERT INTO tblReturnDetail8
    (returnDetailId, returnRecordId, loanDetailId, copyId, copyCondition, fineRecordId)
VALUES
    (1, 1,  1,  1, 'Tốt', NULL),
    (2, 1,  2,  2, 'Tốt', NULL),
    (3, 1,  3,  3, 'Tốt', NULL),
    (4, 1,  4,  4, 'Tốt', NULL),
    (5, 2,  5,  5, 'Tốt', NULL),
    (6, 2,  6,  6, 'Tốt', NULL);

-- Verification queries used by the two UI modules.
-- Reader counts must be: DG01=3, DG02=2, DG03=1.
SELECT CONCAT('DG', LPAD(r.readerId, 2, '0')) AS readerCode,
       r.readerId, u.fullName, COUNT(l.loanRecordId) AS borrowingCount
FROM tblReader8 r
JOIN tblUser8 u ON u.id = r.userId
LEFT JOIN tblLoanRecord8 l ON l.readerUserId = r.userId
    AND l.loanDate BETWEEN '2026-10-01' AND '2026-10-31'
GROUP BY r.readerId, u.fullName
ORDER BY r.readerId;

-- BorrowHistoryUI8 derives dueDate as loanDate + 10 days:
-- PM001 02/10 -> 12/10, PM002 09/10 -> 19/10, PM003 21/10 -> 31/10.
SELECT CONCAT('PM', LPAD(loanRecordId, 3, '0')) AS loanCode,
       loanDate,
       DATE_ADD(loanDate, INTERVAL 10 DAY) AS dueDate,
       status
FROM tblLoanRecord8
WHERE loanDate BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY loanRecordId;

-- PM001 must return four rows and three grouped titles with quantities 1,1,2.
SELECT CONCAT('PM', LPAD(l.loanRecordId, 3, '0')) AS loanCode,
       CONCAT('CP', LPAD(c.copyId, 3, '0')) AS copyCode,
       CONCAT('DT', LPAD(d.documentTypeId, 3, '0')) AS documentCode,
       l.loanRecordId, c.copyId, d.documentTypeId, d.title
FROM tblLoanDetail8 l
JOIN tblDocumentTypeCopy8 c ON c.copyId = l.copyId
JOIN tblDocumentType8 d ON d.documentTypeId = c.documentTypeId
WHERE l.loanRecordId = 1
ORDER BY d.documentTypeId, c.copyId;

SELECT CONCAT('DT', LPAD(d.documentTypeId, 3, '0')) AS documentCode,
       d.title, COUNT(*) AS quantity
FROM tblLoanDetail8 l
JOIN tblDocumentTypeCopy8 c ON c.copyId = l.copyId
JOIN tblDocumentType8 d ON d.documentTypeId = c.documentTypeId
WHERE l.loanRecordId = 1
GROUP BY d.documentTypeId, d.title
ORDER BY d.documentTypeId;
