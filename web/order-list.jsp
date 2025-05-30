<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<html>
<head>
    <title>Quản lý đơn hàng</title>
    <meta charset="UTF-8"/>
    <style>
/* Reset một số mặc định cơ bản */
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #e3f2fd, #ffffff);
    padding: 40px 20px;
    min-height: 100vh;
    color: #333;
    display: flex;
    flex-direction: column;
    align-items: center;
}

h2 {
    font-size: 2.4rem;
    font-weight: 700;
    margin-bottom: 15px;
    color: #222;
    text-align: center;
}

/* Nút Trở lại Menu */
a.btn-back {
    display: inline-block;
    padding: 10px 24px;
    background-color: #28a745;
    color: white;
    font-weight: 600;
    border-radius: 8px;
    text-decoration: none;
    font-size: 1.1rem;
    box-shadow: 0 4px 10px rgba(40, 167, 69, 0.45);
    transition: background-color 0.3s ease, box-shadow 0.3s ease;
    margin-bottom: 30px;
    user-select: none;
}

a.btn-back:hover,
a.btn-back:focus {
    background-color: #218838;
    box-shadow: 0 6px 14px rgba(33, 136, 56, 0.7);
    outline: none;
}

/* Form lọc trạng thái */
form#filterForm {
    width: 100%;
    max-width: 420px;
    background: #fff;
    padding: 18px 24px;
    border-radius: 12px;
    box-shadow: 0 6px 20px rgba(0, 123, 255, 0.15);
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 40px;
}

form#filterForm label {
    font-weight: 600;
    font-size: 1.1rem;
    color: #007bff;
}

select#filterStatus {
    flex-grow: 1;
    margin-left: 15px;
    padding: 10px 14px;
    font-size: 1rem;
    border-radius: 8px;
    border: 2px solid #007bff;
    cursor: pointer;
    transition: border-color 0.3s ease;
    background: white;
}

select#filterStatus:hover,
select#filterStatus:focus {
    border-color: #0056b3;
    outline: none;
}

button#filterBtn {
    margin-left: 20px;
    padding: 10px 22px;
    background-color: #007bff;
    border: none;
    border-radius: 8px;
    color: white;
    font-weight: 700;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.3s ease, box-shadow 0.3s ease;
}

button#filterBtn:hover,
button#filterBtn:focus {
    background-color: #0056b3;
    box-shadow: 0 5px 15px rgba(0, 86, 179, 0.5);
    outline: none;
}

/* Form cập nhật trạng thái */
form#updateForm {
    width: 100%;
    max-width: 1100px;
    background: white;
    padding: 30px 40px;
    border-radius: 16px;
    box-shadow: 0 10px 35px rgba(0, 0, 0, 0.1);
}

/* Bảng danh sách đơn hàng */
table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0 10px;
    font-size: 1rem;
}

th, td {
    text-align: center;
    padding: 14px 12px;
    vertical-align: middle;
}

th {
    background-color: #007bff;
    color: white;
    font-weight: 700;
    border-radius: 12px 12px 0 0;
    user-select: none;
    letter-spacing: 0.05em;
}

tr {
    background: #f9fbff;
    box-shadow: 0 2px 8px rgba(0, 123, 255, 0.1);
    border-radius: 12px;
}

tr:nth-child(even) {
    background: #eaf3ff;
}

tr td:first-child {
    border-radius: 12px 0 0 12px;
}

tr td:last-child {
    border-radius: 0 12px 12px 0;
}

/* Dropdown trạng thái trong bảng */
select.status-select {
    padding: 8px 12px;
    border-radius: 8px;
    border: 2px solid #ddd;
    font-size: 1rem;
    cursor: pointer;
    transition: border-color 0.3s ease;
    background: white;
}

select.status-select:hover,
select.status-select:focus {
    border-color: #007bff;
    outline: none;
}

/* Nút cập nhật */
button[type="submit"] {
    margin-top: 30px;
    background-color: #007bff;
    color: white;
    border: none;
    padding: 14px 32px;
    font-size: 1.2rem;
    font-weight: 700;
    border-radius: 10px;
    cursor: pointer;
    display: block;
    margin-left: auto;
    margin-right: auto;
    transition: background-color 0.3s ease, box-shadow 0.3s ease;
}

button[type="submit"]:hover,
button[type="submit"]:focus {
    background-color: #0056b3;
    box-shadow: 0 8px 20px rgba(0, 86, 179, 0.6);
    outline: none;
}

