package filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/index.html"})  // Apply this filter to all URLs
public class SessionTimeoutFilter implements Filter {

   @Override
public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
        throws IOException, ServletException {

    HttpServletRequest httpRequest = (HttpServletRequest) request;
    HttpServletResponse httpResponse = (HttpServletResponse) response;
    HttpSession session = httpRequest.getSession(false);
    String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

    if (path.startsWith("/index") || path.equals("/index.html")) {
        if (session != null) {
            Long lastInteractionTime = (Long) session.getAttribute("lastInteractionTime");
            if (lastInteractionTime != null) {
                long now = System.currentTimeMillis();
                if (now - lastInteractionTime > 10000) { // 30s timeout
                    session.invalidate(); // Invalidate session
                    httpResponse.sendRedirect("login.jsp");
                    return;
                } else {
                    session.setAttribute("lastInteractionTime", System.currentTimeMillis());
                }
            }
        } else {
            httpResponse.sendRedirect("login.jsp");
            return;
        }
    }

    chain.doFilter(request, response);
}
}