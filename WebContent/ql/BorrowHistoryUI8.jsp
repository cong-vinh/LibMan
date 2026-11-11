<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="dao.LoanRecordDAO8" %>
<%@ page import="dao.ReaderStatisticDAO8" %>
<%@ page import="model.LoanRecord8" %>
<%@ page import="model.ReaderBorrowStatistics8" %>
<%@ include file="../WEB-INF/jspf/access.jspf" %>
<%
    String employeeId = request.getParameter("employeeId");
    if (employeeId == null) employeeId = "";
    boolean managerAllowed = hasManagerAccess(employeeId);
    String selectedReaderId = request.getParameter("selectedReaderId");
    if (selectedReaderId == null) selectedReaderId = "";
    String fromDateText = request.getParameter("fromDate");
    if (fromDateText == null) fromDateText = "";
    String toDateText = request.getParameter("toDate");
    if (toDateText == null) toDateText = "";
    String readerKeyword = request.getParameter("readerKeyword");
    if (readerKeyword == null) readerKeyword = "";

    LoanRecord8[] loanList = new LoanRecord8[0];
    Date[] dueDates = new Date[0];
    int totalBorrows = 0;
    ReaderBorrowStatistics8 selectedReader = null;
    String message = "";
    Date fromDate = null;
    Date toDate = null;
    try {
        if (!managerAllowed) {
            message = "Mã nhân viên quản lý không hợp lệ hoặc bạn không có quyền truy cập.";
        } else {
        int readerId = Integer.parseInt(selectedReaderId);
        fromDate = Date.valueOf(fromDateText);
        toDate = Date.valueOf(toDateText);
        if (fromDate.after(toDate)) {
            message = "Ngày bắt đầu không được lớn hơn ngày kết thúc.";
        } else {
            LoanRecordDAO8 loanDAO = new LoanRecordDAO8();
            try {
                loanList = loanDAO.getLoansByReader(readerId, fromDate, toDate);
                totalBorrows = loanList.length;
                dueDates = new Date[loanList.length];
                for (int i = 0; i < loanList.length; i++) {
                    Calendar dueDate = Calendar.getInstance();
                    dueDate.setTime(loanList[i].getLoanDate());
                    dueDate.add(Calendar.DAY_OF_MONTH, 10);
                    dueDates[i] = new Date(dueDate.getTimeInMillis());
                }
            } finally {
                loanDAO.closeConnection();
            }
            ReaderStatisticDAO8 readerDAO = new ReaderStatisticDAO8();
            try {
                ReaderBorrowStatistics8[] readers = readerDAO.getReaderStatistics(fromDate, toDate);
                for (ReaderBorrowStatistics8 reader : readers) {
                    if (reader.getReaderId() == readerId) {
                        selectedReader = reader;
                        break;
                    }
                }
            } finally {
                readerDAO.closeConnection();
            }
            if (totalBorrows == 0) {
                message = "Không có phiếu mượn của độc giả trong khoảng ngày đã chọn.";
            }
        }
        }
    } catch (NumberFormatException e) {
        message = "Mã độc giả được chọn không hợp lệ.";
    } catch (IllegalArgumentException e) {
        message = "Ngày lọc không hợp lệ hoặc bị bỏ trống.";
    } catch (RuntimeException e) {
        message = "Không thể đọc lịch sử mượn từ cơ sở dữ liệu.";
    }
%>
<%@ include file="../header.jsp" %>
<section class="panel">
    <h2>Lịch sử mượn</h2>
    <label>Mã nhân viên</label>
    <input class="readonly-field" id="employeeId" type="text" value="<%= h(employeeId) %>" disabled>
    <label for="selectedReaderId">Mã độc giả đã chọn</label>
    <input class="readonly-field" id="selectedReaderId" type="text" value="<%= h(selectedReaderId) %>" disabled>
    <label for="fromDate">Từ ngày</label>
    <input class="readonly-field" id="fromDate" type="date" value="<%= h(fromDateText) %>" disabled>
    <label for="toDate">Đến ngày</label>
    <input class="readonly-field" id="toDate" type="date" value="<%= h(toDateText) %>" disabled>
    <input id="readerKeyword" type="hidden" value="<%= h(readerKeyword) %>">

    <p id="message" class="message"><%= h(message) %></p>
    <% if (selectedReader != null) { %>
        <p><strong>Độc giả:</strong> DG<%= String.format("%02d", selectedReader.getReaderId()) %>
            - <%= h(selectedReader.getFullName()) %></p>
    <% } %>
    <p><strong>Số lượt mượn:</strong> <%= totalBorrows %></p>
    <div id="loanList">
        <% if (loanList.length > 0) { %>
            <table>
                <thead><tr><th>Mã phiếu</th><th>Ngày mượn</th><th>Hạn trả</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
                <tbody>
                <% for (int i = 0; i < loanList.length; i++) {
                    LoanRecord8 loan = loanList[i]; %>
                    <tr>
                        <td class="code-cell">PM<%= String.format("%03d", loan.getLoanRecordId()) %></td>
                        <td class="date-cell"><%= loan.getLoanDate() %></td>
                        <td class="date-cell"><%= dueDates[i] %></td>
                        <td><%= h(loan.getStatus()) %></td>
                        <td><button type="button" onclick="chooseLoan(<%= loan.getLoanRecordId() %>)">Xem chi tiết</button></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
    <button type="button" onclick="backToStatistics()">Quay lại</button>
</section>
<script>
function showBorrowHistory() {
    var loanList = document.getElementById('loanList');
    if (loanList) loanList.hidden = false;
    return loanList;
}
function chooseLoan(loanRecordId) {
    var params = 'selectedLoanRecordId=' + encodeURIComponent(loanRecordId)
            + '&employeeId=' + encodeURIComponent(document.getElementById('employeeId').value)
            + '&selectedReaderId=' + encodeURIComponent(document.getElementById('selectedReaderId').value)
            + '&fromDate=' + encodeURIComponent(document.getElementById('fromDate').value)
            + '&toDate=' + encodeURIComponent(document.getElementById('toDate').value)
            + '&readerKeyword=' + encodeURIComponent(document.getElementById('readerKeyword').value);
    window.location = 'LoanDetailUI8.jsp?' + params;
}
function backToStatistics() {
    var params = 'employeeId=' + encodeURIComponent(document.getElementById('employeeId').value)
            + '&fromDate=' + encodeURIComponent(document.getElementById('fromDate').value)
            + '&toDate=' + encodeURIComponent(document.getElementById('toDate').value)
            + '&readerKeyword=' + encodeURIComponent(document.getElementById('readerKeyword').value);
    window.location = 'ReaderStatisticUI8.jsp?' + params;
}
showBorrowHistory();
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