/* Responsive cho mobile */
@media (max-width: 768px) {
    body {
        padding: 20px 10px;
    }

    form#filterForm {
        flex-direction: column;
        gap: 15px;
        padding: 20px;
    }

    select#filterStatus {
        margin-left: 0;
        width: 100%;
    }

    button#filterBtn {
        margin-left: 0;
        width: 100%;
    }

    form#updateForm {
        padding: 20px;
    }

    table, thead, tbody, th, td, tr {
        display: block;
        width: 100%;
    }

    thead tr {
        display: none;
    }

    tr {
        margin-bottom: 18px;
        box-shadow: none;
        background: white;
        border-radius: 12px;
        padding: 15px 20px;
        border: 1px solid #ddd;
    }

    td {
        padding-left: 50%;
        position: relative;
        text-align: left;
        border: none;
        border-bottom: 1px solid #eee;
    }

    td:before {
        position: absolute;
        top: 50%;
        left: 20px;
        transform: translateY(-50%);
        width: 45%;
        white-space: nowrap;
        font-weight: 700;
        color: #007bff;
        font-size: 0.95rem;
    }

    td:nth-of-type(1):before { content: "Mã đơn hàng"; }
    td:nth-of-type(2):before { content: "Người dùng"; }
    td:nth-of-type(3):before { content: "Ngày đặt"; }
    td:nth-of-type(4):before { content: "Tổng tiền"; }
    td:nth-of-type(5):before { content: "Trạng thái"; }

    button[type="submit"] {
        width: 100%;
        font-size: 1.1rem;
        padding: 14px 0;
    }
}

    </style>
</head>
<body>
<h2>Danh sách đơn hàng</h2>
<div style="text-align: center; margin-bottom: 20px;">
    <a href="admin-menu.jsp" class="btn-back">← Trở lại Menu</a>
</div>
<!-- FORM LỌC TRẠNG THÁI -->
<form id="filterForm" action="order-list" method="get">
    <label for="filterStatus">Lọc trạng thái:</label>
    <select id="filterStatus" name="statusFilter">
        <option value="" <%= (request.getParameter("statusFilter") == null || request.getParameter("statusFilter").isEmpty()) ? "selected" : "" %>>Tất cả</option>
        <option value="Pending" <%= "Pending".equals(request.getParameter("statusFilter")) ? "selected" : "" %>>Pending</option>
        <option value="Processing" <%= "Processing".equals(request.getParameter("statusFilter")) ? "selected" : "" %>>Processing</option>
        <option value="Delivered" <%= "Delivered".equals(request.getParameter("statusFilter")) ? "selected" : "" %>>Delivered</option>
        <option value="Cancelled" <%= "Cancelled".equals(request.getParameter("statusFilter")) ? "selected" : "" %>>Cancelled</option>
    </select>
    <button type="submit" id="filterBtn">Lọc</button>
</form>

<!-- FORM CẬP NHẬT TRẠNG THÁI -->
<form id="updateForm" action="order-list" method="post">
    <table>
        <tr>
            <th>Mã đơn hàng</th>
            <th>Người dùng</th>
            <th>Ngày đặt</th>
            <th>Tổng tiền</th>
            <th>Trạng thái</th>
        </tr>
        <%
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            if (orders != null && !orders.isEmpty()) {
                for (Order o : orders) {
        %>
        <tr>
            <td>
                <%= o.getOrderId() %>
                <input type="hidden" name="orderId" value="<%= o.getOrderId() %>"/>
            </td>
            <td><%= o.getUserId() %></td>
            <td><%= o.getOrderDate() %></td>
            <td><%= String.format("%.2f", o.getTotalAmount()) %></td>
            <td>
                <select name="status" class="status-select">
                    <option value="Pending" <%= "Pending".equals(o.getStatus()) ? "selected" : "" %>>Pending</option>
                    <option value="Processing" <%= "Processing".equals(o.getStatus()) ? "selected" : "" %>>Processing</option>
                    <option value="Delivered" <%= "Delivered".equals(o.getStatus()) ? "selected" : "" %>>Delivered</option>
                    <option value="Cancelled" <%= "Cancelled".equals(o.getStatus()) ? "selected" : "" %>>Cancelled</option>
                </select>
            </td>
        </tr>
        <%
                }
            } else {
        %>
        <tr><td colspan="5">Chưa có đơn hàng nào</td></tr>
        <% } %>
    </table>
    
    <button type="submit">Cập nhật tất cả</button>
</form>
</body>
</html>
