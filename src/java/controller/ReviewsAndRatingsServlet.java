package controller;

import dal.ReviewsAndRatingsDAO;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;

public class ReviewsAndRatingsServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet admin</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet admin at " + request.getContextPath() + "</h1>");
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
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy dữ liệu từ biểu mẫu
        String userID_raw = request.getParameter("userID");
        String productID = request.getParameter("productID");
        String comment = request.getParameter("comment");
        String rating_raw = request.getParameter("rating");

        if (userID_raw == null || userID_raw.trim().isEmpty()) {
            // Hiển thị thông báo và không xử lý tiếp
            request.setAttribute("message", "..");
            request.getRequestDispatcher("detail.jsp").forward(request, response);
            return;
        }

        int rating;
        int userID;
        try {
            rating = Integer.parseInt(rating_raw);
            userID = Integer.parseInt(userID_raw);
        } catch (NumberFormatException e) {
            request.getRequestDispatcher("detail.jsp?productId=" + productID).forward(request, response);
            return;
        }

        // Thêm bình luận vào cơ sở dữ liệu
        ReviewsAndRatingsDAO reviewDao = new ReviewsAndRatingsDAO();
        boolean success = reviewDao.addReview(userID, productID, comment, rating);

        if (success) {
            response.sendRedirect("detail.jsp?productId=" + productID);
        } else {
            response.getWriter().println("Failed to add comment.");
        }
    }
}
