package controller;

// SignUpServlet.java
import dal.UsersDAO;
import model.Users;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

public class spsl extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullname = request.getParameter("fullname");

        UsersDAO userDAO = new UsersDAO();
        List<Users> list = userDAO.getAll();

        // Check for existing emai
        if (email != null && !email.equals("")) {
            for (Users user : list) {
                if (user.getEmail().equals(email)) {
                    response.getWriter().write("Email already registered. Please try another email.");
                    return;
                }
            }
        }

        // Insert the new user
        boolean isSuccess = userDAO.insertUser(email, password, fullname);

        if (isSuccess) {
            // Success
            response.getWriter().write("User registered successfully.");
        } else {
            // Failure
            response.getWriter().write("Registration failed. Please try again.");
        }
    }
}
