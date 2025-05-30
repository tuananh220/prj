<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<%@ page import="model.Food" %>
<html>
    <head>
        <title>Sửa món ăn</title>
        <meta charset="UTF-8">
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f2f4f7;
                padding: 40px;
            }

            h2 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 30px;
            }

            form {
                max-width: 500px;
                margin: auto;
                background-color: #fff;
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            label {
                display: block;
                margin-bottom: 6px;
                font-weight: bold;
                color: #34495e;
            }

            input[type="text"],
            input[type="number"],
            textarea,
            select {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 5px;
                box-sizing: border-box;
                font-size: 14px;
            }

            textarea {
                resize: vertical;
            }

            .button-group {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            button {
                background-color: #007bff;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 16px;
            }

            button:hover {
                background-color: #0069d9;
            }

            .back-link {
                text-decoration: none;
                font-size: 14px;
                color: #555;
                background-color: #e0e0e0;
                padding: 8px 15px;
                border-radius: 6px;
                transition: 0.2s ease;
            }

            .back-link:hover {
                background-color: #d5d5d5;
            }

            p.message {
                text-align: center;
                color: green;
                font-weight: bold;
                margin-bottom: 15px;
            }

            p.error {
                text-align: center;
                color: red;
                font-weight: bold;
                margin-bottom: 15px;
            }
        </style>
    </head>
    <body>
        <h2>Sửa món ăn</h2>

        <%
            // Lấy message và error nếu có
            String message = (String) request.getAttribute("message");
            String error = (String) request.getAttribute("error");

            if (message != null) {
        %>
        <p class="message"><%= message %></p>
        <%
            }
            if (error != null) {
        %>
        <p class="error"><%= error %></p>
        <%
            }

            Food food = (Food) request.getAttribute("food");
            List<Category> categories = (List<Category>) request.getAttribute("categories");
            if (food == null) {
        %>
        <p>Không tìm thấy món ăn.</p>
        <%
            } else {
        %>
        <form action="edit-food" method="post">
            <input type="hidden" name="foodId" value="<%= food.getFoodId() %>">

            <label for="name">Tên món:</label>
            <input type="text" name="name" id="name" value="<%= food.getName() %>" required>

            <label for="description">Mô tả:</label>
            <textarea name="description" id="description"><%= food.getDescription() != null ? food.getDescription() : "" %></textarea>

            <label for="price">Giá:</label>
            <input type="number" step="0.01" name="price" id="price" value="<%= food.getPrice() %>" required>

            <label for="imageUrl">Ảnh URL:</label>
            <input type="text" name="imageUrl" id="imageUrl" value="<%= food.getImageUrl() != null ? food.getImageUrl() : "" %>">

            <label for="discountPercent">Discount Percent:</label>
            <input type="number" step="0.01" min="0" max="100" id="discountPercent" name="discountPercent"
                   value="${food.discountPercent}" required><br/>

            <label for="categoryId">Danh mục:</label>
            <select name="categoryId" id="categoryId">
                <%
                    if (categories != null) {
                        for (Category c : categories) {
                            String selected = (food.getCategory() != null && c.getCategoryId() == food.getCategory().getCategoryId()) ? "selected" : "";
                %>
                <option value="<%= c.getCategoryId() %>" <%= selected %>><%= c.getName() %></option>
                <%
                        }
                    }
                %>
            </select>

            <div class="button-group">
                <button type="submit">Cập nhật</button>
                <a class="back-link" href="food-list">Quay lại danh sách</a>
            </div>
        </form>
        <%
            }
        %>
    </body>
</html>
