<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<html>
<head>
    <title><%= request.getAttribute("user") == null ? "Thêm người dùng" : "Sửa người dùng" %></title>
    <meta charset="UTF-8">
    <style>
        /* Reset cơ bản */
        * {
            box-sizing: border-box;
            margin: 0; padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f4f8;
            padding: 40px 15px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            color: #333;
        }

        .container {
            background: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 480px;
        }

        h2 {
            margin-bottom: 25px;
            font-weight: 700;
            color: #1e90ff;
            text-align: center;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            font-weight: 600;
            margin-bottom: 6px;
            margin-top: 16px;
            color: #444;
        }

        input[type="text"],
        input[type="password"],
        select {
            padding: 10px 14px;
            border: 1.8px solid #ccc;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        input[type="text"]:focus,
        input[type="password"]:focus,
        select:focus {
            outline: none;
            border-color: #1e90ff;
            box-shadow: 0 0 6px rgba(30,144,255,0.4);
        }

        button {
            margin-top: 30px;
            padding: 14px 0;
            background-color: #1e90ff;
            color: white;
            font-weight: 700;
            font-size: 1.1rem;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            box-shadow: 0 5px 15px rgba(30,144,255,0.5);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
            user-select: none;
        }
        button:hover {
            background-color: #0066cc;
            box-shadow: 0 7px 20px rgba(0,102,204,0.7);
        }

        .readonly-field {
            margin-top: 8px;
            font-weight: 600;
            color: #222;
            background-color: #f5f7fa;
            padding: 10px 14px;
            border-radius: 8px;
            border: 1.5px solid #ddd;
        }

        .error-message {
            margin-bottom: 15px;
            padding: 12px 15px;
            background-color: #ffdddd;
            border-left: 6px solid #f44336;
            color: #a94442;
            border-radius: 6px;
            font-weight: 600;
        }

        .back-link {
            display: block;
            margin-top: 22px;
            text-align: center;
            color: #666;
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        .back-link:hover {
            color: #1e90ff;
        }
    </style>
</head>
<body>
<div class="container">
    <%
        User user = (User) request.getAttribute("user");   // null nếu đang thêm mới
        boolean edit = user != null;
    %>

    <h2><%= edit ? "Sửa người dùng" : "Thêm người dùng mới" %></h2>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error-message"><%= request.getAttribute("error") %></div>
    <% } %>

    <form action="<%= edit ? "edit-user" : "add-user" %>" method="post">
        <% if (edit) { %>
            <input type="hidden" name="userId" value="<%= user.getUserId() %>">
            <label>Tài khoản:</label>
            <div class="readonly-field"><%= user.getUsername() %></div>
        <% } else { %>
            <label for="username">Tài khoản:</label>
            <input type="text" id="username" name="username" required placeholder="Nhập tài khoản">
            <label for="password">Mật khẩu:</label>
            <input type="password" id="password" name="password" required placeholder="Nhập mật khẩu">
        <% } %>

        <label for="fullName">Họ tên:</label>
        <input type="text" id="fullName" name="fullName" value="<%= edit ? user.getFullName() : "" %>" required placeholder="Nhập họ tên">

        <label for="phone">SĐT:</label>
        <input type="text" id="phone" name="phone" value="<%= edit ? user.getPhone() : "" %>" placeholder="Nhập số điện thoại">

        <label for="address">Địa chỉ:</label>
        <input type="text" id="address" name="address" value="<%= edit ? user.getAddress() : "" %>" placeholder="Nhập địa chỉ">

        <label for="role">Vai trò:</label>
        <select id="role" name="role">
            <option value="customer" <%= edit && "customer".equals(user.getRole()) ? "selected" : "" %>>customer</option>
            <option value="admin" <%= edit && "admin".equals(user.getRole()) ? "selected" : "" %>>admin</option>
        </select>

        <button type="submit"><%= edit ? "Cập nhật" : "Thêm" %></button>
    </form>

    <a href="user-list" class="back-link">← Quay lại danh sách</a>
</div>
</body>
</html>
