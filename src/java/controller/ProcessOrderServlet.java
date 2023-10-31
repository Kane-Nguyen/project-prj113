package controller;

import dal.BooksInOrderDAO;
import dal.OrderDAO;
import dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

public class ProcessOrderServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ProcessOrderServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProcessOrderServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy các giá trị từ form
        String deliveryAddress = request.getParameter("deliveryAddress");
        String phoneNumber = request.getParameter("phoneNumber");
        String recipientName = request.getParameter("recipientName");
        String paymentMethod = request.getParameter("paymentMethod");
        String totalPriceStr = request.getParameter("totalPrice");
        String methodbuy = request.getParameter("methodbuy");
        System.out.println(methodbuy);
        boolean isStocking = true;
        double totalPrice = 0.0;
        ProductDAO p = new ProductDAO();
        
        String[] quantities = request.getParameterValues("quantity");
        String productIdsRaw = request.getParameter("productIds");
        String[] productIds = productIdsRaw.split(",");
        for (int i = 0; i < productIds.length; i++) {
            System.out.println(quantities[i]);
            System.out.println(productIds[i]);
            int quantity = Integer.parseInt(quantities[i]);
            int sq = p.getStockQuantity(productIds[i]);
            if (sq < quantity) {
                isStocking = false;
               response.sendRedirect("Buy.jsp?errorMessage=Out+of+Stock&productId=" + productIds[i]);
                return;

            }

        }
        if (totalPriceStr != null && !totalPriceStr.isEmpty()) {
            try {
                totalPrice = Double.parseDouble(totalPriceStr);
            } catch (NumberFormatException e) {
                // Handle the exception, e.g., log an error message
                System.out.println("Invalid format for totalPrice");
            }
        } else {
            System.out.println("totalPrice parameter is missing or empty");
        }

        int userID = Integer.parseInt(request.getParameter("userID"));

        // Lấy mảng các sản phẩm và số lượng
        if (quantities == null || quantities.length == 0 || quantities.equals("null")) {
            System.out.println("Lỗi: Không có dữ liệu quantity");
        } else if (isStocking == false) {
            System.out.println("Out of Stock");
        } else {
            // In các giá trị ra console hoặc log
            System.out.println("Delivery Address: " + deliveryAddress);
            System.out.println("Phone Number: " + phoneNumber);
            System.out.println("Recipient Name: " + recipientName);
            System.out.println("Payment Method: " + paymentMethod);
            System.out.println("Total Price: " + totalPrice);
            System.out.println("userID: " + userID);
            OrderDAO o = new OrderDAO();
            o.addOrder(userID, deliveryAddress, phoneNumber, recipientName, paymentMethod, totalPrice, "Pending");
            int lastestID = o.getLatestOrderID();
            BooksInOrderDAO b = new BooksInOrderDAO();
            // In thông tin sản phẩm và số lượng tương ứng
            System.out.println("Product IDs and Corresponding Quantities: ");
            for (int i = 0; i < productIds.length; i++) {
                String productId = productIds[i];
                String quantity = quantities[i];

                System.out.println("Product ID: " + productIds[i] + ", Quantity: " + quantities[i]);

                try {
                    int quantityInt = Integer.parseInt(quantity);
                    // Thực hiện xử lý dữ liệu ở đây (ví dụ: thêm vào cơ sở dữ liệu)
                    b.insertBooksInOrder(lastestID, productId, quantityInt);
                    int S = p.getStockQuantity(productId) - quantityInt;
                    p.updateStockQuantity(productId, S);

                } catch (NumberFormatException e) {
                    System.out.println("Invalid quantity format for product ID: " + productId);
                }
            }
            if (methodbuy.equals("cart")) {
                Cookie cartCookie = new Cookie("cart", "");
                cartCookie.setMaxAge(60 * 60 * 24);  
                response.addCookie(cartCookie);

                Cookie quantityCookie = new Cookie("quantity", "");
                quantityCookie.setMaxAge(60 * 60 * 24);  
                response.addCookie(quantityCookie);
            }
            response.sendRedirect("paid.jsp");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
