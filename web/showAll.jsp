<%@page import="dal.ProductDAO"%>
<%@page import="java.util.List"%>
<%@page import="model.Product"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>All Products</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" href="./css/index.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
    </head>
    <body>

        <%
            ProductDAO productDAO = new ProductDAO();
            List<Product> productList = productDAO.getAll();
        %>

        <div class="container">
            <div class="row">
                <%
                    for (Product product : productList) {
                %>
                <div class="col-md-4 mb-4">
                    <a href="<%= "detail.jsp?productId=" + product.getProductId() %>" class="card-link" style="text-decoration: none; color: inherit;">
                        <div class="card h-100">
                            <img src="<%= product.getImageURL() %>" class="card-img-top" alt="<%= product.getProductName() %>">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title"><%= product.getProductName() %></h5>
                                <p class="card-text flex-fill"><%= product.getDescription() %></p>
                                <p class="card-text">Price: $<%= product.getPrice() %></p>
                                <a href="<%= "detail.jsp?productId=" + product.getProductId() %>" class="btn btn-primary mt-auto">View Details</a>
                            </div>
                        </div>
                    </a>
                </div>
                <%
                    }
                %>
            </div>
        </div>



        <!-- Bootstrap JS (optional) -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
</html>
