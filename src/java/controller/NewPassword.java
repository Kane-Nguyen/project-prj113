package com.uniquedeveloper.registration;

import dal.UsersDAO;
import model.Users;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.List;

@WebServlet("/newPassword")
public class NewPassword extends HttpServlet {

    private static final long serialVersionUID = 1L;
    UsersDAO ud = new UsersDAO();
    List<Users> list = ud.getAll();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String newPassword = request.getParameter("password");
        String confPassword = request.getParameter("confPassword");
        RequestDispatcher dispatcher;

        if (newPassword != null && confPassword != null) {
            // Check if newPassword and confPassword are the same               
            if (newPassword.equals(confPassword)) {
                boolean isUpdated = ud.updatePassword((String) session.getAttribute("email"), newPassword);

                if (isUpdated) {
                    request.setAttribute("status", "resetSuccess");
                    dispatcher = request.getRequestDispatcher("login.html");
                } else {
                    request.setAttribute("status", "resetFailed");
                    dispatcher = request.getRequestDispatcher("logIn.html");
                }
                dispatcher.forward(request, response);
            } else {
                request.setAttribute("status", "passwordMismatch");
                dispatcher = request.getRequestDispatcher("newPassword.jsp");
                dispatcher.forward(request, response);
            }

        }
    }
}
