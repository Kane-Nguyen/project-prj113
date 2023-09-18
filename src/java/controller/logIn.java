package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dal.UsersDAO;
import model.Users;

import java.io.IOException;

@WebServlet(name = "logIn", urlPatterns = {"/login"})
public class logIn extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email.isEmpty() || password.isEmpty()) {
            response.sendRedirect("logIn.html?error=empty");
            return;
        }

        UsersDAO usersDAO = new UsersDAO();
        Users user = usersDAO.getUserByEmailAndPassword(email, password);

        if (user != null) {
            // Đăng nhập thành công, đặt hoặc cập nhật cookie
            Cookie userCookie = new Cookie("user", user.getEmail());
            userCookie.setMaxAge(7200); // Đặt thời gian sống là 2 giờ (2 * 60 phút * 60 giây)
            response.addCookie(userCookie);

            response.sendRedirect("success.html");
        } else {
            response.sendRedirect("logIn.html?error=invalid");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra cookie khi người dùng gửi yêu cầu
        Cookie[] cookies = request.getCookies();

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                String name = cookie.getName();
                String value = cookie.getValue();

                if (name.equals("user")) {
                    // Kiểm tra thời gian sống của cookie
                    if (cookie.getMaxAge() <= 0) {
                        // Cookie đã hết hạn, đăng xuất người dùng
                        response.sendRedirect("logIn.html");
                        return;
                    }

                    // Đặt lại thời gian sống của cookie là 2 giờ
                    cookie.setMaxAge(20);
                    response.getWriter().println("Cookie Name: " + name + ", Value: " + value);
                }
            }
        } else {
            response.getWriter().println("No cookies found.");
        }
    }
}
