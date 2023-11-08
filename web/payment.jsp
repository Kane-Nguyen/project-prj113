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
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Payment</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <link rel="stylesheet" href="./css/payment.css">
    </head>
    <body>

        <div class="wrap-admin-page">
            <div class="toolbar">
                <button class="close-toolbar mobile-menu-button" onclick="toggleToolbar()"><i class="bi bi-x"></i></button>
                <div class="logo">
                    <img class="logo-img" src="./asset/images/home-images/logo.png" alt="logo"/>
                </div>
                <ul class="list-toolbar">
                    <a href="admin.jsp" class="item-admin"><i class="bi bi-book-half"></i>Book Management</a>
                    <a href="payment.jsp" class="item-admin active"><i class="bi bi-wallet2"></i>Payment</a>
                    <a href="analysis.jsp" class="item-admin"><i class="bi bi-bar-chart-fill"></i>Dashboard</a>
                    <a href="UserManagement.jsp" class="item-admin"><i class="bi bi-people-fill h5"></i><li>User Management</li></a>
                    <a href="Logout" class="item-admin"><i class="bi bi-box-arrow-left"></i>Log Out</a>
                </ul>
            </div>
            <div class="main-content">
                <div class="container-wrap">
                    <button class="hamburger-button" onclick="toggleToolbar()"><i class="bi bi-list"></i></button>
                    <div class="title-and-button">
                        <h1>Payment</h1>
                        <div class="table-responsive">
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
                                    <button type="submit" class="btn btn-primary mt-2 ml-1"">Save</button>
                                    <tbody>
                                        <% for (Order order : lo) { %>
                                        <tr>
                                            <td style="display: none"><input type="hidden" style="border:1px;" name="orderID" value="<%= order.getOrderID() %>"></td>
                                            <td><input type="number" style="border:1px;" name="userID" value="<%= order.getUserID() %>"></td>
                                            <td><input type="text" style="border:1px;" name="deliveryAddress" value="<%= order.getDeliveryAddress() %>"></td>
                                            <td><input  type="text" style="border:1px;" name="phoneNumber" value="<%= order.getPhoneNumber() %>"></td>
                                            <td><input type="text" style="border:1px;" name="recipientName" value="<%= order.getRecipientName() %>"></td>
                                            <td><input type="text" style="border:1px;" name="paymentMethod" value="<%= order.getPaymentMethod() %>"></td>
                                            <td><input type="number" style="border:1px;" name="totalPrices" value="<%= String.format("%.3f", order.getTotalPrice()) %>"></td>
                                                <%if(order.getOrderStatus().equals("Cancel")){
                                                %>
                                            <td><P>Canceled</P>
                                            <form action="SaveOrderServlet" method="post">
                                        <input type="hidden" style="border:1px;" name="iddelete" value="<%= order.getOrderID() %>">
                                        <input type="hidden" style="border:1px;" name="method" value="delete">
                                        <button type="submit" class="btn btn-danger">Delete</button>
                                    </form>  </td>
                                       
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
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
                        function toggleToolbar() {
                            var toolbar = document.querySelector('.toolbar');
                            // Nếu toolbar đang hiển thị, ẩn nó đi
                            if (toolbar.style.display === 'block') {
                                toolbar.style.display = 'none';
                            } else {
                                // Nếu không, hiển thị nó
                                toolbar.style.display = 'block';
                                toolbar.classList.add('toggle'); // Thêm class để hiệu ứng chuyển đổi có thể hoạt động
                            }
                        }
        </script>
    </body>
</html>