package dao;

import java.util.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.LoanRecord8;

public class LoanRecordDAO8 extends DAO8 {
    public LoanRecordDAO8() {
        super();
    }

    public LoanRecord8[] getLoansByReader(int readerId, Date fromDate, Date toDate) {
        requireDateRange(fromDate, toDate);
        String sql = baseSelect()
                + " WHERE r.readerId = ? AND l.loanDate BETWEEN ? AND ?"
                + " ORDER BY l.loanDate DESC, l.loanRecordId DESC";
        List<LoanRecord8> result = new ArrayList<LoanRecord8>();
        try (PreparedStatement statement = getConnection().prepareStatement(sql)) {
            statement.setInt(1, readerId);
            statement.setDate(2, toSqlDate(fromDate));
            statement.setDate(3, toSqlDate(toDate));
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    result.add(readLoan(rs));
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Cannot load loans for reader " + readerId, e);
        }
        return result.toArray(new LoanRecord8[result.size()]);
    }

    public LoanRecord8 getById(int loanRecordId) {
        String sql = baseSelect() + " WHERE l.loanRecordId = ?";
        try (PreparedStatement statement = getConnection().prepareStatement(sql)) {
            statement.setInt(1, loanRecordId);
            try (ResultSet rs = statement.executeQuery()) {
                return rs.next() ? readLoan(rs) : null;
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Cannot load loan record " + loanRecordId, e);
        }
    }

    private String baseSelect() {
        return "SELECT l.loanRecordId, l.loanDate, l.status, "
                + "r.readerId, ru.id AS readerUserId, ru.fullName AS readerName, "
                + "lb.employeeId AS librarianEmployeeId, lu.id AS librarianUserId, "
                + "lu.fullName AS librarianName "
                + "FROM tblLoanRecord8 l "
                + "JOIN tblReader8 r ON r.userId = l.readerUserId "
                + "JOIN tblUser8 ru ON ru.id = r.userId "
                + "JOIN tblLibrarian8 lb ON lb.userId = l.librarianUserId "
                + "JOIN tblUser8 lu ON lu.id = lb.userId";
    }

    private LoanRecord8 readLoan(ResultSet rs) throws SQLException {
        return new LoanRecord8(rs.getInt("loanRecordId"), rs.getDate("loanDate"),
                rs.getString("status"), null);
    }

    private void requireDateRange(Date fromDate, Date toDate) {
        if (fromDate == null || toDate == null) {
            throw new IllegalArgumentException("fromDate and toDate are required");
        }
        if (fromDate.after(toDate)) {
            throw new IllegalArgumentException("fromDate must not be after toDate");
        }
    }
}
