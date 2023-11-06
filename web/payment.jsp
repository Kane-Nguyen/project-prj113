<%-- 
    Document   : payment
    Created on : Oct 25, 2023, 8:15:34 PM
    Author     : tranq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dal.OrderDAO"%>
<%@page import="model.Order" %>
<%@page import="java.util.List"%>
<%@page import="dal.ProductDAO"%>
<%@page import="model.Product" %>
<%@page import="dal.BooksInOrderDAO"%>
<%@page import="model.BooksInOrder" %>
<%@ page import="java.net.URLEncoder" %>
<%
OrderDAO o = new OrderDAO();
List<Order> lo = o.getAll();
%>
<%
String error = request.getParameter("error");
if (error != null && error.equals("missing_id")) {
%>
<div class="error-message">
    ID is missing. Please provide a valid ID for editing.
</div>
<%
}
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
                    <th>UserID</th>
                    <th>Address</th>
                    <th>Phone Number</th>
                    <th>Name</th>
                    <th>Payment Method</th>
                    <th>total price</th>
                    <th>Order Status</th>
                    <th>Products</th>
                </tr>
            </thead>
            <form action="SaveOrdersServlet" method="POST">
                <button type="submit">Save</button>
                <tbody>
                    <% for (Order order : lo) { %>
                    <tr>
                        <td style="display: none"><input type="hidden" style="border:0px;" name="orderID" value="<%= order.getOrderID() %>"></td>
                        <td><input type="number" style="border:0px;" name="userID" value="<%= order.getUserID() %>"></td>
                        <td><input type="text" style="border:0px;" name="deliveryAddress" value="<%= order.getDeliveryAddress() %>"></td>
                        <td><input  type="text" style="border:0px;" name="phoneNumber" value="<%= order.getPhoneNumber() %>"></td>
                        <td><input type="text" style="border:0px;" name="recipientName" value="<%= order.getRecipientName() %>"></td>
                        <td><input type="text" style="border:0px;" name="paymentMethod" value="<%= order.getPaymentMethod() %>"></td>
                        <td><input type="number" style="border:0px;" name="totalPrices" value="<%= String.format("%.3f", order.getTotalPrice()) %>"></td>
                            <%if(order.getOrderStatus().equals("Cancel")){
                            %>
                        <td><P class="text-danger">Canceled</P>
                            <form action="SaveOrdersServlet" method="POST">
                         <input type="hidden" name="iddelete" value="<%= order.getOrderID() %>">
                                <input type="hidden" name="method" value="delete">
                                <button type="submit" class="btn-danger">Delete</button>
                            </form>
                        </td>
                                <%
                            } else{ %>
                        <td>
                            <select name="orderStatus" class="order-status" data-order-id="<%= order.getOrderID() %>">
                                <option value="Pending" <%= order.getOrderStatus().equals("Pending") ? "selected" : "" %>>Pending</option>
                                <option value="Preparing" <%= order.getOrderStatus().equals("Preparing") ? "selected" : "" %>>Preparing</option>
                                <option value="Shipping" <%= order.getOrderStatus().equals("Shipping") ? "selected" : "" %>>Shipping</option>
                                <option value="Delivered" <%= order.getOrderStatus().equals("Delivered") ? "selected" : "" %>>Delivered</option>
                            </select>
                        </td> <%}%>
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
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <input type="hidden" name="method" value="payment">
    </form>
</body>
</html>