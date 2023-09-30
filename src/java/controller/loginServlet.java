/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.UsersDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Users;

@WebServlet(name = "login", urlPatterns = {"/login"})
public class loginServlet extends HttpServlet {

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
            out.println("<title>Servlet loginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet loginServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    /**
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        Cookie Ce = new Cookie("Ce", email);
        Cookie Cp = new Cookie("Cp", password);
        Cookie Cr = new Cookie("Cr", rememberMe);

        // Kiểm tra xem email và mật khẩu có trống không
        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Cả email và mật khẩu phải được nhập.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        UsersDAO usersDAO = new UsersDAO();
        List<Users> users = usersDAO.getAll();
        Users matchedUser = null;

        for (Users user : users) {
            if (user.getEmail().equals(email) && user.getPassWord().equals(password)) {
                matchedUser = user;
                break;
            }
        }

        if (matchedUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", matchedUser);  // Lưu thông tin người dùng vào session

            // Thiết lập thời gian tồn tại của phiên là 2 tiếng (7200 giây)
            session.setMaxInactiveInterval(10);

            if(rememberMe != null) {
                Ce.setMaxAge(60 * 60 * 365);
                Cp.setMaxAge(60 * 60 * 365);
                Cr.setMaxAge(60 * 60 * 365);
            } else {
                Ce.setMaxAge(0);
                Cp.setMaxAge(0);
                Cr.setMaxAge(0);
            }

            response.addCookie(Ce);
            response.addCookie(Cp);
            response.addCookie(Cr);
            response.sendRedirect("index.jsp");
        } else {
            request.setAttribute("error", "Email hoặc mật khẩu không hợp lệ");
            request.getRequestDispatcher("login.jsp").forward(request, response);
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