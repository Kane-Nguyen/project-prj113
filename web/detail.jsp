<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="model.Product"%>
<%@page import="model.Users"%>
<%@page import="model.ReviewsAndRatings"%>
<%@page import="dal.ProductDAO"%>
<%@page import="dal.UsersDAO"%>
<%@page import="dal.CategoryDAO"%>
<%@page import="dal.ReviewsAndRatingsDAO"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Product Detail</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" href="./css/index.css">
        <!-- Option 1: Include in HTML -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
    </head>
    <body>



        <div class="container">
            <div class="navbar-nav ml-auto row navbar">
                <i class="bi bi-list h4"></i>
                <div class="wrap-search-bar">
                    <input class="search-bar" placeholder="Nhập để tìm kiếm">
                    <i class="bi bi-search search-icon search-icon"></i>
                </div>
                <div class="list-navbar">
                    <ul class="list-features-navbar">
                        <a href="/"><li>Home</li></a> 
                        <a href=""><li class="active">Detail Book</li></a> 
                        <a><li>About US</li></a> 
                    </ul>
                </div>
                <div class="wrap-right-navbar"> 
                    <%
                   Integer userID = (Integer) session.getAttribute("userID");
                   boolean isUserLoggedIn = userID != null;
                    %>
                    <% if (!isUserLoggedIn) { %>
                    <a href="login" class="prevent-a-tag">
                        <i class="bi bi-person icon-person-navbar h4 "></i>
                    </a>
                    <% }else { %>
                    <a href="userDetail.jsp" class="prevent-a-tag">
                        <i class="bi bi-person icon-person-navbar h4 "></i>
                    </a>
                    <%} %>
                    <a href="cart.jsp">
                        <button class="btn-primary rounded btn-cart">
                            <i class="bi bi-cart h5"></i> Your Cart
                        </button>
                    </a>
                    <% if (isUserLoggedIn) { %>
                    <a href="Logout" class="prevent-a-tag">
                        <i class="bi bi-box-arrow-in-left h4"></i>
                    </a><%
                        }
                    %>
                </div> 
            </div> 
            <div class="row">
                <%
     CategoryDAO cbDAO = new CategoryDAO();
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
                    <div class="book-wrap">
                        <!-- Hiển thị thông tin sản phẩm -->
                        <img class="custom-card image-book-detail" src="<%= product.getImageURL() != null ? product.getImageURL() : "default.jpg" %>" class="card-img-top" alt="Image not found">
                        <div class="detail-book" >
                            <h3 class="title-detail-book"><%= product.getProductName() %></h3>
                            <h5>The kind of book: <span class="category-detail"><%= cbDAO.getCategoryByProductId(product.getCategoryId()) %></span></h5>
                            <h5 class="author-detail-book"><%= product.getAuthor() %></h5>
                            <div>
                                <% if (product.getDiscountPercentage() == 0) { %>
                                <span class="discount-price-detail"><%= numberFormat.format(product.getPrice()) %>đ</span>
                                <% } else { %>
                                <div>
                                    <span class="original-price not-sale"> <%= numberFormat.format(product.getPrice()) %>đ</span>
                                </div>
                                <div>
                                    <span class="discount-price-detail"> <%= numberFormat.format(product.getPrice() * (1 - product.getDiscountPercentage() / 100)) %>đ</span>
                                </div>
                                <% } %>
                            </div>
                            <%
    if (isUserLoggedIn) {
                            %>
                            <form action="Buy.jsp">
                                <input type="hidden" name="productId" value="<%= product.getProductId()%>">
                                <input type="hidden" name="productName" value="<%= product.getProductName()%>">
                                <input type="hidden" name="quantity" value="1">
                                <input type="hidden" name="originalPrice" value="<%= numberFormat.format(product.getPrice())%>">
                                <input type="hidden" name="discountedPrice" value="<%= product.getDiscountPercentage()%>">
                                <button type="submit" class="btn btn-primary mt-auto w-100">Buy now</button>
                            </form>
                            <form action="AddToCartServlet" method="post">
                                <input type="hidden"name="productId" value="<%= product.getProductId()%>">
                                <button type="submit" class="btn btn-primary btn-custom-add-cart mt-auto w-100">Add to cart</button>
                            </form>
                            <%
} else {
                            %>
                            <div class="button-wrap-detail">
                                <button type="button" class="btn btn-primary mt-auto require-login-btn w-100">Buy now</button>
                                <button type="button" class="btn btn-primary mt-auto require-login-btn w-100 btn-custom-add-cart">Add to cart</button>
                            </div>

                            <div id="loginAlert" style="display:none;" class="alert alert-danger mt-2">
                                Bạn cần đăng nhập để thực hiện chức năng này! <a href="login.jsp">Đăng nhập ngay</a>
                            </div>
                            <%
                                }
                            %>
                            <script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                            <script type="text/javascript">
                                $(document).ready(function () {
                                    $(".require-login-btn").click(function () {
                                        $("#loginAlert").show();
                                    });
                                });
                            </script>
                        </div>
                    </div>

                    <div class="book-description">
                        <h4 class="book-description-header">Book Overview</h3>
                            <p class="book-descriptionp-content"><%= product.getDescription() %></p>
                    </div>


                    <%
    if (isUserLoggedIn) {
                    %>

                    <!-- Form for user to input comment -->
                    <form action="ReviewsAndRatingsServlet" method="post" onsubmit="return validateForm()">
                        <div class="comment-wrap">
                            <h4>Comment:</h4>

                            <input type="hidden" name="productID" value="<%= requestedProductId %>">
                            <input type="hidden" name="userID" value="<%= session.getAttribute("userID")%>"> <!-- Replace with actual user ID -->
                            <div class="form-group comment-input-wrap">
                                <textarea name="comment" placeholder="Your comment..." class="form-control comment-input" rows="4"></textarea>
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
                            List<ReviewsAndRatings> l = reviewDao.getReviewsByProductID(requestedProductId);
                            double totalRating = 0;
                            for (ReviewsAndRatings r : l) {
                                    totalRating += r.getRating();
                            }
                            double averageRating = Math.ceil((l.size() > 0) ? totalRating / l.size() : 0); 
                            if(averageRating == 1){
                        %>
                        <div class="average-rating">
                            <div class="rating-star-wrap">
                                <div class="background-line-detail"></div>
                                <div class="rating-line-detail-1"></div>

                            </div>
                            <span class="rating-number">1.0</span>
                        </div>
                        <%  }else if(averageRating == 2) {  %>
                        <div class="average-rating">
                            <div class="rating-star-wrap">
                                <div class="background-line-detail"></div>
                                <div class="rating-line-detail-2"></div>

                            </div>
                            <span class="rating-number">2.0</span>
                        </div>


                        <%  }else if(averageRating == 3) {%> 
                        <div class="average-rating">
                            <div class="rating-star-wrap">
                                <div class="background-line-detail"></div>
                                <div class="rating-line-detail-3"></div>

                            </div>
                            <span class="rating-number">3.0</span>
                        </div>

                        <% }%>
                        <%  for (ReviewsAndRatings review : reviews) {                              
                                if (review.getProductID().equals(requestedProductId)) {                                
                        %>

                        <div class="review">
                            <div class="wrap-name-rating">
                                <%
                                try {
                                %>
                                <strong><%= u.get(review.getUserID()).getFullName() %></strong>
                                <%
                                } catch (Exception e) {
                                    e.printStackTrace(); // This will print the error details to your server's console
                                }
                                %>
                                <span class="date-rating"><%= review.getDatePosted() %></span>
                            </div>
                            <p><%= review.getComment() %> </p>
                            Rating: 
                            <% for (int i = 0; i < review.getRating(); i++) { %>
                            <span><i class="bi bi-star-fill rating-solid-star"></i></span> <!-- Unicode character for a filled star -->
                            <% } %>
                            <% for (int i = 0; i < 5 - review.getRating(); i++) { %>
                            <span><i class="bi bi-star"></i></span> <!-- Unicode character for an empty star -->
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
