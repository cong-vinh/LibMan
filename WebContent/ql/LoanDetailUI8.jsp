<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.DAO8" %>
<%@ page import="dao.LoanDetailDAO8" %>
<%@ page import="dao.LoanRecordDAO8" %>
<%@ page import="model.LoanDetail8" %>
<%@ page import="model.LoanRecord8" %>
<%@ page import="model.Reader8" %>
<%@ include file="../WEB-INF/jspf/access.jspf" %>
<%
    String employeeId = request.getParameter("employeeId");
    if (employeeId == null) employeeId = "";
    boolean managerAllowed = hasManagerAccess(employeeId);
    String selectedReaderId = request.getParameter("selectedReaderId");
    if (selectedReaderId == null) selectedReaderId = "";
    String fromDate = request.getParameter("fromDate");
    if (fromDate == null) fromDate = "";
    String toDate = request.getParameter("toDate");
    if (toDate == null) toDate = "";
    String selectedLoanRecordId = request.getParameter("selectedLoanRecordId");
    if (selectedLoanRecordId == null) selectedLoanRecordId = "";
    String readerKeyword = request.getParameter("readerKeyword");
    if (readerKeyword == null) readerKeyword = "";

    LoanRecord8 selectedLoan = null;
    Reader8 selectedReader = null;
    LoanDetail8[] detailList = new LoanDetail8[0];
    List<String> documentTitles = new ArrayList<String>();
    List<Integer> documentQuantities = new ArrayList<Integer>();
    String readerName = "";
    String librarianName = "";
    int librarianEmployeeId = 0;
    int selectedReaderNumeric = 0;
    String message = "";
    try {
        if (!managerAllowed) {
            message = "Mã nhân viên quản lý không hợp lệ hoặc bạn không có quyền truy cập.";
        } else {
        selectedReaderNumeric = Integer.parseInt(selectedReaderId);
        int loanRecordId = Integer.parseInt(selectedLoanRecordId);
        LoanRecordDAO8 loanDAO = new LoanRecordDAO8();
        try {
            selectedLoan = loanDAO.getById(loanRecordId);
        } finally {
            loanDAO.closeConnection();
        }
        LoanDetailDAO8 detailDAO = new LoanDetailDAO8();
        try {
            detailList = detailDAO.getDetailsByLoan(loanRecordId);
        } finally {
            detailDAO.closeConnection();
        }
        if (selectedLoan == null) {
            message = "Không tìm thấy phiếu mượn trong cơ sở dữ liệu.";
        } else {
            DAO8 viewDAO = new DAO8();
            try {
                Connection connection = viewDAO.getConnection();
                String peopleSql = "SELECT r.readerId, ru.fullName AS readerName, "
                        + "lb.employeeId, lu.fullName AS librarianName "
                        + "FROM tblLoanRecord8 l "
                        + "JOIN tblReader8 r ON r.userId = l.readerUserId "
                        + "JOIN tblUser8 ru ON ru.id = r.userId "
                        + "JOIN tblLibrarian8 lb ON lb.userId = l.librarianUserId "
                        + "JOIN tblUser8 lu ON lu.id = lb.userId "
                        + "WHERE l.loanRecordId = ?";
                try (PreparedStatement statement = connection.prepareStatement(peopleSql)) {
                    statement.setInt(1, loanRecordId);
                    try (ResultSet rs = statement.executeQuery()) {
                        if (rs.next()) {
                            selectedReader = new Reader8();
                            selectedReader.setReaderId(rs.getInt("readerId"));
                            selectedReader.setFullName(rs.getString("readerName"));
                            readerName = rs.getString("readerName");
                            librarianEmployeeId = rs.getInt("employeeId");
                            librarianName = rs.getString("librarianName");
                        }
                    }
                }
                String documentsSql = "SELECT d.title, COUNT(*) AS quantity "
                        + "FROM tblLoanDetail8 ld "
                        + "JOIN tblDocumentTypeCopy8 c ON c.copyId = ld.copyId "
                        + "JOIN tblDocumentType8 d ON d.documentTypeId = c.documentTypeId "
                        + "WHERE ld.loanRecordId = ? "
                        + "GROUP BY d.documentTypeId, d.title "
                        + "ORDER BY d.documentTypeId ASC";
                try (PreparedStatement statement = connection.prepareStatement(documentsSql)) {
                    statement.setInt(1, loanRecordId);
                    try (ResultSet rs = statement.executeQuery()) {
                        while (rs.next()) {
                            documentTitles.add(rs.getString("title"));
                            documentQuantities.add(Integer.valueOf(rs.getInt("quantity")));
                        }
                    }
                }
            } finally {
                viewDAO.closeConnection();
            }
            if (detailList.length == 0) {
                message = "Phiếu mượn chưa có chi tiết tài liệu.";
            }
        }
        }
    } catch (NumberFormatException e) {
        message = "Mã phiếu được chọn không hợp lệ.";
    } catch (RuntimeException e) {
        message = "Không thể đọc chi tiết phiếu mượn từ cơ sở dữ liệu.";
    }
