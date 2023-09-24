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
                    //response.getWriter().write("Email already registered. Please try another email.");
                    String redirectURL = "SignUp.html"; // Thay thế URL mong muốn
                    String popupScript = "<script>alert('Email already registered. Please try another email.'); window.location.href='" + redirectURL + "';</script>";
                    response.getWriter().write(popupScript);
                    return;
                }
            }
        }

        // Insert the new user
        boolean isSuccess = userDAO.insertUser(email, password, fullname);

        if (isSuccess) {
            // Success
            //response.getWriter().write("User registered successfully.");
            String redirectURL = "logIn.html"; // Thay thế URL mong muốn
            String redirectURL1 = "http://localhost:8080/projectPRJ113/";
            String popupScript = "<script>var result = confirm('User registered successfully. Let log in!'); if (result) { window.location.href='" + redirectURL + "'; } else { window.location.href='" + redirectURL1 + "'; }</script>";
            response.getWriter().write(popupScript);
        } else {
            // Failure
            response.getWriter().write("Registration failed. Please try again.");
        }
    }
}
