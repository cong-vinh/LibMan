package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.DocumentTypeCopy8;

public class DocumentTypeCopyDAO8 extends DAO8 {
    public DocumentTypeCopyDAO8() {
        super();
    }

    public DocumentTypeCopy8[] getByDocumentTypeId(int documentTypeId) {
        String sql = "SELECT c.copyId, c.status, c.copyCondition, "
                + "d.documentTypeId, d.title, d.author, d.publisher, d.publicationYear, d.description "
                + "FROM tblDocumentTypeCopy8 c "
                + "JOIN tblDocumentType8 d ON d.documentTypeId = c.documentTypeId "
                + "WHERE c.documentTypeId = ? "
                + "ORDER BY c.copyId ASC";
        List<DocumentTypeCopy8> result = new ArrayList<DocumentTypeCopy8>();
        try (PreparedStatement statement = getConnection().prepareStatement(sql)) {
            statement.setInt(1, documentTypeId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    result.add(new DocumentTypeCopy8(rs.getInt("copyId"),
                            rs.getString("status"), rs.getString("copyCondition"),
                            null, null, null));
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Cannot load copies for document type " + documentTypeId, e);
        }
        return result.toArray(new DocumentTypeCopy8[result.size()]);
    }
}
