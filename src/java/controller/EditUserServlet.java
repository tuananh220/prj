/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author Admin
 */
public class EditUserServlet extends HttpServlet {
       private final UserDAO dao = new UserDAO();

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
            out.println("<title>Servlet EditUserServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditUserServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param req
     * @param resp
     * 
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
    throws ServletException, IOException {
        
        int id = Integer.parseInt(req.getParameter("userId"));
        try {
            User user = dao.getUserById(id);
            req.setAttribute("user", user);
            req.getRequestDispatcher("user-form.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendError(404);
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param req
     * @param resp
     * 
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
    throws ServletException, IOException {
        HttpSession session = req.getSession(false);
    if (session == null || session.getAttribute("user") == null) {
        resp.sendRedirect("login.jsp");
        return;
    }
    User user = (User) session.getAttribute("user");
    if (!"admin".equals(user.getRole())) {
        resp.getWriter().println("Access denied. Bạn không có quyền thực hiện thao tác này.");
        return;
    }

        req.setCharacterEncoding("UTF-8");
        User u = new User();
        u.setUserId(Integer.parseInt(req.getParameter("userId")));
        u.setFullName(req.getParameter("fullName"));
        u.setPhone(req.getParameter("phone"));
        u.setAddress(req.getParameter("address"));
        u.setRole(req.getParameter("role"));
        try {
            dao.updateUser(u);
            resp.sendRedirect(req.getContextPath() + "/user-list");
        } catch (Exception e) {
            req.setAttribute("error", "Cập nhật thất bại");
            req.setAttribute("user", u);
            req.getRequestDispatcher("user-form.jsp").forward(req, resp);
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
