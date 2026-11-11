<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.DocumentTypeDAO8" %>
<%@ page import="model.DocumentType8" %>
<%@ include file="../WEB-INF/jspf/access.jspf" %>
<%
    String readerId = request.getParameter("readerId");
    if (readerId == null) {
        readerId = "";
    }
    boolean readerAllowed = hasReaderAccess(readerId);
    String keyword = request.getParameter("keyword");
    if (keyword == null) {
        keyword = "";
    }

    DocumentType8[] resultList = new DocumentType8[0];
    String message = readerAllowed ? "" : "Mã bạn đọc không hợp lệ hoặc bạn không có quyền truy cập.";
    boolean searched = request.getParameter("keyword") != null;
    if (searched) {
        String searchKeyword = keyword.trim();
        if (!readerAllowed) {
            message = "Mã bạn đọc không hợp lệ hoặc bạn không có quyền truy cập.";
        } else if (searchKeyword.length() == 0) {
            message = "Vui lòng nhập từ khóa tìm kiếm.";
        } else {
            DocumentTypeDAO8 documentTypeDAO = new DocumentTypeDAO8();
            try {
                resultList = documentTypeDAO.searchByName(searchKeyword);
                if (resultList.length == 0) {
                    message = "Không tìm thấy tài liệu có tên khớp với từ khóa.";
                }
            } catch (RuntimeException e) {
                message = "Không thể tìm kiếm tài liệu từ cơ sở dữ liệu.";
            } finally {
                documentTypeDAO.closeConnection();
            }
        }
    }
%>
<%@ include file="../header.jsp" %>
<section class="panel">
    <h2>Tìm kiếm tài liệu</h2>
    <form method="get" onsubmit="return searchDocument();">
        <input type="hidden" id="readerId" name="readerId" value="<%= h(readerId) %>">
        <label for="keyword">Từ khóa tên tài liệu</label>
        <input id="keyword" name="keyword" type="text" value="<%= h(keyword) %>" autocomplete="off">
        <button type="submit" <%= readerAllowed ? "" : "disabled" %>>Tìm kiếm</button>
    </form>
    <p id="message" class="message"><%= h(message) %></p>

    <h3>Danh sách tài liệu tìm được</h3>
    <div id="resultList">
        <% if (resultList.length > 0) { %>
            <table>
                <thead>
                <tr>
                    <th>Mã tài liệu</th>
                    <th>Tên tài liệu</th>
                    <th>Tác giả</th>
                    <th>Nhà xuất bản</th>
                    <th>Năm xuất bản</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <% for (DocumentType8 documentType : resultList) { %>
                    <tr>
                        <td class="code-cell">DT<%= String.format("%03d", documentType.getDocumentTypeId()) %></td>
                        <td><%= h(documentType.getTitle()) %></td>
                        <td><%= h(documentType.getAuthor()) %></td>
                        <td><%= h(documentType.getPublisher()) %></td>
                        <td class="number-cell"><%= documentType.getPublicationYear() %></td>
                        <td>
                            <button type="button" onclick="chooseDocument(<%= documentType.getDocumentTypeId() %>)">
                                Xem chi tiết
                            </button>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</section>
<script>
function enterKeyword() {
    return document.getElementById('keyword').value.trim();
}

function searchDocument() {
    var value = enterKeyword();
    if (!value) {
        document.getElementById('message').textContent = 'Vui lòng nhập từ khóa tìm kiếm.';
        return false;
    }
    return true;
}

function displayResults() {
    var resultList = document.getElementById('resultList');
    if (resultList) resultList.hidden = false;
    return resultList;
}

function chooseDocument(documentTypeId) {
    var readerId = document.getElementById('readerId').value;
    var keyword = document.getElementById('keyword').value;
    var url = 'DocumentDetailUI8.jsp?selectedDocumentTypeId='
            + encodeURIComponent(documentTypeId);
    if (readerId) url += '&readerId=' + encodeURIComponent(readerId);
    if (keyword) url += '&keyword=' + encodeURIComponent(keyword);
    window.location = url;
}

displayResults();
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
