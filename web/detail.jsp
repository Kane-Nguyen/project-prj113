<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="model.Product"%>
<%@page import="model.Users"%>
<%@page import="model.ReviewsAndRatings"%>
<%@page import="dal.ProductDAO"%>
<%@page import="dal.UsersDAO"%>
<%@page import="dal.ReviewsAndRatingsDAO"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Product Detail</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js"></script>
        <style>
            .rating {
                display: inline-block;
                font-size: 24px;
                direction: rtl; /* Thêm dòng này để đảo ngược thứ tự */
            }

            .rating input {
                display: none;
            }

            .rating label {
                cursor: pointer;
            }

            .rating label:before {
                content: "\2605"; /* Unicode character for a star */
                color: #ddd;
                font-size: 24px;
            }

            .rating input:checked ~ label:before,
            .rating label:hover ~ label:before,
            .rating label:hover:before {
                color: #f1c40f; /* Color for selected stars */
            }
            body {
                font-family: 'Arial', sans-serif;
                background-color: #f4f4f4;
            }

            .container {
                background-color: #ffffff;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .original-price {
                text-decoration: line-through;
                color: #888;
            }

            .discounted-price {
                color: #e74c3c;
                font-weight: bold;
            }

            .discount-percentage {
                color: #2ecc71;
            }

            .review {
                padding: 10px 0;
            }

            .review strong {
                font-weight: bold;
            }

            .rating label:before {
                font-size: 18px;
            }

            .btn-primary {
                background-color: #e74c3c;
                border-color: #e74c3c;
            }


        </style>


    </head>
    <body>



        <div class="container">
            <h1>Product Detail</h1> 
            <div class="row">
                <%
     ProductDAO productDAO = new ProductDAO();
     List<Product> products = productDAO.getAll();
     NumberFormat numberFormat = NumberFormat.getNumberInstance();
     numberFormat.setMinimumFractionDigits(3);
     numberFormat.setMaximumFractionDigits(3);

     // Lấy productId từ yêu cầu HTTP
     String requestedProductId = request.getParameter("productId");

     if (products != null && !products.isEmpty()) {
         for (Product product : products) {
             if (product != null) {
                 String productId = product.getProductId(); // Lấy productId của sản phẩm

 
                 if (requestedProductId != null && requestedProductId.equals(productId)) {
                %>
                <div>
                    <div style="display: flex">
                        <!-- Hiển thị thông tin sản phẩm -->
                        <img class="card h-100 custom-card" style="width: 30rem ;box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);" src="<%= product.getImageURL() != null ? product.getImageURL() : "default.jpg" %>" class="card-img-top" alt="Image not found">
                        <div style="width: 100%; padding-left: 20px" >
                            <h3 style="color: red"><%= product.getProductName() %></h3>
                            <h5>Category: <%= product.getCategory() %></h5>
                            <h5><%= product.getManufacturer() %></h5>
                            <div>
                                <% if (product.getDiscountPercentage() == 0) { %>
                                <span class="original-price">Price: <%= numberFormat.format(product.getPrice()) %>đ</span>
                                <% } else { %>
                                <div>
                                    <span class="original-price">Price: <%= numberFormat.format(product.getPrice()) %>đ</span>
                                </div>
                                <div>
                                    <span class="discounted-price">==> Price: <%= numberFormat.format(product.getPrice() * (1 - product.getDiscountPercentage() / 100)) %>đ</span>
                                </div>
                                <% } %>
                            </div>
                            <div class="discount-info" style="color: black">
                                <% if (product.getDiscountPercentage() != 0) { %>
                                <span class="discount-percentage">discount: <%= product.getDiscountPercentage() %> % off</span>
                                <% } %>
                            </div>
                            <a href="#" class="btn btn-primary mt-auto">Buy now</a>
                            <a href="#" class="btn btn-primary mt-auto">Order</a>
                        </div>
                    </div>

                    <div style="margin-top: 20px">
                        <h3>Book Overview</h3>
                        <p><%= product.getDescription() %></p>
                    </div>


                    <%
                        Integer userID = (Integer) session.getAttribute("userID");
                        if (userID != null) {
                    %>

                    <!-- Form for user to input comment -->
                    <form action="ReviewsAndRatingsServlet" method="post" onsubmit="return validateForm()">
                        <div style="margin-top: 20px">
                            <h4>Comment:</h4>

                            <input type="hidden" name="productID" value="<%= requestedProductId %>">
                            <input type="hidden" name="userID" value="<%= session.getAttribute("userID")%>"> <!-- Replace with actual user ID -->
                            <div class="form-group">
                                <textarea name="comment" placeholder="Your comment..." class="form-control" rows="4"></textarea>
                            </div>
                            <h4>Rating:</h4><div class="rating">
                                <input type="radio" name="rating" value="5" id="rating5" />
                                <label for="rating5"></label>

                                <input type="radio" name="rating" value="4" id="rating4" />
                                <label for="rating4"></label>

                                <input type="radio" name="rating" value="3" id="rating3" />
                                <label for="rating3"></label>

                                <input type="radio" name="rating" value="2" id="rating2" />
                                <label for="rating2"></label>

                                <input type="radio" name="rating" value="1" id="rating1" />
                                <label for="rating1"></label>
                            </div> <br>


                            <input type="submit" value="Submit Review" class="btn btn-primary">

                        </div>
                    </form>
                    <%
} else {
                    %>
                    <!-- Thông Báo Yêu Cầu Đăng Nhập -->
                    <div style="margin-top: 20px">
                        <p>Bạn cần phải <a href="login.jsp">đăng nhập</a> để có thể bình luận và đánh giá sản phẩm.</p>
                    </div>
                    <%
                        }
                    %>

                    <!-- Display All Reviews for this product -->

                    <div style="margin-top: 20px">
                        <%
                            ReviewsAndRatingsDAO reviewDao = new ReviewsAndRatingsDAO();
                            List<ReviewsAndRatings> reviews = reviewDao.getAllReviewsAndRatings();
                            UsersDAO us = new UsersDAO();
                            List<Users> u = us.getAll();
                            
                            List<ReviewsAndRatings> ratingsList = reviewDao.getLatestRatingsByUserForProduct(requestedProductId);
                            double totalRating = 0;
                            for (ReviewsAndRatings r : ratingsList) {
                                    totalRating += r.getRating();
                            }
                            double averageRating = (ratingsList.size() > 0) ? totalRating / ratingsList.size() : 0; %>
                        <h2>Average Rating: <%= averageRating %></h2>

                        <%  for (ReviewsAndRatings review : reviews) {                              
                                if (review.getProductID().equals(requestedProductId)) {                                
                        %>
                        <h3>Comment:</h3>

                        <div class="review">
                            <strong><%= u.get(review.getUserID()).getFullName() %></strong>
                            <p><%= review.getComment() %> ------- <%= review.getDatePosted() %> </p>
                            Rating: 
                            <% for (int i = 0; i < review.getRating(); i++) { %>
                            <span>&#9733;</span> <!-- Unicode character for a filled star -->
                            <% } %>
                            <% for (int i = 0; i < 5 - review.getRating(); i++) { %>
                            <span>&#9734;</span> <!-- Unicode character for an empty star -->
                            <% } %>
                        </div>

                        <hr/>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
                <%
                                }
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
    </body>
</html>