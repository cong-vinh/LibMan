package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.DocumentType8;

public class DocumentTypeDAO8 extends DAO8 {
    public DocumentTypeDAO8() {
        super();
    }

    public DocumentType8[] searchByName(String keyword) {
        String sql = "SELECT documentTypeId, title, author, publisher, publicationYear, description "
                + "FROM tblDocumentType8 WHERE LOWER(title) LIKE LOWER(?) "
                + "ORDER BY title ASC, documentTypeId ASC";
        List<DocumentType8> result = new ArrayList<DocumentType8>();
        try (PreparedStatement statement = getConnection().prepareStatement(sql)) {
            statement.setString(1, "%" + (keyword == null ? "" : keyword) + "%");
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    result.add(readDocumentType(rs));
                }
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Cannot search document types by title", e);
        }
        return result.toArray(new DocumentType8[result.size()]);
    }

    public DocumentType8 getById(int documentTypeId) {
        String sql = "SELECT documentTypeId, title, author, publisher, publicationYear, description "
                + "FROM tblDocumentType8 WHERE documentTypeId = ?";
        try (PreparedStatement statement = getConnection().prepareStatement(sql)) {
            statement.setInt(1, documentTypeId);
            try (ResultSet rs = statement.executeQuery()) {
                return rs.next() ? readDocumentType(rs) : null;
            }
        } catch (SQLException e) {
            throw new IllegalStateException("Cannot load document type " + documentTypeId, e);
        }
    }

    private DocumentType8 readDocumentType(ResultSet rs) throws SQLException {
        return new DocumentType8(rs.getInt("documentTypeId"), rs.getString("title"),
                rs.getString("author"), rs.getString("publisher"),
                rs.getInt("publicationYear"), rs.getString("description"), null);
    }
}
