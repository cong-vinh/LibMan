package dao;

import java.util.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ReaderBorrowStatistics8;

public class ReaderStatisticDAO8 extends DAO8 {
    public ReaderStatisticDAO8() {
        super();
    }

    public ReaderBorrowStatistics8[] getReaderStatistics(Date fromDate, Date toDate) {
        if (fromDate == null || toDate == null) {
            throw new IllegalArgumentException("fromDate and toDate are required");
        }
        String sql = "SELECT r.readerId, r.readerStatus, "
                + "u.id AS userId, u.username, u.password, u.fullName, u.dateOfBirth, "
                + "u.address, u.email, u.phoneNumber, "
                + "COUNT(DISTINCT l.loanRecordId) AS numberOfBorrows "
                + "FROM tblReader8 r JOIN tblUser8 u ON u.id = r.userId "
                + "LEFT JOIN tblLoanRecord8 l ON l.readerUserId = r.userId "
                + "AND l.loanDate BETWEEN ? AND ? "
                + "GROUP BY r.readerId, r.readerStatus, u.id, u.username, u.password, "
                + "u.fullName, u.dateOfBirth, u.address, u.email, u.phoneNumber "
                + "ORDER BY numberOfBorrows DESC, r.readerId ASC";
        List<ReaderBorrowStatistics8> result = new ArrayList<ReaderBorrowStatistics8>();
        try (PreparedStatement statement = getConnection().prepareStatement(sql)) {
            statement.setDate(1, toSqlDate(fromDate));
            statement.setDate(2, toSqlDate(toDate));
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    ReaderBorrowStatistics8 statistics = new ReaderBorrowStatistics8();
                    statistics.setId(rs.getInt("userId"));
                    statistics.setUsername(rs.getString("username"));
                    statistics.setPassword(rs.getString("password"));
                    statistics.setFullName(rs.getString("fullName"));
                    statistics.setDateOfBirth(rs.getDate("dateOfBirth"));
                    statistics.setAddress(rs.getString("address"));
                    statistics.setEmail(rs.getString("email"));
                    statistics.setPhoneNumber(rs.getString("phoneNumber"));
                    statistics.setReaderId(rs.getInt("readerId"));
                    statistics.setReaderStatus(rs.getString("readerStatus"));
                    statistics.setNumberOfBorrows(rs.getInt("numberOfBorrows"));
                    statistics.setFromDate(fromDate);
                    statistics.setToDate(toDate);
                    result.add(statistics);
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Cannot calculate reader borrowing statistics", e);
        }
        return result.toArray(new ReaderBorrowStatistics8[result.size()]);
    }
}
