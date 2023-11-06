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
<%@page import="java.util.Locale"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.net.URLEncoder" %>
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
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Paid</title>
        <!-- Link Bootstrap CSS -->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <!-- Link Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <!-- Custom styles for this template -->
        <style>
            .table-responsive {
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
        <!-- Bootstrap container to center content on the page -->
        <div class="container">

            <h1 class="my-4">Paid</h1>
            <a href="index.jsp" class="btn btn-outline-dark">Back</a>

            <!-- Bootstrap responsive table -->
            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead class="thead-dark">
                        <tr>
                            <th scope="col">OrderID</th>
                            <th scope="col">UserID</th>
                            <th scope="col">Address</th>
                            <th scope="col">Phone Number</th>
                            <th scope="col">Name</th>
                            <th scope="col">Payment Method</th>
                            <th scope="col">Total Price</th>
                            <th scope="col">Order Status</th>
                            <th scope="col">Product</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Order order : lo) { 
                         NumberFormat numberFormat = NumberFormat.getNumberInstance();
                                numberFormat.setMinimumFractionDigits(3);
                                numberFormat.setMaximumFractionDigits(3);%>
                        <tr>
                            <td><%= order.getOrderID() %></td>
                            <td><%= order.getUserID() %></td>
                            <td><%= order.getDeliveryAddress() %></td>
                            <td><%= order.getPhoneNumber() %></td>
                            <td><%= order.getRecipientName() %></td>
                            <td><%= order.getPaymentMethod() %></td>
                            <%
     double totalPrice = order.getTotalPrice();
     int totalPriceAsInt = (int) totalPrice;
     NumberFormat formatter = NumberFormat.getIntegerInstance();
     String formattedPrice = formatter.format(totalPriceAsInt);
                            %>
                            <td><%= formattedPrice %></td>






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
                                <p><%=p.getProductNameById(bp.getProductID()) %>:<%=bp.getQuantity()%>,</p>
                                <% }%>

                            </td>

                        </tr>
                        <% } %>
                    </tbody>

                </table>
                <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/popper.js@1.7.12/dist/umd/popper.min.js"></script>
                <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
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
