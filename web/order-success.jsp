<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đặt hàng thành công</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f8f9fa;
            margin: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        header {
            background-color: #343a40;
            padding: 10px 20px;
        }

        .navbar-brand {
            display: flex;
            align-items: center;
            text-decoration: none;
        }

        .navbar-brand img {
            height: 50px;
            border-radius: 12px;
            background: #fff;
            padding: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
            margin-right: 10px;
        }

        .navbar-brand span {
            color: white;
            font-size: 1.5rem;
            font-weight: bold;
            text-shadow: 1px 1px 2px black;
        }

        .success-container {
            background: white;
            max-width: 700px;
            margin: 40px auto;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        h2 {
            color: #28a745;
            font-size: 28px;
            margin-bottom: 20px;
        }

        .order-info {
            font-size: 18px;
            margin-bottom: 15px;
        }

        button.toggle-btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 20px;
        }

        button.toggle-btn:hover {
            background-color: #0056b3;
        }

        .order-details {
            margin-top: 20px;
            text-align: left;
            display: none;
        }

        .order-details ul {
            list-style: none;
            padding-left: 0;
        }

        .order-details li {
            font-size: 16px;
            padding: 8px;
            border-bottom: 1px solid #ddd;
        }

        .total {
            font-weight: bold;
            margin-top: 10px;
        }

        a.button {
            display: inline-block;
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            margin-top: 30px;
            text-decoration: none;
            font-weight: bold;
        }

        a.button:hover {
            background-color: #218838;
        }

        footer {
            background: #2c3e50;
            color: #f1f1f1;
            text-align: center;
            padding: 20px 0;
            margin-top: auto;
        }

        footer a {
            color: #f1f1f1;
            text-decoration: underline;
        }
    </style>
    <script>
        function toggleDetails() {
            var details = document.getElementById("details");
            if (details.style.display === "none") {
                details.style.display = "block";
            } else {
                details.style.display = "none";
            }
        }
    </script>
</head>
<body>

<!-- Header -->
<header>
    <a class="navbar-brand" href="${pageContext.request.contextPath}/menu">
        <img src="${pageContext.request.contextPath}/assets/data/5abb9bbc-635e-4f3f-83ee-0b0540971d30.png" alt="AnhNT Logo">
        <span>AnhNT</span>
    </a>
</header>

<!-- Main Content -->
<div class="success-container">
    <h2>🎉 Đặt hàng thành công!</h2>
    <p class="order-info">Cảm ơn bạn đã đặt hàng tại <strong>AnhNT</strong>.</p>
    <p class="order-info">Mã đơn hàng: <strong>${orderId}</strong></p>

    <button class="toggle-btn" onclick="toggleDetails()">Xem chi tiết đơn hàng</button>

    <div class="order-details" id="details">
        <ul>
            <c:forEach var="item" items="${orderDetails}">
                <li>${item.food.name} - SL: ${item.quantity} - Giá: ${item.price}đ</li>
            </c:forEach>
        </ul>
        <p class="total">Tổng tiền: ${totalAmount}đ</p>
    </div>

    <a href="${pageContext.request.contextPath}/menu" class="button">Tiếp tục đặt món</a>
</div>

<!-- Footer -->
<footer>
    <div class="container">
        <p>&copy; 2025 AnhNT. All rights reserved.</p>
        <p><a href="${pageContext.request.contextPath}/support">Hỗ trợ</a> | 
           Liên hệ: 0923894829 | Địa chỉ: Hoà Lạc – Thạch Thất – Hà Nội</p>
        <p style="font-style:italic">Thiết kế bởi AnhNT</p>
    </div>
</footer>

</body>
</html>
