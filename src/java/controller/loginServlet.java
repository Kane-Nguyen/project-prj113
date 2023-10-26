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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String birthDay = request.getParameter("birthDay");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String SecretString = request.getParameter("SecretString");
        String redirectURL = request.getParameter("redirect"); // Lấy tham số redirect từ request
        String rememberMe = request.getParameter("rememberMe");
       
        HttpSession session = request.getSession();
        Cookie Ce = new Cookie("Ce", email);
        Cookie Cp = new Cookie("Cp", password);
        Cookie Cr = new Cookie("Cr", rememberMe);
        boolean isLogin = false;

        // Check if the email and password are empty
        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Both email and password must be entered.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        UsersDAO usersDAO = new UsersDAO(); // Create a DAO object to access user data from the database
        List<Users> users = usersDAO.getAll(); // Retrieve the complete list of users

        for (Users user : users) {
            if (user.getEmail().equals(email) && user.getPassWord().equals(password)) {
                session.setAttribute("isLoggedIn", true);
                session.setAttribute("role", user.getUserRole());
                session.setAttribute("userID", user.getUserId());
                session.setAttribute("email", user.getEmail());
                session.setAttribute("fullName", user.getFullName());
                session.setAttribute("birthDay", user.getBirthDate());
                session.setAttribute("phoneNumber", user.getPhoneNumber());
                session.setAttribute("address", user.getAddress());
                session.setAttribute("SecretString", user.getSecretString());                
                if (rememberMe != null) {
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
                isLogin = true;
                break;
            }
        }

       
        if (!isLogin) {
            response.sendRedirect("login.jsp");
        } else {
            // After successful authentication
            if (!"null".equals(redirectURL) && !redirectURL.isEmpty() && redirectURL != null) {
                response.sendRedirect(redirectURL);

            } else {
                // Redirect to default page
                response.sendRedirect("index.jsp");

            }
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