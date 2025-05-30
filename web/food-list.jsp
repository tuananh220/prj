<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Food" %>
<html>
<head>
    <title>Quản lý món ăn</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #eef2f7;
            padding: 30px;
            margin: 0;
        }

        h2 {
            color: #2c3e50;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background-color: #ffffff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            margin-top: 30px;
        }

        th, td {
            padding: 14px 18px;
            text-align: center;
            border-bottom: 1px solid #f0f0f0;
        }

        th {
            background-color: #3498db;
            color: #ffffff;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background-color: #f9fcff;
        }

        tr:hover {
            background-color: #eaf4fb;
        }

        img {
            border-radius: 6px;
        }

        a.action-link {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
            margin: 0 5px;
        }

        a.action-link:hover {
            text-decoration: underline;
        }

        .actions {
            margin-top: 30px;
            text-align: center;
        }

        .actions a {
            display: inline-block;
            margin: 0 12px;
            padding: 12px 20px;
            background-color: #3498db;
            color: white;
            border-radius: 8px;
            font-weight: 500;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }

        .actions a:last-child {
            background-color: #95a5a6;
        }

        .actions a:hover {
            opacity: 0.9;
        }

        footer {
            background: #2c3e50;
            color: #f1f1f1;
            padding: 25px 0;
            text-align: center;
            font-size: 14px;
            margin-top: 60px;
            border-top: 5px solid #2980b9;
        }

        footer a {
            color: #f1f1f1;
            text-decoration: underline;
        }

        footer a:hover {
            color: #ccc;
        }

        .star {
            color: gold;
            font-size: 16px;
        }

        button.review-btn {
            margin-top: 6px;
            padding: 6px 10px;
            background-color: #2980b9;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
        }

        button.review-btn:hover {
            background-color: #216494;
        }

        .review-box {
            margin-top: 10px;
            font-size: 14px;
            color: #333;
        }
    </style>
</head>

<body>
<h2>Danh sách món ăn</h2>
<table>
    <tr>
        <th>ID</th>
        <th>Tên món</th>
        <th>Mô tả</th>
        <th>Giá</th>
        <th>Ảnh</th>
        <th>Danh mục</th>
        <th>Hành động</th>
        <th>Đánh giá</th>
    </tr>
    <%
        List<Food> foods = (List<Food>) request.getAttribute("foods");
        if (foods != null) {
            for (Food f : foods) {
    %>
    <tr>
        <td><%= f.getFoodId() %></td>
        <td><%= f.getName() %></td>
        <td><%= f.getDescription() %></td>
        <td><%= f.getPrice() %> đ</td>
        <td>
            <% if (f.getImageUrl() != null && !f.getImageUrl().isEmpty()) { %>
                <img src="<%= f.getImageUrl() %>" width="100" />
            <% } else { %>
                <em>Không có ảnh</em>
            <% } %>
        </td>
        <td><%= (f.getCategory() != null) ? f.getCategory().getName() : "Chưa phân loại" %></td>
        <td>
            <a class="action-link" href="edit-food?foodId=<%= f.getFoodId() %>">✏️ Sửa</a>
            <a class="action-link" href="delete-food?foodId=<%= f.getFoodId() %>" onclick="return confirm('Bạn có chắc muốn xoá món này?');">🗑️ Xoá</a>
        </td>
        <td>
            <%
                double rating = f.getAverageRating();
                int fullStars = (int) rating;
                boolean halfStar = (rating - fullStars) >= 0.5;
                for (int i = 0; i < fullStars; i++) {
            %><span class="star">★</span><% }
                if (halfStar) { %><span class="star">☆</span><% }
            %>
            (<%= String.format("%.1f", rating) %>/5)

            <br>
            <button class="review-btn" onclick="showReviews(<%= f.getFoodId() %>)">📋 Chi tiết</button>
            <div class="review-box" id="reviews-<%= f.getFoodId() %>" style="display:none;"></div>
        </td>
    </tr>
    <% } } else { %>
    <tr><td colspan="8">Không có món ăn nào</td></tr>
    <% } %>
</table>

<div class="actions">
    <a href="add-food">➕ Thêm món mới</a>
    <a href="admin-menu.jsp">🔙 Quay lại Menu</a>
</div>

<footer>
    <div class="container">
        <p>&copy; 2025 DucNQ. All rights reserved.</p>
        <p>
            <a href="${pageContext.request.contextPath}/support">Hỗ trợ</a> |
            Liên hệ: 0923894829 | Địa chỉ: Hoà Lạc – Thạch Thất – Hà Nội
        </p>
        <p style="font-style:italic">Thiết kế bởi DucNQ</p>
    </div>
</footer>

<script>
function showReviews(foodId) {
    const reviewDiv = document.getElementById("reviews-" + foodId);
    if (reviewDiv.style.display === "block") {
        reviewDiv.style.display = "none";
        reviewDiv.innerHTML = "";
        return;
    }

    fetch("submit-review?foodId=" + foodId)
        .then(response => response.text())
        .then(html => {
            reviewDiv.innerHTML = html;
            reviewDiv.style.display = "block";
        })
        .catch(error => {
            reviewDiv.innerHTML = "<span style='color:red;'>Không thể tải đánh giá.</span>";
        });
}
</script>
</body>
</html>
