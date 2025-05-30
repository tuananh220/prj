<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<%@ page import="model.Food" %>
<%@ page import="model.FoodReview" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<%
    /* Dùng scriptlet nhỏ gọn để sort TopSeller nếu cần */
    List<model.Food>     foods      = (List<model.Food>) request.getAttribute("foods");
    if (foods == null)   foods = java.util.Collections.emptyList();

    List<model.Food> topFoods   = new java.util.ArrayList<>();
    List<model.Food> otherFoods = new java.util.ArrayList<>();
    for (model.Food f : foods) {
        if (f.isTopSeller()) topFoods.add(f); else otherFoods.add(f);
    }
    List<model.Food> sortedFoods = new java.util.ArrayList<>(topFoods);
    sortedFoods.addAll(otherFoods);
    request.setAttribute("sortedFoods", sortedFoods);      // gán để dùng JSTL
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Trang Menu - AnhNT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
  
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: #0a0a0a;
      color: #ffffff;
      overflow-x: hidden;
      transition: all 0.3s ease;
    }

    /* Three.js Background Canvas */
    #bgCanvas {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      z-index: -1;
      pointer-events: none;
    }

    /* Glassmorphism effects */
    .glass {
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(20px);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 20px;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
    }

    .glass-dark {
      background: rgba(0, 0, 0, 0.4);
      backdrop-filter: blur(20px);
      border: 1px solid rgba(255, 255, 255, 0.1);
    }

    /* Enhanced Navbar */
    .enhanced-navbar {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      z-index: 1000;
      background: linear-gradient(135deg, rgba(0, 0, 0, 0.8), rgba(20, 20, 40, 0.9));
      backdrop-filter: blur(20px);
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      transition: all 0.3s ease;
      padding: 1rem 0;
    }

    .navbar-brand {
      display: flex;
      align-items: center;
      font-size: 2rem;
      font-weight: 900;
      background: linear-gradient(45deg, #00ffff, #ff00ff, #ffff00);
      background-size: 300%;
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      animation: gradientShift 3s ease-in-out infinite;
    }

    @keyframes gradientShift {
      0%, 100% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
    }

    .nav-link {
      color: rgba(255, 255, 255, 0.8) !important;
      font-weight: 500;
      position: relative;
      transition: all 0.3s ease;
      margin: 0 0.5rem;
    }

    .nav-link:hover {
      color: #00ffff !important;
      transform: translateY(-2px);
    }

    .nav-link::after {
      content: '';
      position: absolute;
      bottom: -5px;
      left: 0;
      width: 0;
      height: 2px;
      background: linear-gradient(90deg, #00ffff, #ff00ff);
      transition: width 0.3s ease;
    }

    .nav-link:hover::after {
      width: 100%;
    }

    /* Dark Mode Toggle */
    .toggle-button {
      position: fixed;
      top: 1.5rem;
      right: 1.5rem;
      width: 60px;
      height: 60px;
      border: none;
      border-radius: 50%;
      background: linear-gradient(135deg, rgba(255, 255, 255, 0.2), rgba(255, 255, 255, 0.1));
      backdrop-filter: blur(20px);
      color: #00ffff;
      font-size: 1.5rem;
      cursor: pointer;
      z-index: 1001;
      transition: all 0.3s ease;
      box-shadow: 0 10px 30px rgba(0, 255, 255, 0.3);
    }

    .toggle-button:hover {
      transform: scale(1.1) rotate(180deg);
      box-shadow: 0 15px 40px rgba(0, 255, 255, 0.5);
    }

    /* Main Content */
    .main-content {
      margin-top: 120px;
      min-height: 100vh;
      position: relative;
      z-index: 1;
    }

    /* Enhanced Marquee */
    .marquee-container {
      background: linear-gradient(90deg, rgba(255, 0, 150, 0.2), rgba(0, 255, 255, 0.2));
      backdrop-filter: blur(15px);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 15px;
      padding: 15px 0;
      margin: 2rem 0;
      overflow: hidden;
      position: relative;
    }

    .marquee-text {
      display: inline-block;
      padding-left: 100%;
      animation: neonMarquee 25s linear infinite;
      font-weight: 700;
      font-size: 1.2rem;
      background: linear-gradient(45deg, #ff0080, #00ffff, #ffff00);
      background-size: 300%;
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      animation: neonMarquee 25s linear infinite, gradientShift 2s ease-in-out infinite;
      white-space: nowrap;
    }

    @keyframes neonMarquee {
      0% { transform: translateX(0%); }
      100% { transform: translateX(-100%); }
    }

    /* Category Buttons */
    .category-section {
      padding: 2rem 0;
      text-align: center;
    }

    .category-btn {
      display: inline-block;
      margin: 0.5rem;
      padding: 12px 25px;
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(15px);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 30px;
      color: #ffffff;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }

    .category-btn::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
      transition: left 0.5s ease;
    }

    .category-btn:hover::before {
      left: 100%;
    }

    .category-btn:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 30px rgba(0, 255, 255, 0.4);
      border-color: #00ffff;
      color: #00ffff;
    }

    .category-btn.active {
      background: linear-gradient(135deg, #ff0080, #00ffff);
      color: #ffffff;
      box-shadow: 0 10px 25px rgba(255, 0, 128, 0.4);
    }

    /* Search Section */
    .search-section {
      padding: 2rem 0;
    }

    .search-container {
      max-width: 600px;
      margin: 0 auto;
      position: relative;
    }

    .search-input-group {
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(20px);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 25px;
      overflow: hidden;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
    }

    .search-input {
      background: transparent;
      border: none;
      color: #ffffff;
      padding: 15px 20px;
      font-size: 1.1rem;
    }

    .search-input::placeholder {
      color: rgba(255, 255, 255, 0.6);
    }

    .search-input:focus {
      outline: none;
      box-shadow: inset 0 0 20px rgba(0, 255, 255, 0.2);
    }

    .search-btn {
      background: linear-gradient(135deg, #ff0080, #00ffff);
      border: none;
      color: #ffffff;
      padding: 15px 25px;
      font-weight: 600;
      transition: all 0.3s ease;
    }

    .search-btn:hover {
      background: linear-gradient(135deg, #00ffff, #ff0080);
      transform: scale(1.05);
    }

    /* Food Cards */
    .food-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
      gap: 2rem;
      padding: 2rem 0;
    }

    .food-card {
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(20px);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 25px;
      overflow: hidden;
      transition: all 0.4s ease;
      position: relative;
      transform-style: preserve-3d;
    }

    .food-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: linear-gradient(45deg, rgba(255, 0, 128, 0.1), rgba(0, 255, 255, 0.1));
      opacity: 0;
      transition: opacity 0.3s ease;
      z-index: -1;
    }

    .food-card:hover::before {
      opacity: 1;
    }

    .food-card:hover {
      transform: translateY(-15px) rotateX(5deg);
      box-shadow: 0 25px 50px rgba(0, 255, 255, 0.3);
      border-color: rgba(0, 255, 255, 0.5);
    }

    .food-image {
      width: 100%;
      height: 220px;
      object-fit: cover;
      transition: transform 0.4s ease;
    }

    .food-card:hover .food-image {
      transform: scale(1.1);
    }

    .food-badge {
      position: absolute;
      top: 15px;
      right: 15px;
      padding: 8px 15px;
      border-radius: 20px;
      font-weight: 700;
      font-size: 0.9rem;
      animation: pulse 2s infinite;
    }

    .badge-top-seller {
      background: linear-gradient(135deg, #ff0080, #ff4500);
      color: #ffffff;
      box-shadow: 0 5px 15px rgba(255, 0, 128, 0.4);
    }

    .badge-discount {
      background: linear-gradient(135deg, #ff4500, #ffd700);
      color: #000000;
      box-shadow: 0 5px 15px rgba(255, 215, 0, 0.4);
    }

    @keyframes pulse {
      0%, 100% { transform: scale(1); }
      50% { transform: scale(1.05); }
    }

    .food-content {
      padding: 1.5rem;
    }

    .food-title {
      font-size: 1.3rem;
      font-weight: 700;
      margin-bottom: 1rem;
      background: linear-gradient(45deg, #ffffff, #00ffff);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    .food-price {
      font-size: 1.2rem;
      font-weight: 700;
      margin-bottom: 1rem;
    }

    .price-original {
      color: rgba(255, 255, 255, 0.5);
      text-decoration: line-through;
      font-size: 1rem;
    }

    .price-discount {
      color: #ff4500;
      margin-left: 0.5rem;
    }

    .price-normal {
      color: #00ffff;
    }

    /* Quantity Controls */
    .quantity-controls {
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 1rem 0;
    }

    .qty-btn {
      width: 40px;
      height: 40px;
      border: 1px solid rgba(255, 255, 255, 0.3);
      background: rgba(255, 255, 255, 0.1);
      color: #ffffff;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .qty-btn:hover {
      background: rgba(0, 255, 255, 0.3);
      border-color: #00ffff;
      transform: scale(1.1);
    }

    .qty-input {
      width: 80px;
      height: 40px;
      margin: 0 10px;
      text-align: center;
      background: rgba(255, 255, 255, 0.1);
      border: 1px solid rgba(255, 255, 255, 0.3);
      border-radius: 10px;
      color: #ffffff;
      font-weight: 600;
    }

    /* Action Buttons */
    .action-btn {
      width: 100%;
      padding: 12px;
      border: none;
      border-radius: 15px;
      font-weight: 700;
      font-size: 1rem;
      cursor: pointer;
      transition: all 0.3s ease;
      margin-bottom: 0.5rem;
      position: relative;
      overflow: hidden;
    }

    .btn-add-cart {
      background: linear-gradient(135deg, #00ff80, #00ffff);
      color: #000000;
    }

    .btn-add-cart:hover {
      background: linear-gradient(135deg, #00ffff, #00ff80);
      transform: translateY(-2px);
      box-shadow: 0 10px 20px rgba(0, 255, 128, 0.4);
    }

    .btn-review {
      background: linear-gradient(135deg, rgba(255, 255, 255, 0.2), rgba(255, 255, 255, 0.1));
      color: #ffffff;
      border: 1px solid rgba(255, 255, 255, 0.3);
    }

    .btn-review:hover {
      background: linear-gradient(135deg, rgba(0, 255, 255, 0.3), rgba(255, 0, 128, 0.3));
      border-color: #00ffff;
    }

    /* Review Form */
    .review-form {
      display: none;
      background: rgba(0, 0, 0, 0.3);
      backdrop-filter: blur(15px);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 15px;
      padding: 1rem;
      margin-top: 1rem;
    }

    .review-form select,
    .review-form textarea {
      background: rgba(255, 255, 255, 0.1);
      border: 1px solid rgba(255, 255, 255, 0.3);
      border-radius: 10px;
      color: #ffffff;
      padding: 10px;
    }

    .review-form select:focus,
    .review-form textarea:focus {
      outline: none;
      border-color: #00ffff;
      box-shadow: 0 0 10px rgba(0, 255, 255, 0.3);
    }

    /* Rating Display */
    .rating-section {
      margin-top: 1rem;
      padding-top: 1rem;
      border-top: 1px solid rgba(255, 255, 255, 0.2);
    }

    .rating-score {
      color: #ffd700;
      font-weight: 700;
    }

    .comment-list {
      max-height: 120px;
      overflow-y: auto;
      margin-top: 0.5rem;
    }

    .comment-item {
      background: rgba(255, 255, 255, 0.05);
      border-radius: 10px;
      padding: 0.5rem;
      margin-bottom: 0.5rem;
      font-size: 0.9rem;
    }

    /* Footer */
    .enhanced-footer {
      background: linear-gradient(135deg, rgba(0, 0, 0, 0.8), rgba(20, 20, 40, 0.9));
      backdrop-filter: blur(20px);
      border-top: 1px solid rgba(255, 255, 255, 0.1);
      padding: 3rem 0;
      margin-top: 4rem;
      text-align: center;
    }

    .footer-content {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 2rem;
    }

    .footer-links {
      display: flex;
      justify-content: center;
      gap: 2rem;
      margin: 2rem 0;
    }

    .footer-link {
      color: rgba(255, 255, 255, 0.8);
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s ease;
    }

    .footer-link:hover {
      color: #00ffff;
      transform: translateY(-2px);
    }

    /* Toast Notification */
    .enhanced-toast {
      position: fixed;
      top: 100px;
      right: 2rem;
      background: linear-gradient(135deg, rgba(0, 255, 128, 0.9), rgba(0, 255, 255, 0.9));
      backdrop-filter: blur(20px);
      border: 1px solid rgba(255, 255, 255, 0.3);
      border-radius: 15px;
      padding: 1rem 1.5rem;
      color: #000000;
      font-weight: 700;
      z-index: 1100;
      transform: translateX(400px);
      transition: transform 0.4s ease;
    }

    .enhanced-toast.show {
      transform: translateX(0);
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      .food-grid {
        grid-template-columns: 1fr;
        gap: 1rem;
        padding: 1rem;
      }
      
      .navbar-brand {
        font-size: 1.5rem;
      }
      
      .main-content {
        margin-top: 100px;
      }
      
      .category-btn {
        margin: 0.25rem;
        padding: 10px 20px;
        font-size: 0.9rem;
      }
    }

    /* Loading Animation */
    .loading-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: #0a0a0a;
      display: flex;
      align-items: center;
      justify-content: center;
      z-index: 9999;
      opacity: 1;
      transition: opacity 0.5s ease;
    }

    .loading-overlay.hidden {
      opacity: 0;
      pointer-events: none;
    }

    .loader {
      width: 80px;
      height: 80px;
      border: 4px solid rgba(255, 255, 255, 0.1);
      border-left: 4px solid #00ffff;
      border-radius: 50%;
      animation: spin 1s linear infinite;
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }

    /* Scrollbar Styling */
    ::-webkit-scrollbar {
      width: 8px;
    }

    ::-webkit-scrollbar-track {
      background: rgba(255, 255, 255, 0.1);
    }

    ::-webkit-scrollbar-thumb {
      background: linear-gradient(135deg, #00ffff, #ff0080);
      border-radius: 4px;
    }

    ::-webkit-scrollbar-thumb:hover {
      background: linear-gradient(135deg, #ff0080, #00ffff);
    }
  </style>
</head>
<body>
  <!-- Loading Overlay -->
  <div class="loading-overlay" id="loadingOverlay">
    <div class="loader"></div>
  </div>

  <!-- Three.js Background Canvas -->
  <canvas id="bgCanvas"></canvas>

  <!-- Dark Mode Toggle -->
  <button class="toggle-button" id="darkModeToggle">
    <i class="fas fa-moon"></i>
  </button>

  <!-- Enhanced Navbar -->
  <nav class="enhanced-navbar">
    <div class="container-fluid px-4">
      <div class="d-flex justify-content-between align-items-center w-100">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/menu">
          <img src="${pageContext.request.contextPath}/assets/data/5abb9bbc-635e-4f3f-83ee-0b0540971d30.png"
               alt="AnhNT Logo" height="50" class="me-3"
               style="border-radius:15px;background:#fff;padding:5px;box-shadow:0 0 20px rgba(0,255,255,0.3)">
          AnhNT
        </a>

        <div class="d-flex align-items-center">
          <a class="nav-link" href="${pageContext.request.contextPath}/menu">
            <i class="fas fa-home me-1"></i>Trang chủ
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/support">
            <i class="fas fa-headset me-1"></i>Hỗ trợ
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/register">
            <i class="fas fa-user-plus me-1"></i>Đăng ký
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/cart">
            <i class="fas fa-shopping-cart me-1"></i>Giỏ hàng
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/order-history">
            <i class="fas fa-history me-1"></i>Lịch sử
          </a>
          <form action="logout" method="get" class="ms-3">
            <button type="submit" class="btn btn-outline-danger btn-sm">
              <i class="fas fa-sign-out-alt me-1"></i>Đăng xuất
            </button>
          </form>
        </div>
      </div>
    </div>
  </nav>

  <!-- Main Content -->
  <div class="main-content">
    <div class="container-fluid px-4">
      
      <!-- Hero Section with Marquee -->
      <div class="marquee-container">
        <div class="marquee-text">
          <c:forEach items="${foods}" var="f">
            <c:if test="${f.topSeller}">🔥 Top Seller: ${f.name}! &nbsp;&nbsp;&nbsp;</c:if>
            <c:if test="${f.discountPercent > 0}">💥 Giảm ${f.discountPercent}%: ${f.name}! &nbsp;&nbsp;&nbsp;</c:if>
          </c:forEach>
        </div>
      </div>

      <!-- Category Section -->
      <div class="category-section">
        <h2 class="text-center mb-4" style="font-size: 2.5rem; font-weight: 900; background: linear-gradient(45deg, #00ffff, #ff00ff); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
          Menu Đặc Biệt
        </h2>
        
        <div class="category-buttons">
          <a href="menu?categoryId=0" class="category-btn ${selectedCategoryId == 0 ? 'active' : ''}">
            <i class="fas fa-th-large me-2"></i>Tất cả
          </a>
          <c:forEach items="${categories}" var="c">
            <a href="menu?categoryId=${c.categoryId}" class="category-btn ${selectedCategoryId == c.categoryId ? 'active' : ''}">
              <i class="fas fa-utensils me-2"></i>${c.name}
            </a>
          </c:forEach>
        </div>
      </div>

      <!-- Search Section -->
      <div class="search-section">
        <div class="search-container">
          <form action="menu" method="get" class="search-input-group d-flex">
            <input type="hidden" name="categoryId" value="${selectedCategoryId}">
            <input type="text" name="keyword" class="search-input flex-grow-1"
                   value="${param.keyword != null ? param.keyword : ''}"
                   placeholder="Tìm món ăn yêu thích...">
            <button class="search-btn" type="submit">
              <i class="fas fa-search me-2"></i>Tìm
            </button>
            <button class="search-btn" type="button" onclick="startVoice()" title="Tìm bằng giọng nói">
              <i class="fas fa-microphone"></i>
            </button>
          </form>
        </div>
      </div>

      <!-- Food Grid -->
      <div class="food-grid">
        <c:forEach items="${sortedFoods}" var="f">
          <c:set var="discount" value="${f.discountPercent}" />
          <c:set var="price" value="${f.price}" />
          <c:set var="finalPrice" value="${discount > 0 ? price * (100 - discount) / 100.0 : price}" />

          <div class="food-card" data-food-id="${f.foodId}">
            <div style="position: relative;">
              <img src="${f.imageUrl != null ? f.imageUrl : 'default.png'}" 
                   class="food-image" alt="${f.name}">
              
              <c:if test="${f.topSeller}">
                <div class="food-badge badge-top-seller">
                  <i class="fas fa-fire me-1"></i>Top Seller
                </div>
              </c:if>
              <c:if test="${discount > 0}">
                <div class="food-badge badge-discount" style="top: ${f.topSeller ? '60px' : '15px'};">
                  <i class="fas fa-percentage me-1"></i>${discount}% OFF
                </div>
              </c:if>
            </div>

            <div class="food-content">
              <h5 class="food-title">${f.name}</h5>

              <!-- Price Section -->
              <div class="food-price">
                <c:choose>
                  <c:when test="${discount > 0}">
                    <span class="price-original">
                      <fmt:formatNumber value="${price}" type="number" groupingUsed="true"/> đ
                    </span>
                    <span class="price-discount">
                      <fmt:formatNumber value="${finalPrice}" type="number" groupingUsed="true"/> đ
                    </span>
                  </c:when>
                  <c:otherwise>
                    <span class="price-normal">
                      <fmt:formatNumber value="${price}" type="number" groupingUsed="true"/> đ
                    </span>
                  </c:otherwise>
                </c:choose>
              </div>

              <!-- Quantity Controls -->
              <div class="quantity-controls">
                <button type="button" class="qty-btn" onclick="changeQty('q_${f.foodId}', -1)">
                  <i class="fas fa-minus"></i>
                </button>
                <input type="number" id="q_${f.foodId}" name="quantity_${f.foodId}" 
                       value="1" min="1" class="qty-input">
                <button type="button" class="qty-btn" onclick="changeQty('q_${f.foodId}', 1)">
                  <i class="fas fa-plus"></i>
                </button>
              </div>

              <!-- Action Buttons -->
              <button type="button" class="action-btn btn-add-cart addToCartBtn" data-id="${f.foodId}">
                <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
              </button>

              <button type="button" class="action-btn btn-review" onclick="toggleReview(${f.foodId})">
                <i class="fas fa-star me-2"></i>Đánh giá
              </button>

              <!-- Review Form -->
              <form id="rvForm_${f.foodId}" class="review-form" method="post" action="submit-review">
                <input type="hidden" name="foodId" value="${f.foodId}">
                <div class="mb-3">
                  <label class="form-label">
                    <i class="fas fa-star text-warning me-2"></i>Số sao:
                  </label>
                  <select name="rating" class="form-select" required>
                    <option value="">Chọn số sao</option>
                    <c:forEach begin="1" end="5" var="i">
                      <option value="${i}">${i} ⭐</option>
                    </c:forEach>
                  </select>
                </div>
                <div class="mb-3">
                  <textarea name="comment" rows="3" class="form-control"
                            placeholder="Chia sẻ trải nghiệm của bạn..." required></textarea>
                </div>
                <button type="submit" class="action-btn btn-review">
                  <i class="fas fa-paper-plane me-2"></i>Gửi đánh giá
                </button>
              </form>

              <!-- Rating Section -->
              <div class="rating-section">
                <div class="d-flex align-items-center mb-2">
                  <i class="fas fa-chart-line me-2 text-warning"></i>
                  <strong>Điểm trung bình: </strong>
                  <span class="rating-score ms-2">
                    <c:choose>
                      <c:when test="${f.averageRating == 0}">
                        Chưa có đánh giá
                      </c:when>
                      <c:otherwise>
                        <fmt:formatNumber value="${f.averageRating}" type="number" maxFractionDigits="1"/> ⭐
                      </c:otherwise>
                    </c:choose>
                  </span>
                </div>
                
                <div class="comment-list">
                  <c:choose>
                    <c:when test="${not empty f.reviews}">
                      <c:forEach items="${f.reviews}" var="rv">
                        <div class="comment-item">
                          <div class="d-flex justify-content-between align-items-start mb-1">
                            <strong class="text-info">${rv.userName}</strong>
                            <span class="text-warning">${rv.rating}⭐</span>
                          </div>
                          <p class="mb-0" style="font-size: 0.9rem; opacity: 0.9;">${rv.comment}</p>
                        </div>
                      </c:forEach>
                    </c:when>
                    <c:otherwise>
                      <div class="comment-item text-center">
                        <i class="fas fa-comment-slash me-2"></i>
                        Chưa có bình luận nào
                      </div>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>

      <!-- Bottom Navigation -->
      <div class="text-center my-5">
        <a href="cart" class="action-btn btn-add-cart d-inline-block me-3" style="width: auto; padding: 15px 30px;">
          <i class="fas fa-shopping-cart me-2"></i>Xem giỏ hàng
        </a>
        <a href="order-history" class="action-btn btn-review d-inline-block" style="width: auto; padding: 15px 30px;">
          <i class="fas fa-history me-2"></i>Lịch sử đặt hàng
        </a>
      </div>
    </div>
  </div>

  <!-- Enhanced Footer -->
  <footer class="enhanced-footer">
    <div class="footer-content">
      <div class="navbar-brand mb-3" style="justify-content: center;">
        <img src="${pageContext.request.contextPath}/assets/data/5abb9bbc-635e-4f3f-83ee-0b0540971d30.png"
             alt="AnhNT Logo" height="40" class="me-2"
             style="border-radius:10px;background:#fff;padding:3px;">
        AnhNT Restaurant
      </div>
      
      <div class="footer-links">
        <a href="${pageContext.request.contextPath}/support" class="footer-link">
          <i class="fas fa-headset me-1"></i>Hỗ trợ
        </a>
        <a href="tel:0923894829" class="footer-link">
          <i class="fas fa-phone me-1"></i>0923894829
        </a>
        <a href="#" class="footer-link">
          <i class="fas fa-map-marker-alt me-1"></i>Hoà Lạc – Thạch Thất – Hà Nội
        </a>
      </div>
      
      <div class="mt-3">
        <p>&copy; 2025 AnhNT Restaurant. All rights reserved.</p>
        <p style="font-style: italic; opacity: 0.8;">
          <i class="fas fa-code me-1"></i>Thiết kế bởi AnhNT với ❤️
        </p>
      </div>
    </div>
  </footer>

  <!-- Enhanced Toast Notification -->
  <div id="enhancedToast" class="enhanced-toast">
    <i class="fas fa-check-circle me-2"></i>
    <span>Thêm vào giỏ hàng thành công!</span>
  </div>

  <!-- Scripts -->
  <script type="text/javascript">
    var Tawk_API=Tawk_API||{},Tawk_LoadStart=new Date();
    (function(){var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
    s1.async=true;s1.src='https://embed.tawk.to/682fdb25179334190b34110a/1irtf037k';
    s1.charset='UTF-8';s1.setAttribute('crossorigin','*');s0.parentNode.insertBefore(s1,s0);})();
  </script>

  <script>
    // Enhanced Three.js Background
    class EnhancedBackground {
      constructor() {
        this.scene = new THREE.Scene();
        this.camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        this.renderer = new THREE.WebGLRenderer({ 
          canvas: document.getElementById('bgCanvas'), 
          alpha: true, 
          antialias: true 
        });
        
        this.init();
        this.createParticles();
        this.createWaves();
        this.animate();
        this.handleResize();
      }

      init() {
        this.renderer.setSize(window.innerWidth, window.innerHeight);
        this.renderer.setClearColor(0x000000, 0);
        this.camera.position.z = 50;
      }

      createParticles() {
        const particleCount = 300;
        const geometry = new THREE.BufferGeometry();
        const positions = new Float32Array(particleCount * 3);
        const colors = new Float32Array(particleCount * 3);
        const sizes = new Float32Array(particleCount);

        for(let i = 0; i < particleCount; i++) {
          positions[i * 3] = (Math.random() - 0.5) * 200;
          positions[i * 3 + 1] = (Math.random() - 0.5) * 200;
          positions[i * 3 + 2] = (Math.random() - 0.5) * 200;

          // Gradient colors: cyan to magenta
          const t = Math.random();
          colors[i * 3] = t; // R
          colors[i * 3 + 1] = 1 - t; // G  
          colors[i * 3 + 2] = 1; // B

          sizes[i] = Math.random() * 3 + 1;
        }

        geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
        geometry.setAttribute('color', new THREE.BufferAttribute(colors, 3));
        geometry.setAttribute('size', new THREE.BufferAttribute(sizes, 1));

        const material = new THREE.ShaderMaterial({
          uniforms: {
            time: { value: 0 }
          },
          vertexShader: `
            attribute float size;
            attribute vec3 color;
            varying vec3 vColor;
            uniform float time;
            
            void main() {
              vColor = color;
              vec4 mvPosition = modelViewMatrix * vec4(position, 1.0);
              
              // Floating animation
              mvPosition.y += sin(time * 0.01 + position.x * 0.01) * 10.0;
              mvPosition.x += cos(time * 0.008 + position.z * 0.01) * 5.0;
              
              gl_PointSize = size * (300.0 / -mvPosition.z);
              gl_Position = projectionMatrix * mvPosition;
            }
          `,
          fragmentShader: `
            varying vec3 vColor;
            
            void main() {
              float dist = distance(gl_PointCoord, vec2(0.5));
              if (dist > 0.5) discard;
              
              float alpha = 1.0 - (dist * 2.0);
              gl_FragColor = vec4(vColor, alpha * 0.8);
            }
          `,
          transparent: true,
          vertexColors: true,
          blending: THREE.AdditiveBlending
        });

        this.particles = new THREE.Points(geometry, material);
        this.scene.add(this.particles);
      }

      createWaves() {
        const waveGeometry = new THREE.PlaneGeometry(200, 200, 50, 50);
        const waveMaterial = new THREE.ShaderMaterial({
          uniforms: {
            time: { value: 0 },
            color1: { value: new THREE.Color(0x00ffff) },
            color2: { value: new THREE.Color(0xff00ff) }
          },
          vertexShader: `
            uniform float time;
            varying vec2 vUv;
            varying float vElevation;
            
            void main() {
              vUv = uv;
              
              vec4 modelPosition = modelMatrix * vec4(position, 1.0);
              float elevation = sin(modelPosition.x * 0.05 + time * 0.001) * 
                               sin(modelPosition.y * 0.05 + time * 0.001) * 15.0;
              
              modelPosition.z += elevation;
              vElevation = elevation;
              
              gl_Position = projectionMatrix * viewMatrix * modelPosition;
            }
          `,
          fragmentShader: `
            uniform vec3 color1;
            uniform vec3 color2;
            varying vec2 vUv;
            varying float vElevation;
            
            void main() {
              float mixStrength = (vElevation + 15.0) / 30.0;
              vec3 color = mix(color1, color2, mixStrength);
              gl_FragColor = vec4(color, 0.1);
            }
          `,
          transparent: true,
          wireframe: true
        });

        this.waves = new THREE.Mesh(waveGeometry, waveMaterial);
        this.waves.rotation.x = -Math.PI * 0.3;
        this.waves.position.z = -30;
        this.scene.add(this.waves);
      }

      animate() {
        requestAnimationFrame(() => this.animate());
        
        const time = Date.now();
        
        // Update particles
        if (this.particles) {
          this.particles.material.uniforms.time.value = time;
          this.particles.rotation.y += 0.001;
        }
        
        // Update waves
        if (this.waves) {
          this.waves.material.uniforms.time.value = time;
        }
        
        this.renderer.render(this.scene, this.camera);
      }

      handleResize() {
        window.addEventListener('resize', () => {
          const width = window.innerWidth;
          const height = window.innerHeight;
          
          this.camera.aspect = width / height;
          this.camera.updateProjectionMatrix();
          this.renderer.setSize(width, height);
        });
      }
    }

    // Initialize Enhanced Background
    document.addEventListener('DOMContentLoaded', () => {
      // Hide loading overlay
      setTimeout(() => {
        document.getElementById('loadingOverlay').classList.add('hidden');
      }, 1500);

      new EnhancedBackground();
      
      // Animate food cards on scroll
      const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
      };

      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            gsap.fromTo(entry.target, 
              { 
                opacity: 0, 
                y: 50, 
                scale: 0.9 
              }, 
              { 
                opacity: 1, 
                y: 0, 
                scale: 1, 
                duration: 0.8, 
                ease: "back.out(1.7)" 
              }
            );
            observer.unobserve(entry.target);
          }
        });
      }, observerOptions);

      document.querySelectorAll('.food-card').forEach(card => {
        observer.observe(card);
      });

      // Animate category buttons
      gsap.fromTo('.category-btn', 
        { opacity: 0, y: 30 }, 
        { 
          opacity: 1, 
          y: 0, 
          duration: 0.6, 
          stagger: 0.1, 
          ease: "power2.out",
          delay: 0.5
        }
      );

      // Animate search section
      gsap.fromTo('.search-container', 
        { opacity: 0, scale: 0.9 }, 
        { 
          opacity: 1, 
          scale: 1, 
          duration: 0.8, 
          ease: "back.out(1.7)",
          delay: 0.3
        }
      );
    });

    // Enhanced Dark Mode Toggle
    const toggleButton = document.getElementById('darkModeToggle');
    let isDarkMode = true; // Default to dark mode

    toggleButton.addEventListener('click', () => {
      isDarkMode = !isDarkMode;
      
      if (isDarkMode) {
        document.body.style.background = '#0a0a0a';
        toggleButton.innerHTML = '<i class="fas fa-moon"></i>';
      } else {
        document.body.style.background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
        toggleButton.innerHTML = '<i class="fas fa-sun"></i>';
      }

      // Animate toggle
      gsap.to(toggleButton, {
        rotation: 360,
        duration: 0.5,
        ease: "power2.out"
      });
    });

    // Voice Search Function
    function startVoice() {
      if (!('webkitSpeechRecognition' in window)) {
        alert("Trình duyệt không hỗ trợ tìm kiếm bằng giọng nói.");
        return;
      }

      const recognition = new webkitSpeechRecognition();
      recognition.lang = 'vi-VN';
      recognition.interimResults = false;
      recognition.maxAlternatives = 1;

      // Animate microphone button
      const micBtn = event.target.closest('button');
      gsap.to(micBtn, {
        scale: 1.2,
        duration: 0.1,
        yoyo: true,
        repeat: -1
      });

      recognition.onresult = function(event) {
        const transcript = event.results[0][0].transcript;
        document.querySelector('input[name="keyword"]').value = transcript;
        
        // Stop animation
        gsap.killTweensOf(micBtn);
        gsap.to(micBtn, { scale: 1, duration: 0.2 });
        
        document.querySelector('form').submit();
      };

      recognition.onerror = function(event) {
        gsap.killTweensOf(micBtn);
        gsap.to(micBtn, { scale: 1, duration: 0.2 });
        alert("Không nhận được giọng nói. Vui lòng thử lại.");
      };

      recognition.start();
    }

    // Quantity Control Functions
    function changeQty(id, delta) {
      const inp = document.getElementById(id);
      let v = parseInt(inp.value) || 1;
      v = Math.max(1, v + delta);
      inp.value = v;
      
      // Animate input
      gsap.to(inp, {
        scale: 1.1,
        duration: 0.1,
        yoyo: true,
        repeat: 1
      });
    }

    function toggleReview(foodId) {
      const form = document.getElementById('rvForm_' + foodId);
      const isVisible = form.style.display === 'block';
      
      if (isVisible) {
        gsap.to(form, {
          opacity: 0,
          height: 0,
          duration: 0.3,
          ease: "power2.out",
          onComplete: () => {
            form.style.display = 'none';
          }
        });
      } else {
        form.style.display = 'block';
        gsap.fromTo(form, 
          { opacity: 0, height: 0 },
          { 
            opacity: 1, 
            height: 'auto', 
            duration: 0.3, 
            ease: "power2.out" 
          }
        );
      }
    }

    // Enhanced Add to Cart with Animation
    $(function() {
      $('.addToCartBtn').click(function() {
        const button = $(this);
        const id = button.data('id');
        const qty = $('input[name="quantity_' + id + '"]').val();
        
        // Animate button
        gsap.to(button[0], {
          scale: 0.95,
          duration: 0.1,
          yoyo: true,
          repeat: 1
        });

        $.post('${pageContext.request.contextPath}/cart', 
          { addToCart: id, ['quantity_' + id]: qty },
          function(response) {
            // Show enhanced toast
            const toast = document.getElementById('enhancedToast');
            toast.classList.add('show');
            
            setTimeout(() => {
              toast.classList.remove('show');
            }, 3000);

            // Animate success effect
            gsap.to(button[0], {
              backgroundColor: '#00ff80',
              duration: 0.3,
              yoyo: true,
              repeat: 1
            });
          }
        );
      });
    });

    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
      anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
          gsap.to(window, {
            duration: 1,
            scrollTo: target,
            ease: "power2.out"
          });
        }
      });
    });

    // Add parallax effect to cards on mouse move
    document.addEventListener('mousemove', (e) => {
      const cards = document.querySelectorAll('.food-card');
      const x = e.clientX / window.innerWidth;
      const y = e.clientY / window.innerHeight;
      
      cards.forEach((card, index) => {
        const speed = (index % 3 + 1) * 0.5;
        gsap.to(card, {
          duration: 1,
          x: (x - 0.5) * speed * 20,
          y: (y - 0.5) * speed * 10,
          ease: "power2.out"
        });
      });
    });
  </script>
</body>
</html>