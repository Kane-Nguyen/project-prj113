<%-- 
    Document   : payment
    Created on : Oct 25, 2023, 8:15:34 PM
    Author     : tranq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dal.OrderDAO"%>
<%@page import="model.Order" %>
<%@page import="dal.ProductDAO"%>
<%@page import="model.Product" %>
<%@page import="dal.BooksInOrderDAO"%>
<%@page import="model.BooksInOrder" %>
<%@page import="java.util.List"%>
<%@ page import="java.net.URLEncoder" %>
<%
OrderDAO o = new OrderDAO();
int id=-1;
Object sessionId = session.getAttribute("userID");
if (sessionId != null) {
    try {
        id = Integer.parseInt(sessionId.toString());
        List<Order> lo = o.getById(id);
        // The rest of your code
    } catch (NumberFormatException e) {
        // Handle exception: not a number
        System.out.println("ID is not a number");
    }
} else {
    // Handle exception: session attribute 'id' is null
    System.out.println("ID is null");
}
List<Order> lo = o.getById(id);
%>
<%
 if (session == null || session.getAttribute("isLoggedIn") == null || 
 !(Boolean)session.getAttribute("isLoggedIn")) {
        
        String originalURL = request.getRequestURI(); // Lấy URL hiện tại
        String queryString = request.getQueryString(); // Lấy query string từ URL (nếu có)
        
        if (queryString != null) {
            originalURL += "?" + queryString;
        }
        
        response.sendRedirect("login.jsp?redirect=" + URLEncoder.encode(originalURL, "UTF-8")); // Redirect to login page with the original URL
        return;
}

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Paid</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    </head>
    <body>
        <h1>Paid</h1>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>OrderID</th>
                    <th>UserID</th>
                    <th>Address</th>
                    <th>Phone Number</th>
                    <th>Name</th>
                    <th>Payment Method</th>
                    <th>total price</th>
                    <th>Order Status</th>
                    <th>Product</th>
                </tr>
            </thead>
            <tbody>
                <% for (Order order : lo) { %>
                <tr>
                    <td><%= order.getOrderID() %></td>
                    <td><%= order.getUserID() %></td>
                    <td><%= order.getDeliveryAddress() %></td>
                    <td><%= order.getPhoneNumber() %></td>
                    <td><%= order.getRecipientName() %></td>
                    <td><%= order.getPaymentMethod() %></td>
                    <td><%= String.format("%.2f", order.getTotalPrice()) %></td>
                    <td>
                       <%= order.getOrderStatus()%>
                    </td>
                    <td>
                    <%
                    BooksInOrderDAO b = new BooksInOrderDAO();
                    ProductDAO p = new ProductDAO();
                   List<BooksInOrder> lp = b.getBookById(order.getOrderID());
                    for(BooksInOrder bp: lp){
                    
                     %>
                     <p><%=p.getProductNameById(bp.getProductID()) %>,</p>
                       <% }%>
                   
                   </td>

                </tr>
                <% } %>
            </tbody>

        </table>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            $(document).ready(function () {
                $(".order-status").change(function () {
                    var orderId = $(this).data("order-id");
                    var newStatus = $(this).val();

                    $.ajax({
                        url: "updateOrderStatus", // Server-side script to handle updating
                        type: "POST",
                        data: {
                            "orderId": orderId,
                            "newStatus": newStatus
                        },
                        success: function (response) {
                            console.log("Update successful:", response);
                        },
                        error: function (err) {
                            console.log("Error:", err);
                        }
                    });
                });
            });
        </script>

    </body>
</html>
