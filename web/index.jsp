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
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" href="./css/index.css">
        <!-- Option 1: Include in HTML -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
        <script>
            $(document).ready(function () {
                $('#searchForm').on('submit', function (event) {
                    var searchValue = $('#searchInput').val().trim();
                    if (searchValue === "") {
                        event.preventDefault(); // Ngăn không cho form submit nếu ô tìm kiếm trống
                    } else {
                        console.log("Data to be sent: " + searchValue); // Log dữ liệu sẽ gửi
                    }
                    // Nếu có dữ liệu, form sẽ tự động submit bằng HTTP POST đến "searchServlet"
                });
                $('#searchInput').keydown(function (event) {
                    if (event.keyCode === 13) {
                        $('#searchForm').submit(); // Kích hoạt sự kiện submit của form
                    }
                });

                $('#submitSearch').click(function () {
                    $('#searchForm').submit(); // Kích hoạt sự kiện submit khi click vào icon
                });
            });

        </script>
    </head> 
    <body>
        <div class="container">
            <div class="navbar-nav ml-auto row navbar">
                <i class="bi bi-list h4"></i>
                <div class="wrap-search-bar">
                    <form id="searchForm" action="search.jsp" method="post" accept-charset="UTF-8">           
                        <input class="search-bar" id="searchInput" name="search" placeholder="Nhập để tìm kiếm" value="">
                        <i id="submitSearch"  class="bi bi-search search-icon search-icon"></i>
                    </form>

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
            <div class="content-introduction">
                <div class="wrap-content">
                    <div class="content-left w-50">
                        <h2 class="content-header">New Releases This Week</h2>
                        <p class="content-des">It's time to update your reading list with some of the latest and greatest releases in the literary world. From heart-pumping thrillers to captivating memoirs, this week's new releases offer something for everyone</p>
                        <button class="content-contact btn-primary rounded prevent-buttom-tag">Contact</button>

                    </div>
                    <div class="content-right w-50">
                        <div class="wrap-content-right">
                            <img class="img-home-bg-3" src="./asset/images/home-images/home-bg-0.png" alt="bg-1"/>
                            <img class="img-home-bg-2" src="./asset/images/home-images/home-bg-1.png" alt="bg-2"/>
                            <img class="img-home-bg-1" src="./asset/images/home-images/home-bg-2.png" alt="bg-3"/> 
                        </div>
                    </div>
                </div>

            </div>
            <div class="book-store">
                <i class="bi bi-arrow-left-circle h3" id="arrow-left"></i>
                <div class="row wrap-book-store" id="scroll-book">
                    <% 
                        ProductDAO productDAO = new ProductDAO();
                        List<Product> products = productDAO.getAll();
                        NumberFormat numberFormat = NumberFormat.getNumberInstance();
                        numberFormat.setMinimumFractionDigits(3);
                        numberFormat.setMaximumFractionDigits(3);
                        int count = 0;
                        if (products != null && !products.isEmpty()) {
                            for (Product product : products) {
                                if (product != null) {
                                count++;
                                if(count == 10){
                                break;
                        }
                    %>
                    <a href="detail.jsp?productId=<%= product.getProductId() %>" >
                        <div class="d-flex" >
                            <img src="<%= product.getImageURL() != null ? product.getImageURL() : "default.jpg" %>" class="book-image" alt="Image not found">
                            <div class="d-flex flex-column justify-content-center">
                                <h5 class="book-title">
                                    <% 
                                    if (product.getProductName() != null) {
                                        out.print(product.getProductName());
                                    } else {
                                        out.print("N/A");
                                    }
                                    %>
                                </h5>

                                <div class="book-price">
                                    <% if (product.getDiscountPercentage() == 0) { %>
                                    <span class="original-price"><%= numberFormat.format(product.getPrice()) %> đ</span>
                                    <% } else { %>
                                    <div>
                                        <span class="book-price book-original-price" style="text-decoration: line-through;"><%= numberFormat.format(product.getPrice()) %> đ</span>
                                    </div>
                                    <div>
                                        <span class="discounted-price"> <%= numberFormat.format(product.getPrice() * (1 - product.getDiscountPercentage() / 100)) %>đ</span>
                                    </div>
                                    <% } %>
                                </div>

                                <!-- Form để thêm sản phẩm vào giỏ hàng -->
                                <form action="AddToCartServlet" method="post" class="add-to-cart-home">
                                    <input type="hidden" name="productId" value="<%= product.getProductId()%>">
                                    <button type="submit" class="btn-primary mt-auto btn-add-to-cart "> <i class="bi bi-cart h5"></i>Add to cart</button>
                                </form>
                            </div>
                        </div>
                    </a>
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
                <i class="bi bi-arrow-right-circle h3" id="arrow-right"></i>
            </div>
            <div class="d-flex justify-content-center">
                <a href="showAll.jsp" >See more books</a>

            </div>

            <div class="footer">
                <div class="footer-left">
                    <div class="logo">
                        <img class="logo-img" src="./asset/images/home-images/logo.png" alt="logo"/>
                    </div>
                    <div class="features">
                        <ul class="list-features">
                            <a> <li>All of books</li></a>
                            <a> <li>Payment</li></a>
                            <a> <li>Contact US</li></a>
                            <a> <li>Our Developer Team</li></a>
                        </ul>
                    </div> 
                </div>
                <div class="footer-right">
                    <h3>Social Media</h3>
                    <div class="social-media">
                        <a><i class="bi bi-facebook h5"></i></a>
                        <a><i class="bi bi-instagram h5"></i></a>
                    </div>

                </div>
            </div>
        </div>
        <script>
            $(document).ready(function () {
                var scrollContainer = $(".wrap-book-store");
                var currentScrollPosition = scrollContainer.scrollLeft();
                if (currentScrollPosition === 0) {
                    $("#arrow-left").css("display", "none");
                } else {
                    $("#arrow-left").css("display", "block");
                }

                $("#arrow-right").on("click", function () {

                    var scrollContainer = $(".wrap-book-store");
                    var widthScrollContainer = $(".wrap-book-store");
                    var currentScrollPosition = scrollContainer.scrollLeft();
                    var newScrollPosition = currentScrollPosition + 340;
                    if (newScrollPosition === 0) {
                        $("#arrow-left").css("display", "none");
                    } else {
                        $("#arrow-left").css("display", "block");
                    }
                    scrollContainer.animate({scrollLeft: newScrollPosition}, "slow");
                });
                $("#arrow-left").on("click", function () {
                    var scrollContainer = $(".wrap-book-store");
                    var currentScrollPosition = scrollContainer.scrollLeft();
                    var newScrollPosition = currentScrollPosition - 360;
                    if (newScrollPosition === 0) {
                        $("#arrow-left").css("display", "none");
                    } else {
                        $("#arrow-left").css("display", "block");
                    }
                    scrollContainer.animate({scrollLeft: newScrollPosition}, "slow");
                });

            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js"></script>
    </body>
</html>