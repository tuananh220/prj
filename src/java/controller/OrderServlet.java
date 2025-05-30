/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.CartDAO;
import dal.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.CartItem;
import model.Food;
import model.Order;
import model.OrderDetail;

/**
 *
 * @author Admin
 */
public class OrderServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet OrderServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OrderServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
    }
    

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         HttpSession session = request.getSession(false);
    Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Lấy thông tin từ form
    String deliveryAddress = request.getParameter("delivery_address");
    String deliveryPhone = request.getParameter("delivery_phone");
    String note = request.getParameter("note");

    // Validate đơn giản (bạn có thể thêm kiểm tra phức tạp hơn)
    if (deliveryAddress == null || deliveryAddress.trim().isEmpty() ||
        deliveryPhone == null || deliveryPhone.trim().isEmpty()) {
        request.setAttribute("error", "Vui lòng nhập đầy đủ địa chỉ và số điện thoại.");
        request.getRequestDispatcher("cart.jsp").forward(request, response);
        return;
    }

    CartDAO cartDAO = new CartDAO();
    List<CartItem> cartItems;
    try {
        cartItems = cartDAO.getCartItemsByUserId(userId);
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }
    } catch (SQLException ex) {
        throw new ServletException("Lỗi khi lấy giỏ hàng: " + ex.getMessage(), ex);
    }

    double total = 0;
    List<OrderDetail> details = new ArrayList<>();
    for (CartItem ci : cartItems) {
        total += ci.getQuantity() * ci.getPrice();

        Food f = new Food();
        f.setFoodId(ci.getFoodId());
        f.setName(ci.getFoodName());
        f.setPrice(ci.getPrice());

        OrderDetail od = new OrderDetail();
        od.setFood(f);
        od.setQuantity(ci.getQuantity());
        od.setPrice(ci.getPrice());
        details.add(od);
    }

    Order order = new Order();
    order.setUserId(userId);
    order.setOrderDate(new Date());
    order.setTotalAmount(total);
    order.setStatus("Pending");
    order.setOrderDetails(details);

    // Set thêm các trường mới
    order.setDeliveryAddress(deliveryAddress);
    order.setDeliveryPhone(deliveryPhone);
    order.setNote(note);

    OrderDAO orderDAO = new OrderDAO();
    int orderId;
    try {
        orderId = orderDAO.createOrder(order);
        cartDAO.clear(userId);
    } catch (SQLException ex) {
        throw new ServletException("Lỗi tạo đơn hàng: " + ex.getMessage(), ex);
    }

    request.setAttribute("orderId", orderId);
request.setAttribute("orderDate", order.getOrderDate());
request.setAttribute("totalAmount", total);
request.setAttribute("status", order.getStatus());
request.setAttribute("orderDetails", details);
request.getRequestDispatcher("order-success.jsp").forward(request, response);

}
    

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
