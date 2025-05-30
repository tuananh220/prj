/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.CategoryDAO;
import dal.FoodDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Category;
import model.Food;
import model.User;

/**
 *
 * @author Admin
 */
public class AddFoodServlet extends HttpServlet {
    private final FoodDAO foodDAO = new FoodDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
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
            out.println("<title>Servlet AddFoodServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddFoodServlet at " + request.getContextPath () + "</h1>");
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
         HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("user") == null) {
        // Chưa đăng nhập -> chuyển hướng về trang login
        response.sendRedirect("login.jsp");
        return;
    }

    User user = (User) session.getAttribute("user");
    if (!"admin".equals(user.getRole())) {
        // Không phải admin -> thông báo lỗi hoặc chuyển hướng
        response.getWriter().println("Access denied. Bạn không có quyền truy cập.");
        return;
    }
        // Lấy danh sách danh mục để hiển thị trong form
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("categories", categories);
        request.getRequestDispatcher("add-food.jsp").forward(request, response);
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
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    User user = (User) session.getAttribute("user");
    if (!"admin".equals(user.getRole())) {
        response.getWriter().println("Access denied. Bạn không có quyền thực hiện thao tác này.");
        return;
    }

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String imageUrl = request.getParameter("imageUrl");
        String categoryIdStr = request.getParameter("categoryId");

        // Kiểm tra và chuyển kiểu dữ liệu
        try {
            double price = Double.parseDouble(priceStr);
            int categoryId = Integer.parseInt(categoryIdStr);

            // Tạo đối tượng Food
            Food food = new Food();
            food.setName(name);
            food.setDescription(description);
            food.setPrice(price);
            food.setImageUrl(imageUrl);
            food.setDiscountPercent(0);   // giá mặc định
            food.setTopSeller(false);     // giá mặc định
            Category category = new Category();
            category.setCategoryId(categoryId);
            food.setCategory(category);
            
            // Thêm vào DB
            FoodDAO foodDAO = new FoodDAO();
            foodDAO.add(food);

            // Chuyển hướng về danh sách món ăn
            response.sendRedirect("food-list");
        } catch (Exception e) {
            // Trường hợp lỗi (ví dụ dữ liệu không hợp lệ)
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi thêm món ăn: " + e.getMessage());

            // Load lại danh mục để hiển thị lại form
            CategoryDAO categoryDAO = new CategoryDAO();
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);

            request.getRequestDispatcher("add-food.jsp").forward(request, response);
        }
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