%>
<%@ include file="../header.jsp" %>
<section class="panel">
    <h2>Chi tiết phiếu mượn</h2>
    <label>Mã nhân viên</label>
    <input class="readonly-field" id="employeeId" type="text" value="<%= h(employeeId) %>" disabled>
    <label>Mã độc giả đã chọn</label>
    <input class="readonly-field" id="selectedReaderId" type="text" value="<%= h(selectedReaderId) %>" disabled>
    <label>Từ ngày</label>
    <input class="readonly-field" id="fromDate" type="date" value="<%= h(fromDate) %>" disabled>
    <label>Đến ngày</label>
    <input class="readonly-field" id="toDate" type="date" value="<%= h(toDate) %>" disabled>
    <label>Mã phiếu đã chọn</label>
    <input class="readonly-field" id="selectedLoanRecordId" type="text" value="<%= h(selectedLoanRecordId) %>" disabled>
    <input id="readerKeyword" type="hidden" value="<%= h(readerKeyword) %>">

    <p id="message" class="message"><%= h(message) %></p>
    <% if (selectedLoan != null) { %>
        <div id="loanSummary">
            <p><strong>Độc giả:</strong> DG<%= String.format("%02d", selectedReaderNumeric) %> -
                <%= h(selectedReader == null ? readerName : selectedReader.getFullName()) %></p>
            <p><strong>Nhân viên thư viện:</strong>
                <% if (librarianEmployeeId > 0) { %>NV<%= String.format("%02d", librarianEmployeeId) %> - <% } %>
                <%= h(librarianName) %></p>
            <p><strong>Ngày mượn:</strong> <%= selectedLoan.getLoanDate() %></p>
            <p><strong>Trạng thái:</strong> <%= h(selectedLoan.getStatus()) %></p>
        </div>
        <h3>Danh sách tài liệu</h3>
        <div id="detailList">
            <% if (!documentTitles.isEmpty()) { %>
                <table>
                    <thead><tr><th>Tên tài liệu</th><th>Số lượng</th></tr></thead>
                    <tbody>
                    <% for (int i = 0; i < documentTitles.size(); i++) { %>
                        <tr>
                            <td><%= h(documentTitles.get(i)) %></td>
                            <td class="number-cell"><%= documentQuantities.get(i) %></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    <% } %>
    <button type="button" onclick="backToHistory()">Quay lại</button>
</section>
<script>
function showLoanDetails() {
    var detailList = document.getElementById('detailList');
    if (detailList) detailList.hidden = false;
    return detailList;
}
function backToHistory() {
    var params = 'employeeId=' + encodeURIComponent(document.getElementById('employeeId').value)
            + '&selectedReaderId=' + encodeURIComponent(document.getElementById('selectedReaderId').value)
            + '&fromDate=' + encodeURIComponent(document.getElementById('fromDate').value)
            + '&toDate=' + encodeURIComponent(document.getElementById('toDate').value)
            + '&readerKeyword=' + encodeURIComponent(document.getElementById('readerKeyword').value);
    window.location = 'BorrowHistoryUI8.jsp?' + params;
}
showLoanDetails();
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
