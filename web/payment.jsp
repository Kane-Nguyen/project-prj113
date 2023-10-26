<%-- 
    Document   : payment
    Created on : Oct 25, 2023, 8:15:34 PM
    Author     : tranq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dal.OrderDAO"%>
<%@page import="model.Order" %>
<%@page import="java.util.List"%>
<%@ page import="java.net.URLEncoder" %>
<%
OrderDAO o = new OrderDAO();
List<Order> lo = o.getAll();
%>
<%
 if (session == null || session.getAttribute("isLoggedIn") == null || 
 !(Boolean)session.getAttribute("isLoggedIn")||session.getAttribute("role") == null || !session.getAttribute("role").equals("Admin")) {
        
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
        <title>Payment</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    </head>
    <body>
        <h1>Payment</h1>
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
                        <select class="order-status" data-order-id="<%= order.getOrderID() %>">
                            <option value="đang chờ duyệt" <%= order.getOrderStatus().equals("đang chờ duyệt") ? "selected" : "" %>>đang chờ duyệt</option>
                            <option value="đang chuẩn bị hàng" <%= order.getOrderStatus().equals("đang chuẩn bị hàng") ? "selected" : "" %>>đang chuẩn bị hàng</option>
                            <option value="đang giao" <%= order.getOrderStatus().equals("đang giao") ? "selected" : "" %>>đang giao</option>
                            <option value="đã giao" <%= order.getOrderStatus().equals("đã giao") ? "selected" : "" %>>đã giao</option>
                        </select>
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
