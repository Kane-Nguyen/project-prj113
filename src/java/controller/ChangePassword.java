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
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import javafx.scene.control.Alert;
import model.Users;

/**
 *
 * @author khaye
 */
@WebServlet(name = "changepassword", urlPatterns = {"/changepassword"})
public class ChangePassword extends HttpServlet {

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
            out.println("<title>Servlet ChangePassword</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangePassword at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("/changePassword.jsp").forward(request, response);
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
        boolean isSuccessed = false;
        try {
            String email = request.getParameter("email");
            String secretString = request.getParameter("secretString");
            String newPassword = request.getParameter("newPassword");
            String confirmNewPassword = request.getParameter("confirmNewPassword");

            if (email != null && !email.isEmpty() && secretString != null && !secretString.isEmpty()) {
                UsersDAO usersDAO = new UsersDAO();
                List<Users> list = usersDAO.getAll();

                for (Users user : list) {
                    if (user.getEmail().equals(email)) {
                        if (user.getSecretString().equals(secretString)) {
                            if (confirmNewPassword.equals(newPassword)) {
                                usersDAO.updatePassword( email,newPassword);
                                isSuccessed = true;
                                System.out.println("passed");
                                request.getRequestDispatcher("login.jsp").forward(request, response);
                                return;
                            } else {
                                request.setAttribute("error", "Confirm Password doesn't match with New Password");
                            }
                            break; // exit loop as the user is found
                        } else {
                            request.setAttribute("error", "Wrong secret");
                            break; // exit loop as the user is found
                        }
                    }
                }
            } else {
                request.setAttribute("error", "Email and Secret String cannot be empty");
            }
        } catch (Exception e) {
            // Log the exception and set a generic error message
            request.setAttribute("error", "An error occurred. Please try again.");
        }

        if (!isSuccessed) {
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
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
