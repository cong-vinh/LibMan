<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="dao.ReaderStatisticDAO8" %>
<%@ page import="model.ReaderBorrowStatistics8" %>
<%@ include file="../WEB-INF/jspf/access.jspf" %>
<%
    String employeeId = request.getParameter("employeeId");
    if (employeeId == null) employeeId = "";
    boolean managerAllowed = hasManagerAccess(employeeId);
    String fromDateText = request.getParameter("fromDate");
    if (fromDateText == null) fromDateText = "";
    String toDateText = request.getParameter("toDate");
    if (toDateText == null) toDateText = "";
    String readerKeyword = request.getParameter("readerKeyword");
    if (readerKeyword == null) readerKeyword = "";

    List<ReaderBorrowStatistics8> filteredResults = new ArrayList<ReaderBorrowStatistics8>();
    ReaderBorrowStatistics8[] resultList = new ReaderBorrowStatistics8[0];
    String message = "";
    boolean selectedDateRange = request.getParameter("fromDate") != null
            || request.getParameter("toDate") != null;
    Date fromDate = null;
    Date toDate = null;
    if (!managerAllowed) {
        message = "Mã nhân viên quản lý không hợp lệ hoặc bạn không có quyền truy cập.";
    } else if (selectedDateRange) {
        if (fromDateText.trim().length() == 0 || toDateText.trim().length() == 0) {
            message = "Vui lòng chọn đủ ngày bắt đầu và ngày kết thúc.";
        } else {
            try {
                fromDate = Date.valueOf(fromDateText);
                toDate = Date.valueOf(toDateText);
                if (fromDate.after(toDate)) {
                    message = "Ngày bắt đầu không được lớn hơn ngày kết thúc.";
                } else {
                    ReaderStatisticDAO8 statisticDAO = new ReaderStatisticDAO8();
                    try {
                        ReaderBorrowStatistics8[] statistics =
                                statisticDAO.getReaderStatistics(fromDate, toDate);
                        String filter = readerKeyword.trim().toLowerCase(Locale.ROOT);
                        for (ReaderBorrowStatistics8 statistic : statistics) {
                            if (filter.length() == 0
                                    || (statistic.getFullName() != null
                                    && statistic.getFullName().toLowerCase(Locale.ROOT).contains(filter))) {
                                filteredResults.add(statistic);
                            }
                        }
                        resultList = filteredResults.toArray(new ReaderBorrowStatistics8[filteredResults.size()]);
                        if (resultList.length == 0) {
                            message = "Không có dữ liệu độc giả trong khoảng ngày đã chọn.";
                        }
                    } finally {
                        statisticDAO.closeConnection();
                    }
                }
            } catch (IllegalArgumentException e) {
                message = "Ngày phải có định dạng yyyy-MM-dd hợp lệ.";
            } catch (RuntimeException e) {
                message = "Không thể đọc thống kê từ cơ sở dữ liệu.";
            }
        }
    }
%>
<%@ include file="../header.jsp" %>
<section class="panel">
    <h2>Thống kê độc giả</h2>
    <label for="employeeId">Mã nhân viên</label>
    <input class="readonly-field" id="employeeId" type="text" value="<%= h(employeeId) %>" disabled>
    <form method="get" onsubmit="return selectDateRange();">
        <input type="hidden" name="employeeId" value="<%= h(employeeId) %>">
        <label for="fromDate">Từ ngày</label>
        <input id="fromDate" name="fromDate" type="date" value="<%= h(fromDateText) %>">
        <label for="toDate">Đến ngày</label>
        <input id="toDate" name="toDate" type="date" value="<%= h(toDateText) %>">
        <label for="readerKeyword">Tên độc giả</label>
        <input id="readerKeyword" name="readerKeyword" type="text" value="<%= h(readerKeyword) %>">
        <button type="submit" <%= managerAllowed ? "" : "disabled" %>>Xem thống kê</button>
    </form>
    <p id="message" class="message"><%= h(message) %></p>
    <div id="resultList">
        <% if (resultList.length > 0) { %>
            <table>
                <thead><tr><th>Mã độc giả</th><th>Họ tên</th><th>Trạng thái</th><th>Số lượt mượn</th></tr></thead>
                <tbody>
                <% for (ReaderBorrowStatistics8 statistic : resultList) { %>
                    <tr>
                        <td class="code-cell"><a class="table-link" href="#" onclick="chooseReader(<%= statistic.getReaderId() %>); return false;">DG<%= String.format("%02d", statistic.getReaderId()) %></a></td>
                        <td><a class="table-link" href="#" onclick="chooseReader(<%= statistic.getReaderId() %>); return false;"><%= h(statistic.getFullName()) %></a></td>
                        <td><%= h(statistic.getReaderStatus()) %></td>
                        <td class="number-cell"><%= statistic.getNumberOfBorrows() %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
    <button type="button" onclick="backToReportMenu()">Quay lại</button>
</section>
<script>
function selectDateRange() {
    var fromDate = document.getElementById('fromDate').value;
    var toDate = document.getElementById('toDate').value;
    var message = document.getElementById('message');
    if (!fromDate || !toDate) {
        message.textContent = 'Vui lòng chọn đủ ngày bắt đầu và ngày kết thúc.';
        return false;
    }
    if (fromDate > toDate) {
        message.textContent = 'Ngày bắt đầu không được lớn hơn ngày kết thúc.';
        return false;
    }
    return true;
}
function showReaderStatistics() {
    var resultList = document.getElementById('resultList');
    if (resultList) resultList.hidden = false;
    return resultList;
}
function chooseReader(readerId) {
    var params = 'selectedReaderId=' + encodeURIComponent(readerId)
            + '&employeeId=' + encodeURIComponent(document.getElementById('employeeId').value)
            + '&fromDate=' + encodeURIComponent(document.getElementById('fromDate').value)
            + '&toDate=' + encodeURIComponent(document.getElementById('toDate').value)
            + '&readerKeyword=' + encodeURIComponent(document.getElementById('readerKeyword').value);
    window.location = 'BorrowHistoryUI8.jsp?' + params;
}
function backToReportMenu() {
    var employeeId = document.getElementById('employeeId').value;
    window.location = 'ReportMenuUI8.jsp?employeeId=' + encodeURIComponent(employeeId);
}
showReaderStatistics();
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
