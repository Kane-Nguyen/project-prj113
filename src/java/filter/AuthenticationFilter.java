import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;


public class AuthenticationFilter implements Filter {

    private final List<String> protectedPages = Arrays.asList("/admin.jsp");

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute("isLoggedIn") != null && (Boolean) session.getAttribute("isLoggedIn"));

        // Kiểm tra nếu người dùng đã đăng nhập hoặc đang truy cập các trang bảo vệ, cho phép tiếp tục xử lý
        if (isLoggedIn || isProtectedPage(httpRequest)) {
            chain.doFilter(request, response);
        } else {
            // Nếu chưa đăng nhập và không phải trang bảo vệ, chuyển hướng về trang login
            httpResponse.sendRedirect("index.jsp");
        }
    }

    private boolean isProtectedPage(HttpServletRequest request) {
        String requestURI = request.getRequestURI();
        return protectedPages.contains(requestURI);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter (nếu cần)
    }

    @Override
    public void destroy() {
        // Hủy filter (nếu cần)
    }
}
