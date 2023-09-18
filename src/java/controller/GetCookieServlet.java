package controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "GetCookieServlet", urlPatterns = {"/get-cookie"})
public class GetCookieServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy mảng các cookie từ request
        Cookie[] cookies = request.getCookies();

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                String name = cookie.getName();
                String value = cookie.getValue();

                // Đặt lại thời gian sống của cookie là 2 giờ
                cookie.setMaxAge(30);

                response.getWriter().println("Cookie Name: " + name + ", Value: " + value);
            }
        } else {
            response.getWriter().println("No cookies found.");
        }
    }
}
