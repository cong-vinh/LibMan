package unittest;

import java.sql.Date;
import dao.DocumentTypeCopyDAO8;
import dao.DocumentTypeDAO8;
import dao.LoanDetailDAO8;
import dao.LoanRecordDAO8;
import dao.ReaderStatisticDAO8;
import model.DocumentType8;
import model.DocumentTypeCopy8;
import model.LoanDetail8;
import model.LoanRecord8;
import model.ReaderBorrowStatistics8;

/**
 * Small JDBC integration test for every DAO. Run after importing database/libman.sql.
 * Connection settings are the same as DAO8 (system properties or LIBMAN_DB_* env vars).
 */
public final class DaoIntegrationTest8 {
    private static final Date OCTOBER_1 = Date.valueOf("2026-10-01");
    private static final Date OCTOBER_31 = Date.valueOf("2026-10-31");

    private DaoIntegrationTest8() {
    }

    public static void main(String[] args) {
        testDocumentTypeDAO();
        testDocumentTypeCopyDAO();
        testReaderStatisticDAO();
        testLoanRecordDAO();
        testLoanDetailDAO();
        System.out.println("DaoIntegrationTest8: all DAO tests passed");
    }

    private static void testDocumentTypeDAO() {
        DocumentTypeDAO8 dao = new DocumentTypeDAO8();
        try {
            DocumentType8[] matches = dao.searchByName("Java");
            require(matches.length == 1 && matches[0].getDocumentTypeId() == 1,
                    "DocumentTypeDAO8.searchByName");
            DocumentType8 type = dao.getById(1);
            require(type != null && "Lập trình Java".equals(type.getTitle()),
                    "DocumentTypeDAO8.getById");
        } finally {
            dao.closeConnection();
        }
    }

    private static void testDocumentTypeCopyDAO() {
        DocumentTypeCopyDAO8 dao = new DocumentTypeCopyDAO8();
        try {
            DocumentTypeCopy8[] copies = dao.getByDocumentTypeId(1);
            require(copies.length == 3 && copies[0].getCopyId() == 1,
                    "DocumentTypeCopyDAO8.getByDocumentTypeId");
        } finally {
            dao.closeConnection();
        }
    }

    private static void testReaderStatisticDAO() {
        ReaderStatisticDAO8 dao = new ReaderStatisticDAO8();
        try {
            ReaderBorrowStatistics8[] stats = dao.getReaderStatistics(OCTOBER_1, OCTOBER_31);
            require(stats.length == 3, "ReaderStatisticDAO8 row count");
            require(stats[0].getReaderId() == 1 && stats[0].getNumberOfBorrows() == 3,
                    "ReaderStatisticDAO8 DG01");
            require(stats[1].getReaderId() == 2 && stats[1].getNumberOfBorrows() == 2,
                    "ReaderStatisticDAO8 DG02");
            require(stats[2].getReaderId() == 3 && stats[2].getNumberOfBorrows() == 1,
                    "ReaderStatisticDAO8 DG03");
        } finally {
            dao.closeConnection();
        }
    }

    private static void testLoanRecordDAO() {
        LoanRecordDAO8 dao = new LoanRecordDAO8();
        try {
            LoanRecord8[] loans = dao.getLoansByReader(1, OCTOBER_1, OCTOBER_31);
            require(loans.length == 3 && loans[0].getLoanRecordId() == 3,
                    "LoanRecordDAO8.getLoansByReader descending order");
            LoanRecord8 loan = dao.getById(1);
            require(loan != null && Date.valueOf("2026-10-02").equals(loan.getLoanDate()),
                    "LoanRecordDAO8.getById");
        } finally {
            dao.closeConnection();
        }
    }

    private static void testLoanDetailDAO() {
        LoanDetailDAO8 dao = new LoanDetailDAO8();
        try {
            LoanDetail8[] details = dao.getDetailsByLoan(1);
            require(details.length == 4 && details[0].getCopyId() == 1
                    && details[3].getCopyId() == 4,
                    "LoanDetailDAO8.getDetailsByLoan");
        } finally {
            dao.closeConnection();
        }
    }

    private static void require(boolean condition, String operation) {
        if (!condition) {
            throw new AssertionError("DAO test failed: " + operation);
        }
    }
}
