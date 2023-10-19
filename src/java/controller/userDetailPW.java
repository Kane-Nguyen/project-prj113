// CheckPasswordServlet.java
package controller;

import dal.UsersDAO;
import model.Users;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet(name = "userDetailPW", urlPatterns = {"/userDetailPW"})
public class userDetailPW extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String enteredPassword = request.getParameter("password");
        String secretString = "";  // Initialize this with your actual secret string
        if (enteredPassword == null || enteredPassword.isEmpty()) {
            response.getWriter().write("error"); // Mật khẩu trống hoặc null, trả về lỗi
            return;
        }
        UsersDAO userDAO = new UsersDAO();
        List<Users> list = userDAO.getAll();

        // Compare the entered password with the one in the database
        boolean isPasswordCorrect = false;
        for (Users user : list) {
            if (user.getPassWord().equals(enteredPassword)) {
                isPasswordCorrect = true;
                break;
            }
        }

        if (isPasswordCorrect) {
            response.getWriter().write(secretString);
        } else {
            response.getWriter().write("error");
        }
    }
}
