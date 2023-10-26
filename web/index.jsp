<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="model.Product"%>
<%@page import="dal.ProductDAO"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Product List</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css">


        <link rel="stylesheet" href="./css/index.css">
        <!-- Option 1: Include in HTML -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
        <style>
            .custom-card {
                margin: 5px;  /* Khoảng cách giữa các thẻ */
                padding: 10px; /* Khoảng cách giữa nội dung và viền của thẻ */
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="navbar-nav ml-auto row navbar">
                <i class="bi bi-list h4"></i>
                <div class="wrap-search-bar">
                    <input class="search-bar">
                    <i class="bi bi-search search-icon"></i>
                </div>




                <div class="wrap-right-navbar"> 
                    <i class="fas fa-user"></i>
                    <button class="btn-primary rounded">
                        <i class="fa-solid fa-cart-shopping "></i> Your Cart
                    </button>
                </div> 
            </div> 
            <div><h1>Product List</h1> 
                <%
Integer userID = (Integer) session.getAttribute("userID");
boolean isUserLoggedIn = userID != null;
                %>
                <% if (!isUserLoggedIn) { %>
                <form action="http://localhost:8080/projectPRJ113/login" method="get">
                    <button type="submit" alt="btn-link-login" class="btn btn-outline-success me-2">Login</button>
                </form>
                <% } %>


                <!-- User Icon Link -->
                <a href="userDetail.jsp" alt="btn-link-user-detail">
                    <i class="bi bi-list"></i>
                </a>
                <div class="row">
                    <% 
                        ProductDAO productDAO = new ProductDAO();
                        List<Product> products = productDAO.getAll();
                        NumberFormat numberFormat = NumberFormat.getNumberInstance();
                        numberFormat.setMinimumFractionDigits(3);
                        numberFormat.setMaximumFractionDigits(3);
                        if (products != null && !products.isEmpty()) {
                            for (Product product : products) {
                                if (product != null) {
                    %>
                    <div class="col-md-4">
                        <a href="detail.jsp?productId=<%= product.getProductId() %>" class="card-link"><!<!-- bam vao card  -->
                            <div class="card h-100" style="width: 18rem; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);">
                                <img src="<%= product.getImageURL() != null ? product.getImageURL() : "default.jpg" %>" class="card-img-top" alt="Image not found">
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title">
                                        <% 
                                        if (product.getProductName() != null) {
                                          out.print(product.getProductName());
                                        } else {
                                          out.print("N/A");
                                        }
                                        %>
                                    </h5>
                                    <p class="card-text flex-grow-1">
                                        <% 
                                        if (product.getDescription() != null) {
                                          out.print(product.getDescription());
                                        } else {
                                          out.print("N/A");
                                        }
                                        %>
                                    </p>
                                    <div class="price-info">
                                        <% if (product.getDiscountPercentage() == 0) { %>
                                        <span class="original-price">Price: <%= numberFormat.format(product.getPrice()) %>đ</span>
                                        <% } else { %>
                                        <div>
                                            <span class="original-price" style="text-decoration: line-through;">Price: <%= numberFormat.format(product.getPrice()) %>đ</span>
                                        </div>
                                        <div>
                                            <span class="discounted-price">==> Price: <%= numberFormat.format(product.getPrice() * (1 - product.getDiscountPercentage() / 100)) %>đ</span>
                                        </div>
                                        <% } %>
                                    </div>
                                    <div class="discount-info">
                                        <% if (product.getDiscountPercentage() != 0) { %>
                                        <span class="discount-percentage">discount: <%= product.getDiscountPercentage() %> % off</span>
                                        <% } %>
                                    </div>

                                    <!-- Form để thêm sản phẩm vào giỏ hàng -->
                                    <form action="AddToCartServlet" method="post">
                                        <input type="hidden" name="productId" value="<%= product.getProductId()%>">
                                        <button type="submit" class="btn btn-primary mt-auto">Buy now</button>
                                    </form>
                                </div>
                            </div>
                    </div>
                    <% 
                                }
                            }
                        } else {
                    %>
                    <div class="col-md-12">
                        <p>No products found.</p>
                    </div>
                    <% 
                        }
                    %>
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js"></script>
    </body>
</html>