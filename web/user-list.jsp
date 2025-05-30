<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<html>
<head>
    <title>Quản lý người dùng</title>
    <meta charset="UTF-8">
    <style>
        /* Reset cơ bản */
        * {
            box-sizing: border-box;
            margin: 0; padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f0f4f8, #d9e2ec);
            padding: 30px 15px;
            color: #333;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        h2 {
            margin-bottom: 25px;
            font-size: 2.2rem;
            color: #222;
            font-weight: 700;
            text-align: center;
        }

        table {
            border-collapse: separate;
            border-spacing: 0 12px;
            width: 100%;
            max-width: 1100px;
            background: white;
            box-shadow: 0 4px 14px rgb(0 0 0 / 0.1);
            border-radius: 10px;
            overflow: hidden;
        }

        thead tr {
            background: #1e90ff;
            color: white;
            font-weight: 600;
            font-size: 1.1rem;
        }

        th, td {
            padding: 14px 18px;
            text-align: center;
        }

        tbody tr {
            background: #f7faff;
            transition: background-color 0.3s ease;
            border-radius: 8px;
        }

        tbody tr:hover {
            background-color: #e1edff;
        }

        tbody tr td:first-child {
            font-weight: 600;
        }

        /* Link sửa xóa */
        td a {
            color: #007bff;
            text-decoration: none;
            font-weight: 600;
            margin: 0 6px;
            transition: color 0.3s ease;
        }
        td a:hover {
            color: #004085;
        }

        /* Nút Thêm người dùng */
        .btn-add {
            display: inline-block;
            margin: 25px 0 10px 0;
            padding: 12px 30px;
            font-size: 1rem;
            background-color: #28a745;
            color: white;
            font-weight: 700;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 10px rgb(40 167 69 / 0.45);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
            text-decoration: none;
            user-select: none;
        }
        .btn-add:hover {
            background-color: #218838;
            box-shadow: 0 6px 14px rgb(33 136 56 / 0.7);
        }

        /* Nút Trở lại Menu */
        .btn-back {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 28px;
            font-size: 1rem;
            background-color: #6c757d;
            color: white;
            font-weight: 600;
            border-radius: 8px;
            text-decoration: none;
            box-shadow: 0 4px 10px rgb(108 117 125 / 0.4);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
            user-select: none;
        }
        .btn-back:hover {
            background-color: #5a6268;
            box-shadow: 0 6px 14px rgb(90 98 104 / 0.6);
        }

        /* Responsive */
        @media (max-width: 900px) {
            table, thead, tbody, th, td, tr {
                display: block;
                width: 100%;
            }
            thead tr {
                position: absolute;
                top: -9999px;
                left: -9999px;
            }
            tbody tr {
                margin-bottom: 18px;
                background: white;
                box-shadow: 0 2px 10px rgb(0 0 0 / 0.1);
                border-radius: 10px;
                padding: 20px;
            }
            tbody tr td {
                text-align: right;
                padding-left: 50%;
                position: relative;
                border: none;
                border-bottom: 1px solid #eee;
            }
            tbody tr td:last-child {
                border-bottom: 0;
            }
            tbody tr td:before {
                position: absolute;
                top: 50%;
                left: 18px;
                width: 45%;
                padding-right: 10px;
                white-space: nowrap;
                font-weight: 700;
                color: #1e90ff;
                transform: translateY(-50%);
                text-align: left;
                font-size: 0.95rem;
            }
            tbody tr td:nth-of-type(1):before { content: "ID"; }
            tbody tr td:nth-of-type(2):before { content: "Tài khoản"; }
            tbody tr td:nth-of-type(3):before { content: "Họ tên"; }
            tbody tr td:nth-of-type(4):before { content: "SĐT"; }
            tbody tr td:nth-of-type(5):before { content: "Địa chỉ"; }
            tbody tr td:nth-of-type(6):before { content: "Vai trò"; }
            tbody tr td:nth-of-type(7):before { content: "Thao tác"; }

            .btn-add, .btn-back {
                width: 100%;
                padding: 14px 0;
                font-size: 1.1rem;
                text-align: center;
                display: block;
                margin: 15px 0;
            }
        }
    </style>
</head>
<body>
    <h2>Danh sách người dùng</h2>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Tài khoản</th>
            <th>Họ tên</th>
            <th>SĐT</th>
            <th>Địa chỉ</th>
            <th>Vai trò</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<User> users = (List<User>) request.getAttribute("users");
            if (users != null && !users.isEmpty()) {
                for (User u : users) {
        %>
        <tr>
            <td><%= u.getUserId() %></td>
            <td><%= u.getUsername() %></td>
            <td><%= u.getFullName() %></td>
            <td><%= u.getPhone() %></td>
            <td><%= u.getAddress() %></td>
            <td><%= u.getRole() %></td>
            <td>
                <a href="edit-user?userId=<%= u.getUserId() %>">Sửa</a> |
                <a href="delete-user?userId=<%= u.getUserId() %>" onclick="return confirm('Bạn có chắc muốn xóa người dùng này không?');">Xóa</a>
            </td>
        </tr>
        <%
                }
            } else {
        %>
        <tr><td colspan="7">Không có người dùng nào.</td></tr>
        <% } %>
        </tbody>
    </table>

    <a href="add-user" class="btn-add">➕ Thêm người dùng</a>
    <a href="admin-menu.jsp" class="btn-back">← Trở lại Menu</a>
</body>
</html>
