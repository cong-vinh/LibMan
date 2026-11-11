package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.LoanDetail8;

public class LoanDetailDAO8 extends DAO8 {
    public LoanDetailDAO8() {
        super();
    }

    public LoanDetail8[] getDetailsByLoan(int loanRecordId) {
        String sql = "SELECT ld.loanDetailId, ld.copyId, "
                + "c.status AS copyStatus, c.copyCondition, "
                + "d.documentTypeId, d.title, d.author, d.publisher, "
                + "d.publicationYear, d.description "
                + "FROM tblLoanDetail8 ld "
                + "JOIN tblDocumentTypeCopy8 c ON c.copyId = ld.copyId "
                + "JOIN tblDocumentType8 d ON d.documentTypeId = c.documentTypeId "
                + "WHERE ld.loanRecordId = ? ORDER BY ld.loanDetailId ASC";
        List<LoanDetail8> result = new ArrayList<LoanDetail8>();
        try (PreparedStatement statement = getConnection().prepareStatement(sql)) {
            statement.setInt(1, loanRecordId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    // The UML LoanDetail8 exposes the detail and physical copy IDs;
                    // the joins above validate and fetch the related copy/title rows.
                    result.add(new LoanDetail8(rs.getInt("loanDetailId"), rs.getInt("copyId")));
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Cannot load details for loan " + loanRecordId, e);
        }
        return result.toArray(new LoanDetail8[result.size()]);
    }
}
