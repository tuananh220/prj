<%@ page import="java.util.List" %>
<%@ page import="model.CartItem" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Giỏ hàng</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <style>
    :root {
      --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      --success-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
      --danger-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
      --card-shadow: 0 10px 30px rgba(0,0,0,0.1);
      --hover-shadow: 0 15px 40px rgba(0,0,0,0.15);
      --border-radius: 16px;
    }

    * {
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    body {
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      margin: 0;
      padding: 0;
      min-height: 100vh;
    }

    /* Header Section */
    .header-section {
      background: var(--primary-gradient);
      color: white;
      padding: 60px 0 40px;
      position: relative;
      overflow: hidden;
    }

    .header-section::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="10" r="0.5" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
      pointer-events: none;
    }

    .header-content {
      position: relative;
      z-index: 2;
    }

    .cart-title {
      font-size: 2.5rem;
      font-weight: 700;
      margin-bottom: 10px;
      text-shadow: 0 2px 10px rgba(0,0,0,0.2);
    }

    .cart-subtitle {
      font-size: 1.1rem;
      opacity: 0.9;
      font-weight: 300;
    }

    /* Main Container */
    .main-container {
      margin-top: -30px;
      position: relative;
      z-index: 10;
      padding: 0 20px 60px;
    }

    .cart-card {
      background: white;
      border-radius: var(--border-radius);
      box-shadow: var(--card-shadow);
      overflow: hidden;
      margin-bottom: 30px;
      border: 1px solid rgba(255,255,255,0.2);
    }

    .cart-card:hover {
      box-shadow: var(--hover-shadow);
      transform: translateY(-2px);
    }

    /* Table Styling */
    .modern-table {
      margin: 0;
      border: none;
    }

    .modern-table thead {
      background: var(--primary-gradient);
      color: white;
    }

    .modern-table th {
      border: none;
      padding: 20px 15px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      font-size: 0.85rem;
    }

    .modern-table td {
      border: none;
      padding: 25px 15px;
      vertical-align: middle;
      border-bottom: 1px solid #f8f9fa;
    }

    .modern-table tbody tr:hover {
      background: linear-gradient(90deg, #f8f9ff 0%, #fff 100%);
      transform: scale(1.01);
    }

    /* Food Item Cell */
    .food-name {
      font-weight: 600;
      color: #2d3748;
      font-size: 1.1rem;
    }

    /* Quantity Controls */
    .quantity-controls {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
    }

    .quantity-input {
      width: 70px;
      height: 40px;
      border: 2px solid #e2e8f0;
      border-radius: 8px;
      text-align: center;
      font-weight: 600;
      font-size: 16px;
      background: #f7fafc;
    }

    .quantity-input:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
      outline: none;
    }

    /* Modern Buttons */
    .btn-modern {
      border: none;
      border-radius: 10px;
      font-weight: 600;
      padding: 8px 16px;
      font-size: 0.875rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      position: relative;
      overflow: hidden;
    }

    .btn-modern::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
      transition: left 0.5s;
    }

    .btn-modern:hover::before {
      left: 100%;
    }

    .btn-update {
      background: var(--success-gradient);
      color: white;
      box-shadow: 0 4px 15px rgba(79, 172, 254, 0.3);
    }

    .btn-update:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(79, 172, 254, 0.4);
    }

    .btn-delete {
      background: var(--danger-gradient);
      color: white;
      box-shadow: 0 4px 15px rgba(250, 112, 154, 0.3);
    }

    .btn-delete:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(250, 112, 154, 0.4);
    }

    /* Price Display */
    .price-display {
      font-weight: 700;
      color: #2d3748;
      font-size: 1.1rem;
    }

    .total-price {
      background: var(--success-gradient);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      font-size: 1.3rem;
    }

    /* Total Section */
    .total-section {
      background: white;
      border-radius: var(--border-radius);
      padding: 30px;
      box-shadow: var(--card-shadow);
      text-align: right;
      margin-bottom: 30px;
    }

    .total-label {
      font-size: 1.5rem;
      color: #4a5568;
      margin-bottom: 10px;
    }

    .total-amount {
      font-size: 2.5rem;
      font-weight: 800;
      background: var(--success-gradient);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    /* Address Form */
    .address-form-container {
      background: white;
      border-radius: var(--border-radius);
      padding: 40px;
      box-shadow: var(--card-shadow);
      margin-bottom: 30px;
    }

    .form-section-title {
      font-size: 1.5rem;
      font-weight: 700;
      color: #2d3748;
      margin-bottom: 30px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .form-section-title::before {
      content: '';
      width: 4px;
      height: 30px;
      background: var(--primary-gradient);
      border-radius: 2px;
    }

    .form-group {
      margin-bottom: 25px;
    }

    .form-label {
      font-weight: 600;
      color: #4a5568;
      margin-bottom: 8px;
      display: block;
      font-size: 0.95rem;
    }

    .form-control-modern {
      width: 100%;
      padding: 15px 18px;
      border: 2px solid #e2e8f0;
      border-radius: 12px;
      font-size: 16px;
      background: #f7fafc;
      transition: all 0.3s ease;
    }

    .form-control-modern:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
      outline: none;
      background: white;
    }

    .form-select-modern {
      appearance: none;
      background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='M6 8l4 4 4-4'/%3e%3c/svg%3e");
      background-position: right 12px center;
      background-repeat: no-repeat;
      background-size: 16px;
      padding-right: 45px;
    }

    /* Order Button */
    .order-button {
      width: 100%;
      padding: 20px;
      border: none;
      border-radius: 15px;
      font-size: 1.3rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 1px;
      background: var(--success-gradient);
      color: white;
      box-shadow: 0 10px 30px rgba(79, 172, 254, 0.3);
      position: relative;
      overflow: hidden;
    }

    .order-button:hover:not(:disabled) {
      transform: translateY(-3px);
      box-shadow: 0 15px 40px rgba(79, 172, 254, 0.4);
    }

    .order-button:disabled {
      opacity: 0.6;
      cursor: not-allowed;
      transform: none;
    }

    .order-button::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
      transition: left 0.6s;
    }

    .order-button:hover::before {
      left: 100%;
    }

    /* Continue Shopping */
    .continue-shopping {
      text-align: center;
      margin-top: 30px;
    }

    .continue-link {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      padding: 15px 30px;
      background: white;
      color: #667eea;
      text-decoration: none;
      border-radius: 12px;
      font-weight: 600;
      box-shadow: var(--card-shadow);
      border: 2px solid #667eea;
    }

    .continue-link:hover {
      background: #667eea;
      color: white;
      transform: translateY(-2px);
      text-decoration: none;
    }

    /* Empty Cart */
    .empty-cart {
      text-align: center;
      padding: 80px 20px;
      background: white;
      border-radius: var(--border-radius);
      box-shadow: var(--card-shadow);
    }

    .empty-cart-icon {
      font-size: 4rem;
      color: #cbd5e0;
      margin-bottom: 20px;
    }

    .empty-cart-text {
      font-size: 1.3rem;
      color: #718096;
      margin-bottom: 30px;
    }

    /* Loading States */
    .loading-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0,0,0,0.5);
      display: none;
      justify-content: center;
      align-items: center;
      z-index: 9999;
    }

    .loading-spinner {
      width: 50px;
      height: 50px;
      border: 3px solid #f3f3f3;
      border-top: 3px solid #667eea;
      border-radius: 50%;
      animation: spin 1s linear infinite;
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }

    /* Responsive Design */
    @media (max-width: 768px) {
      .cart-title {
        font-size: 2rem;
      }
      
      .modern-table th,
      .modern-table td {
        padding: 15px 8px;
        font-size: 0.9rem;
      }
      
      .quantity-input {
        width: 60px;
        height: 35px;
      }
      
      .address-form-container {
        padding: 25px;
      }
      
      .order-button {
        font-size: 1.1rem;
        padding: 18px;
      }
      
      .total-amount {
        font-size: 2rem;
      }
    }

    /* Animation Classes */
    .fade-in {
      animation: fadeIn 0.6s ease-out;
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: translateY(20px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .bounce-in {
      animation: bounceIn 0.8s ease-out;
    }

    @keyframes bounceIn {
      0% {
        opacity: 0;
        transform: scale(0.3);
      }
      50% {
        opacity: 1;
        transform: scale(1.05);
      }
      70% {
        transform: scale(0.9);
      }
      100% {
        opacity: 1;
        transform: scale(1);
      }
    }
  </style>
</head>
<body>

<!-- Loading Overlay -->
<div class="loading-overlay" id="loadingOverlay">
  <div class="loading-spinner"></div>
</div>

<!-- Header Section -->
<div class="header-section">
  <div class="container">
    <div class="header-content text-center">
      <h1 class="cart-title">
        <i class="fas fa-shopping-cart me-3"></i>
        Giỏ hàng của bạn
      </h1>
      <p class="cart-subtitle">Xem lại đơn hàng và hoàn tất thanh toán</p>
    </div>
  </div>
</div>

<div class="container main-container">
  <%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    double total = 0;
    if (cartItems != null && !cartItems.isEmpty()) {
  %>

  <!-- Cart Items -->
  <div class="cart-card fade-in">
    <div class="table-responsive">
      <table class="table modern-table">
        <thead>
          <tr>
            <th><i class="fas fa-utensils me-2"></i>Tên món</th>
            <th><i class="fas fa-sort-numeric-up me-2"></i>Số lượng</th>
            <th><i class="fas fa-tag me-2"></i>Giá</th>
            <th><i class="fas fa-calculator me-2"></i>Thành tiền</th>
            <th><i class="fas fa-cog me-2"></i>Thao tác</th>
          </tr>
        </thead>
        <tbody>
        <% for (CartItem item : cartItems) {
             double sub = item.getQuantity()*item.getPrice();
             total += sub; %>
          <tr>
            <td>
              <div class="food-name"><%= item.getFoodName() %></div>
            </td>

            <td>
              <form action="cart" method="post" class="quantity-controls">
                <input type="hidden" name="updateId" value="<%= item.getFoodId() %>">
                <input type="number" name="quantity" min="1" value="<%= item.getQuantity() %>" 
                       class="quantity-input form-control-modern">
                <button class="btn btn-modern btn-update">
                  <i class="fas fa-sync-alt me-1"></i>Cập nhật
                </button>
              </form>
            </td>

            <td>
              <div class="price-display">
                <i class="fas fa-dong-sign me-1"></i><%= item.getPrice() %>
              </div>
            </td>
            
            <td>
              <div class="price-display total-price">
                <i class="fas fa-dong-sign me-1"></i><%= sub %>
              </div>
            </td>

            <td>
              <form action="cart" method="post" onsubmit="return confirm('Bạn có chắc muốn xóa món này?');">
                <input type="hidden" name="removeId" value="<%= item.getFoodId() %>">
                <button class="btn btn-modern btn-delete">
                  <i class="fas fa-trash-alt me-1"></i>Xóa
                </button>
              </form>
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Total Section -->
  <div class="total-section bounce-in">
    <div class="total-label">Tổng cộng:</div>
    <div class="total-amount">
      <i class="fas fa-dong-sign me-2"></i><%= total %>
    </div>
  </div>
  
  <!-- Address Form -->
  <div class="address-form-container fade-in">
    <div class="form-section-title">
      <i class="fas fa-map-marker-alt"></i>
      Thông tin giao hàng
    </div>
    
    <form action="order" method="post" onsubmit="return prepareAddress();">
      <div class="row">
        <div class="col-md-4">
          <div class="form-group">
            <label class="form-label">
              <i class="fas fa-city me-2"></i>Tỉnh/Thành phố:
            </label>
            <select id="province" name="province" class="form-control-modern form-select-modern" required>
              <option value="">-- Chọn tỉnh/thành phố --</option>
            </select>
          </div>
        </div>
        
        <div class="col-md-4">
          <div class="form-group">
            <label class="form-label">
              <i class="fas fa-building me-2"></i>Quận/Huyện:
            </label>
            <select id="district" name="district" class="form-control-modern form-select-modern" required>
              <option value="">-- Chọn quận/huyện --</option>
            </select>
          </div>          
        </div>
        
        <div class="col-md-4">
          <div class="form-group">
            <label class="form-label">
              <i class="fas fa-map me-2"></i>Phường/Xã:
            </label>
            <select id="commune" name="commune" class="form-control-modern form-select-modern" required>
              <option value="">-- Chọn phường/xã --</option>
            </select>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-md-8">
          <div class="form-group">
            <label class="form-label">
              <i class="fas fa-road me-2"></i>Tên đường:
            </label>
            <input type="text" id="street_name" name="street_name" class="form-control-modern" required />
          </div>
        </div>
        
        <div class="col-md-4">
          <div class="form-group">
            <label class="form-label">
              <i class="fas fa-home me-2"></i>Số nhà:
            </label>
            <input type="text" id="house_number" name="house_number" class="form-control-modern" required />
          </div>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">
          <i class="fas fa-phone me-2"></i>Số điện thoại giao hàng:
        </label>
        <input type="text" id="delivery_phone" name="delivery_phone" class="form-control-modern" required
               pattern="0[0-9]{9}" title="Số điện thoại phải bắt đầu bằng 0 và có 10 chữ số">
      </div>

      <div class="form-group">
        <label class="form-label">
          <i class="fas fa-sticky-note me-2"></i>Ghi chú đơn hàng (tùy chọn):
        </label>
        <textarea id="note" name="note" rows="3" class="form-control-modern" 
                  placeholder="Nhập ghi chú nếu có..."></textarea>
      </div>

      <input type="hidden" id="delivery_address" name="delivery_address" />

      <button id="btnOrder" type="submit" class="order-button" disabled>
        <i class="fas fa-shopping-bag me-2"></i>
        Đặt hàng ngay
      </button>
    </form>
  </div>

  <div class="continue-shopping">
    <a href="menu" class="continue-link">
      <i class="fas fa-arrow-left"></i>
      Tiếp tục chọn món
    </a>
  </div>

  <% } else { %>
    <div class="empty-cart fade-in">
      <div class="empty-cart-icon">
        <i class="fas fa-shopping-cart"></i>
      </div>
      <div class="empty-cart-text">Giỏ hàng của bạn đang trống</div>
      <a href="menu" class="continue-link">
        <i class="fas fa-utensils me-2"></i>
        Khám phá thực đơn
      </a>
    </div>
  <% } %>
</div>

<script>
  let data;
  let districtData = [];
  let communeData = [];
  const orderBtn = document.getElementById('btnOrder');
  const loadingOverlay = document.getElementById('loadingOverlay');
  
  // Show loading initially
  orderBtn.disabled = true;
  loadingOverlay.style.display = 'flex';

  fetch('<%=request.getContextPath()%>/assets/data/db.json')
    .then(res => res.json())
    .then(json => {
      data = json;
      districtData = data.district;
      communeData = data.commune;

      const provinceSelect = document.getElementById('province');
      data.province.forEach(p => {
        const opt = document.createElement('option');
        opt.value = p.idProvince;
        opt.textContent = p.name;
        provinceSelect.appendChild(opt);
      });

      // Hide loading and enable form
      loadingOverlay.style.display = 'none';
      orderBtn.disabled = false;
    })
    .catch(err => {
      console.error('Lỗi load JSON:', err);
      loadingOverlay.style.display = 'none';
      alert('Không tải được dữ liệu địa chỉ!');
    });

  document.getElementById('province').addEventListener('change', e => {
    const provinceId = e.target.value;
    const districtSelect = document.getElementById('district');
    const communeSelect = document.getElementById('commune');

    districtSelect.innerHTML = '<option value="">-- Chọn quận/huyện --</option>';
    communeSelect.innerHTML = '<option value="">-- Chọn phường/xã --</option>';

    if (!provinceId) return;

    districtData
      .filter(d => String(d.idProvince) === provinceId)
      .forEach(d => {
        const opt = document.createElement('option');
        opt.value = d.idDistrict;
        opt.textContent = d.name;
        districtSelect.appendChild(opt);
      });
  });

  document.getElementById('district').addEventListener('change', e => {
    const districtId = e.target.value;
    const communeSelect = document.getElementById('commune');

    communeSelect.innerHTML = '<option value="">-- Chọn phường/xã --</option>';

    if (!districtId) return;

    communeData
      .filter(c => String(c.idDistrict) === districtId)
      .forEach(c => {
        const opt = document.createElement('option');
        opt.value = c.idCommune;
        opt.textContent = c.name;
        communeSelect.appendChild(opt);
      });
  });

  function enableIfReady() {
    const provId = province.value;
    const distId = district.value;
    const comId = commune.value;
    orderBtn.disabled = !(data && provId && distId && comId);
  }

  province.addEventListener('change', enableIfReady);
  district.addEventListener('change', enableIfReady);
  commune.addEventListener('change', enableIfReady);

  function prepareAddress() {
    if (!data) {
      alert('Dữ liệu địa chỉ chưa tải xong, vui lòng đợi');
      return false;
    }
    
    const house = document.getElementById('house_number').value.trim();
    const street = document.getElementById('street_name').value.trim();
    const provId = document.getElementById('province').value;
    const distId = document.getElementById('district').value;
    const comId = document.getElementById('commune').value;
    
    if (!house || !street || !provId || !distId || !comId) {
      alert('Vui lòng nhập đầy đủ thông tin địa chỉ');
      return false;
    }

    const prov = data.province.find(p => p.idProvince === provId)?.name || '';
    const dist = districtData.find(d => d.idDistrict === distId)?.name || '';
    const com = communeData.find(c => c.idCommune === comId)?.name || '';

    const fullAddress = [house, street, com, dist, prov]
      .filter(part => part && part.trim() !== '')
      .join(', ');
      
    document.getElementById('delivery_address').value = fullAddress;

    // Show loading during form submission
    loadingOverlay.style.display = 'flex';
    return true;
  }

  // Add smooth scroll behavior
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      document.querySelector(this.getAttribute('href')).scrollIntoView({
        behavior: 'smooth'
      });
    });
  });

  // Add loading states to buttons
  document.querySelectorAll('form').forEach(form => {
    form.addEventListener('submit', function() {
      const submitBtn = this.querySelector('button[type="submit"]');
      if (submitBtn) {
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
        submitBtn.disabled = true;
      }
    });
  });
</script>

<!-- Chatbox Tawk.to giữ nguyên -->
<script type="text/javascript">
var Tawk_API=Tawk_API||{},Tawk_LoadStart=new Date();
(function(){var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
s1.async=true;s1.src='https://embed.tawk.to/682fdb25179334190b34110a/1irtf037k';
s1.charset='UTF-8';s1.setAttribute('crossorigin','*');s0.parentNode.insertBefore(s1,s0);})();
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>