<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lịch sử đặt hàng</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 40px 0;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
        }

        .container {
            background: #ffffff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 900px;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 25px;
        }

        form {
            margin-bottom: 20px;
            text-align: right;
        }

        select {
            padding: 10px 12px;
            font-size: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
            background-color: #fff;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            padding: 14px 12px;
            border: 1px solid #e1e4e8;
            text-align: center;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        td {
            font-size: 15px;
            color: #333;
        }

        button {
            background-color: #dc3545;
            color: white;
            padding: 6px 14px;
            font-size: 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #c82333;
        }

        a.back-link {
            display: inline-block;
            margin-top: 25px;
            font-size: 15px;
            color: #007bff;
            text-decoration: none;
        }

        a.back-link:hover {
            text-decoration: underline;
        }

        p {
            text-align: center;
            color: #555;
            font-size: 16px;
            margin-top: 30px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Lịch sử đơn hàng</h2>

    <form method="get" action="order-history">
        <label for="status">Lọc theo trạng thái:</label>
        <select name="status" onchange="this.form.submit()">
            <option value="All" <%= "All".equals(request.getAttribute("selectedStatus")) ? "selected" : "" %>>Tất cả</option>
            <option value="Pending" <%= "Pending".equals(request.getAttribute("selectedStatus")) ? "selected" : "" %>>Đang xử lý</option>
            <option value="Delivered" <%= "Delivered".equals(request.getAttribute("selectedStatus")) ? "selected" : "" %>>Đã giao</option>
            <option value="Cancelled" <%= "Cancelled".equals(request.getAttribute("selectedStatus")) ? "selected" : "" %>>Đã huỷ</option>
        </select>
    </form>

    <%
        List<Order> orders = (List<Order>) request.getAttribute("orders");
        if (orders != null && !orders.isEmpty()) {
    %>
    <table>
        <tr>
            <th>Mã đơn</th>
            <th>Ngày đặt</th>
            <th>Tổng tiền</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>
        <% for (Order o : orders) { %>
        <tr>
            <td><%= o.getOrderId() %></td>
            <td><%= o.getOrderDate() %></td>
            <td><%= o.getTotalAmount() %> đ</td>
            <td><%= o.getStatus() %></td>
            <td>
                <% if ("Pending".equals(o.getStatus())) { %>
                    <form action="order-history" method="post" style="display:inline;">
                        <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                        <button type="submit">Huỷ đơn</button>
                    </form>
                <% } else { %> - <% } %>
            </td>
        </tr>
        <% } %>
    </table>
    <% } else { %>
        <p>Không có đơn hàng nào.</p>
    <% } %>

    <a href="menu" class="back-link">← Quay lại thực đơn</a>
</div>
</body>
</html>
