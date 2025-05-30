/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.FoodReviewDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.FoodReview;

/**
 *
 * @author Admin
 */
public class SubmitReviewServlet extends HttpServlet {
   
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
            out.println("<title>Servlet SubmitReviewServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SubmitReviewServlet at " + request.getContextPath () + "</h1>");
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
          String foodIdParam = request.getParameter("foodId");
        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            if (foodIdParam == null) {
                out.println("<p style='color:red;'>Thiếu ID món ăn.</p>");
                return;
            }

            int foodId = Integer.parseInt(foodIdParam);
            FoodReviewDAO dao = new FoodReviewDAO();
            List<FoodReview> reviews = dao.getReviewsByFoodId(foodId);

            if (reviews == null || reviews.isEmpty()) {
                out.println("<p>Chưa có đánh giá nào.</p>");
                return;
            }

            out.println("<table style='width:100%; border-collapse:collapse; margin-top:10px;' border='1'>");
            out.println("<tr style='background:#eee;'><th>Người đánh giá</th><th>Số sao</th><th>Bình luận</th><th>Ngày</th></tr>");
            for (FoodReview r : reviews) {
                out.println("<tr>");
                out.println("<td>" + r.getUserName() + "</td>");
                out.println("<td>" + r.getRating() + "/5</td>");
                out.println("<td>" + r.getComment() + "</td>");
                out.println("<td>" + r.getReviewDate() + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        } catch (NumberFormatException e) {
            response.getWriter().println("<p style='color:red;'>ID món ăn không hợp lệ.</p>");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<p style='color:red;'>Lỗi khi lấy đánh giá.</p>");
        }
    
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
         int foodId = Integer.parseInt(request.getParameter("foodId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");
        
        // Giả sử bạn có session lưu user_id (đã đăng nhập)
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            // Nếu chưa đăng nhập, redirect sang trang login
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Thực hiện lưu đánh giá vào DB (cần có DAO)
        FoodReviewDAO reviewDAO = new FoodReviewDAO();
        reviewDAO.addReview(foodId, userId, rating, comment);
        
        // Quay lại trang menu hoặc trang chi tiết món ăn (tuỳ bạn)
        response.sendRedirect("menu");
    
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
