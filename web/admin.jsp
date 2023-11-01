<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="model.Product"%>
<%@page import="dal.ProductDAO"%>
<%@page import="dal.CategoryDAO"%>
<%@ page import="java.net.URLEncoder" %>

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
        <title>Product List</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="./css/admin.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <style>



        </style>
    </head>
    <body>
        <div class="wrap-admin-page">
            <div class="toolbar">
                <div class="logo">
                    <img class="logo-img" src="./asset/images/home-images/logo.png" alt="logo"/>
                </div>
                <ul class="list-toolbar">
                    <a href="/" class="item-admin active"><i class="bi bi-book-half h5"></i><li>Book Management</li></a>
                    <a href="payment.jsp" class="item-admin"><i class="bi bi-wallet2 h5"></i><li>Payment</li></a>
                    <a href="" class="item-admin"><i class="bi bi-bar-chart-fill h5"></i><li>Dashboard</li></a>
                    <a href="Logout" class="item-admin"><i class="bi bi-box-arrow-left"></i></i><li>Log Out</li></a>
                </ul>
            </div>
            <div class="container-wrap">
                <h3 class="tile-book-management">Book Management</h3>
                <div class="">
                    <form action="CRUD" method="get">
                        <input type="hidden" name="action" value="add">
                        <button class="btn-add-product" type="submit"><i class="bi bi-folder-plus"></i></button>
                    </form>  
                    <table>
                        <tr>
                            <th>Product Name</th>
                            <th>Product Image</th>
                            <th>Product Category</th>
                            <th>Description</th>
                            <th>Price</th>
                            <th>Discount Percentage</th>
                            <th>Manufacturer</th>
                            <th>Stock Quantity</th>
                            <th>Date Added</th>
                            <th>Actions</th>
                        </tr>
                        <% 
                            ProductDAO productDAO = new ProductDAO();
                            CategoryDAO ctDAO = new CategoryDAO();
                            List<Product> products = productDAO.getAll();
                            NumberFormat numberFormat = NumberFormat.getNumberInstance();
                            numberFormat.setMinimumFractionDigits(3);
                            numberFormat.setMaximumFractionDigits(3);
                            if (products != null && !products.isEmpty()) {
                                for (Product product : products) {
                                    if (product != null) {
                        %>
                        <tr id="row-<%= product.getProductId() != null ? product.getProductId() : "N/A" %>">
                            <td><%= product.getProductName() != null ? product.getProductName() : "N/A" %></td>
                            <td>
                                <img src="<%= product.getImageURL() != null ? product.getImageURL() : "default.jpg" %>" alt="Product Image">
                            </td>
                            <td><%= product.getCategoryId() != -1 ? ctDAO.getCategoryByProductId(product.getCategoryId()) : "N/A" %></td>
                            <td class="admin-product-description"><%= product.getDescription() != null ? product.getDescription() : "N/A" %></td>
                            <td><%= numberFormat.format(product.getPrice()) %>đ</td>
                            <td><%= product.getDiscountPercentage() %> %</td>
                            <td><%= product.getAuthor() != null ? product.getAuthor() : "N/A" %></td>
                            <td><%= numberFormat.format(product.getStockQuantity()) %>đ</td>
                            <td>
                                <%= product.getDateAdded() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(product.getDateAdded()) : "N/A" %>
                            </td>
                            <td class="action-edit-delete">

                                <form action="CRUD" method="get">
                                    <input type="hidden" name="action" value="edit">
                                    <input type="hidden" name="id" value="<%= product.getProductId() %>">
                                    <button class="btn btn-warning" type="submit">Edit</button>
                                </form>

                                <button class="btn btn-danger btn-delete" onclick="deleteProduct('<%= product.getProductId() != null ? product.getProductId() : "N/A" %>')">Delete</button>
                            </td>
                        </tr>
                        <% 
                                    }
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="11">No products found.</td>
                        </tr>
                        <% 
                            }
                        %>
                    </table>
                </div>
                <script type="text/javascript">
                    function deleteProduct(id) {
                        if (confirm('Are you sure?')) {
                            var xhr = new XMLHttpRequest();
                            xhr.open("GET", "CRUD?action=delete&id=" + id, true);
                            xhr.onreadystatechange = function () {
                                if (xhr.readyState == 4 && xhr.status == 200) {
                                    var row = document.getElementById("row-" + id);
                                    row.parentNode.removeChild(row);
                                }
                            }
                            xhr.send();
                        }
                    }
                </script>
                <script type="text/javascript">
                    document.addEventListener('DOMContentLoaded', function () {
                        var searchInput = document.getElementById('searchInput');

                        searchInput.addEventListener('input', function () {
                            var query = searchInput.value;
                            if (query.length === 0) {
                                document.getElementById('searchResults').innerHTML = '';
                                return;
                            }
                            var xhr = new XMLHttpRequest();
                            xhr.open('GET', 'CRUD?action=search&query=' + query, true);

                            xhr.onreadystatechange = function () {
                                if (xhr.readyState === 4 && xhr.status === 200) {
                                    document.getElementById('searchResults').innerHTML = xhr.responseText;
                                }
                            }

                            xhr.send();
                        });
                    });
                </script>


                </body>
                </html>