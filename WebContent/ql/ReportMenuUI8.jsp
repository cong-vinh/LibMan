<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../WEB-INF/jspf/access.jspf" %>
<%
    String employeeId = request.getParameter("employeeId");
    if (employeeId == null) employeeId = "";
    boolean managerAllowed = hasManagerAccess(employeeId);
    if (!managerAllowed) employeeId = "";
    String[] reportCategories = new String[] { "Thống kê độc giả theo số lần mượn" };
%>
<%@ include file="../header.jsp" %>
<section class="panel">
    <h2>Danh mục báo cáo</h2>
    <label for="employeeId">Mã nhân viên</label>
    <input class="readonly-field" id="employeeId" type="text" value="<%= h(employeeId) %>" disabled>
    <p>Các loại báo cáo</p>
    <form action="ReaderStatisticUI8.jsp" method="get">
        <input type="hidden" name="employeeId" value="<%= h(employeeId) %>">
        <button type="submit" name="chooseStatistics" <%= managerAllowed ? "" : "disabled" %>>Thống kê độc giả theo số lần mượn</button>
    </form>
    <button type="button" onclick="backToMain()">Quay lại</button>
    <% if (!managerAllowed) { %>
        <p class="message">Mã nhân viên quản lý không hợp lệ hoặc bạn không có quyền truy cập.</p>
    <% } %>
</section>
<script>
function chooseStatistics() {
    document.querySelector('form').submit();
}
function backToMain() {
    var employeeId = document.getElementById('employeeId').value;
    var url = 'ManagerMainUI8.jsp';
    if (employeeId) url += '?employeeId=' + encodeURIComponent(employeeId);
    window.location = url;
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
