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
public class EditFoodServlet extends HttpServlet {

    private final FoodDAO foodDAO = new FoodDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet EditFoodServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditFoodServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
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
            response.sendRedirect("login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("Access denied. Bạn không có quyền thực hiện thao tác này. Trở về trang chủ ");
            return;
        }
        try {
            int id = Integer.parseInt(request.getParameter("foodId"));
            Food f = foodDAO.getById(id);
            List<Category> categories = categoryDAO.getAllCategories();

            request.setAttribute("food", f);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("edit-food.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
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
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("Access denied. Bạn không có quyền thực hiện thao tác này.");
            return;
        }

        try {
            request.setCharacterEncoding("UTF-8");
            int id = Integer.parseInt(request.getParameter("foodId"));
            String name = request.getParameter("name");
            String desc = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            String img = request.getParameter("imageUrl");
            int catId = Integer.parseInt(request.getParameter("categoryId"));
            double discountPercent = Double.parseDouble(request.getParameter("discountPercent"));

            Food f = new Food();
            f.setFoodId(id);
            f.setName(name);
            f.setDescription(desc);
            f.setPrice(price);
            f.setImageUrl(img);
            Category c = new Category();
            c.setCategoryId(catId);
            f.setCategory(c);
            f.setDiscountPercent(discountPercent);
            // gọi update (void)
            foodDAO.update(f);

            // redirect về danh sách sau khi update
            response.sendRedirect("food-list");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ, vui lòng kiểm tra lại.");
            request.getRequestDispatcher("edit-food.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("edit-food.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
