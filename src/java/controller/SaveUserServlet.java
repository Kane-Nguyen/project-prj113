/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.UsersDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import model.Users;

/**
 *
 * @author tranq
 */
public class SaveUserServlet extends HttpServlet {

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
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SaveUserServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SaveUserServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
 UsersDAO u;
        u = new UsersDAO();
        List<Users> list = u.getAll();
        String name = request.getParameter("name");
        String date = request.getParameter("date");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String method = request.getParameter("method");
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date utilBirthDate = null;
        if (email != null && !email.isEmpty()) {
            for (Users user : list) {
                if (user.getEmail().equals(email)) {
                    // Hiển thị thông báo lỗi và ngăn chặn chuyển hướng
                    request.setAttribute("error", "Email already registered. Please try another email.");
                    request.getRequestDispatcher("addUsers.jsp").forward(request, response);
                    return;
                }
            }
        }
        try {
            utilBirthDate = dateFormat.parse(date);
        } catch (ParseException e) {
            // Xử lý lỗi ở đây nếu không thể chuyển đổi ngày sinh từ chuỗi.

        }
        java.sql.Date birthDate = new java.sql.Date(utilBirthDate.getTime());
       
        switch (method) {
            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                if (!u.delete(id)) {
                    System.out.println("Loi delete Users");
                } else {
                    response.sendRedirect("UserManagement.jsp");
                }
                break;
            }
            case "edit": {
                int id = Integer.parseInt(request.getParameter("id"));
                if (!u.updateUsers(name, birthDate, phone, email, address, id)) {
                    System.out.println("Loi update Users");
                } else {
                    response.sendRedirect("UserManagement.jsp");
                }
                break;
            }
            default:
                if(!u.insertUser(name, birthDate, phone, email, password, address, role)){
                       System.out.println("Loi add Users"); 
                        response.sendRedirect("addUsers.jsp");
                        }else{
                                response.sendRedirect("UserManagement.jsp");
                                }
                break;
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
