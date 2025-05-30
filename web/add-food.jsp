<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<html>
    <head>
    <title>Thêm món ăn</title>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f8;
            padding: 40px;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        form {
            max-width: 500px;
            margin: auto;
            background-color: #fff;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
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
        }

        textarea {
            resize: vertical;
        }

        button {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
        }

        button:hover {
            background-color: #218838;
        }

        a {
            text-decoration: none;
            color: white;
            background-color: #6c757d;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 16px;
        }

        a:hover {
            background-color: #5a6268;
        }
    </style>
</head>
    <body>
        <h2>Thêm món ăn</h2>
        <form action="add-food" method="post">
    <label for="name">Tên món:</label>
    <input type="text" name="name" id="name" required>

    <label for="description">Mô tả:</label>
    <textarea name="description" id="description"></textarea>

    <label for="price">Giá:</label>
    <input type="number" step="0.01" name="price" id="price" required>

    <label for="imageUrl">Ảnh URL:</label>
    <input type="text" name="imageUrl" id="imageUrl">

    <label for="categoryId">Danh mục:</label>
    <select name="categoryId" id="categoryId">
        <% 
            List<Category> categories = (List<Category>) request.getAttribute("categories");
            if (categories != null) {
                for (Category c : categories) { 
        %>
            <option value="<%= c.getCategoryId() %>"><%= c.getName() %></option>
        <% 
                }
            } 
        %>
    </select>

    <button type="submit">Thêm</button>
    <a href="food-list">Quay Lại Menu Food</a>
</form>

    </body>
</html>
