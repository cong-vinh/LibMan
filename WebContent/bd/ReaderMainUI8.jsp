<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../WEB-INF/jspf/access.jspf" %>
<%
    String readerId = request.getParameter("readerId");
    if (readerId == null) {
        readerId = "";
    }
    boolean readerAllowed = hasReaderAccess(readerId);
    if (!readerAllowed) readerId = "";
%>
<%@ include file="../header.jsp" %>
<section class="panel">
    <h2>Trang chính bạn đọc</h2>
    <p>Chào mừng bạn đọc. Chọn chức năng tìm kiếm tài liệu.</p>
    <form action="SearchDocumentUI8.jsp" method="get">
        <input type="hidden" id="readerId" name="readerId" value="<%= h(readerId) %>">
        <button type="submit" name="openSearchPage" <%= readerAllowed ? "" : "disabled" %>>Tìm kiếm tài liệu</button>
    </form>
    <% if (!readerAllowed) { %>
        <p class="message">Mã bạn đọc không hợp lệ hoặc bạn không có quyền truy cập.</p>
    <% } %>
</section>
<script>
function openSearchPage() {
    document.querySelector('form').submit();
}
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
