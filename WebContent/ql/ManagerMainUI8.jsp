<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../WEB-INF/jspf/access.jspf" %>
<%
    String employeeId = request.getParameter("employeeId");
    if (employeeId == null) employeeId = "";
    boolean managerAllowed = hasManagerAccess(employeeId);
    if (!managerAllowed) employeeId = "";
    String[] menuItems = new String[] { "Xem báo cáo" };
%>
<%@ include file="../header.jsp" %>
<section class="panel">
    <h2>Trang chính quản lý</h2>
    <p>Giao diện chính của nhân viên quản lý thư viện.</p>
    <form action="ReportMenuUI8.jsp" method="get">
        <label for="employeeId">Mã nhân viên</label>
        <input class="readonly-field" id="employeeId" type="text"
               value="<%= h(employeeId) %>" disabled>
        <input type="hidden" name="employeeId" value="<%= h(employeeId) %>">
        <button type="submit" name="openReportMenu" <%= managerAllowed ? "" : "disabled" %>>Xem báo cáo</button>
    </form>
    <% if (!managerAllowed) { %>
        <p class="message">Mã nhân viên quản lý không hợp lệ hoặc bạn không có quyền truy cập.</p>
    <% } %>
</section>
<script>
function openReportMenu() {
    document.querySelector('form').submit();
}
</script>
</main>
</body>
</html>
<%!
private String h(Object value) {
    if (value == null) return "";
    return value.toString().replace("&", "&amp;").replace("<", "&lt;")
            .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
}
%>
