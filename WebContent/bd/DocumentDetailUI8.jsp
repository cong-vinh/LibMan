<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.DocumentTypeCopyDAO8" %>
<%@ page import="dao.DocumentTypeDAO8" %>
<%@ page import="model.DocumentType8" %>
<%@ page import="model.DocumentTypeCopy8" %>
<%@ include file="../WEB-INF/jspf/access.jspf" %>
<%
    String selectedDocumentTypeId = request.getParameter("selectedDocumentTypeId");
    if (selectedDocumentTypeId == null) {
        selectedDocumentTypeId = "";
    }
    String readerId = request.getParameter("readerId");
    if (readerId == null) {
        readerId = "";
    }
    boolean readerAllowed = hasReaderAccess(readerId);
    String keyword = request.getParameter("keyword");
    if (keyword == null) {
        keyword = "";
    }

    DocumentType8 selectedDocument = null;
    DocumentTypeCopy8[] copies = new DocumentTypeCopy8[0];
    String message = "";
    try {
        if (!readerAllowed) {
            message = "Mã bạn đọc không hợp lệ hoặc bạn không có quyền truy cập.";
        } else {
        if (selectedDocumentTypeId.trim().length() == 0) {
            message = "Chưa có mã tài liệu được chọn.";
        } else {
            int documentTypeId = Integer.parseInt(selectedDocumentTypeId);
            DocumentTypeDAO8 documentTypeDAO = new DocumentTypeDAO8();
            try {
                selectedDocument = documentTypeDAO.getById(documentTypeId);
            } finally {
                documentTypeDAO.closeConnection();
            }
            if (selectedDocument == null) {
                message = "Không tìm thấy tài liệu trong cơ sở dữ liệu.";
            } else {
                DocumentTypeCopyDAO8 copyDAO = new DocumentTypeCopyDAO8();
                try {
                    copies = copyDAO.getByDocumentTypeId(documentTypeId);
                } finally {
                    copyDAO.closeConnection();
                }
            }
        }
        }
    } catch (NumberFormatException e) {
        message = "Mã tài liệu được chọn không hợp lệ.";
    } catch (RuntimeException e) {
        message = "Không thể đọc chi tiết tài liệu từ cơ sở dữ liệu.";
    }
%>
<%@ include file="../header.jsp" %>
<section class="panel">
    <h2>Chi tiết tài liệu</h2>
    <input type="hidden" id="readerId" value="<%= h(readerId) %>">
    <input type="hidden" id="keyword" value="<%= h(keyword) %>">
    <label for="selectedDocumentTypeId">Mã tài liệu đã chọn</label>
    <input class="readonly-field" id="selectedDocumentTypeId" name="selectedDocumentTypeId" type="text"
           value="<%= h(selectedDocumentTypeId) %>" disabled>

    <p id="message" class="message"><%= h(message) %></p>
    <% if (selectedDocument != null) { %>
        <div id="documentDetail">
            <h3><%= h(selectedDocument.getTitle()) %></h3>
            <p><strong>Tác giả:</strong> <%= h(selectedDocument.getAuthor()) %></p>
            <p><strong>Nhà xuất bản:</strong> <%= h(selectedDocument.getPublisher()) %></p>
            <p><strong>Năm xuất bản:</strong> <%= selectedDocument.getPublicationYear() %></p>
            <p><strong>Mô tả:</strong> <%= h(selectedDocument.getDescription()) %></p>
        </div>

        <h3>Bản sao tài liệu</h3>
        <div id="copies">
            <% if (copies.length == 0) { %>
                <p class="message">Tài liệu chưa có bản sao.</p>
            <% } else { %>
                <table>
                    <thead>
                    <tr>
                        <th>Mã bản sao</th>
                        <th>Trạng thái</th>
                        <th>Tình trạng</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (DocumentTypeCopy8 copy : copies) { %>
                        <tr>
                            <td class="code-cell">CP<%= String.format("%03d", copy.getCopyId()) %></td>
                            <td><%= h(copy.getStatus()) %></td>
                            <td><%= h(copy.getCopyCondition()) %></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    <% } %>
    <button type="button" onclick="backToResults()">Quay lại kết quả tìm kiếm</button>
</section>
<script>
function displayDocumentDetail() {
    var documentDetail = document.getElementById('documentDetail');
    if (documentDetail) documentDetail.hidden = false;
    return documentDetail;
}

function backToResults() {
    var readerId = document.getElementById('readerId').value;
    var keyword = document.getElementById('keyword').value;
    var url = 'SearchDocumentUI8.jsp';
    var query = [];
    if (readerId) query.push('readerId=' + encodeURIComponent(readerId));
    if (keyword) query.push('keyword=' + encodeURIComponent(keyword));
    if (query.length) url += '?' + query.join('&');
    window.location = url;
}

displayDocumentDetail();
</script>
</main>
</body>
</html>

<%!
private String h(Object value) {
    if (value == null) return "";
    return value.toString().replace("&", "&amp;")
            .replace("<", "&lt;").replace(">", "&gt;")
            .replace("\"", "&quot;").replace("'", "&#39;");
}
%>
