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
        <link rel="stylesheet" href="./css/test.css">
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
        <%
                 Integer userID = (Integer) session.getAttribute("userID");
                 boolean isUserLoggedIn = userID != null;
        %>
        <div class="wrap-model">
            <div class="model">
                <ul class="list-model">

                    <% if (!isUserLoggedIn) { %>
                    <a href="login" class="prevent-a-tag">
                        <i class="bi bi-person icon-person-navbar h4 "></i>
                    </a>
                    <% }else { %>
                    <li>
                        <a href="userDetail.jsp" class="prevent-a-tag">
                            PROFILE
                        </a>
                    </li>
                    <%} %>
                    <% if (isUserLoggedIn) { %>
                    <li>
                        <a href="cart.jsp" class="prevent-a-tag">
                            YOUR CART
                        </a>
                    </li>
                    <%} %>
                    <% if (isUserLoggedIn) { %>
                    <li>
                        <a href="Logout" class="prevent-a-tag">
                            LOG OUT
                        </a>
                    </li>
                    <%
                   }
                    %>
                    <i class="bi bi-box-arrow-in-left close-model"></i>
                </ul>
            </div>
        </div>
        <div class="container">
            <div class="navbar-nav ml-auto row navbar">
                <i class="bi bi-list h4 show-list-icon"></i>

                <div class="wrap-search-bar">
                    <form id="searchForm" action="search.jsp" method="post" accept-charset="UTF-8">           
                        <input class="search-bar" id="searchInput" name="search" placeholder="Nhập để tìm kiếm" value="">
                        <i id="submitSearch"  class="bi bi-search search-icon search-icon"></i>
                    </form>

                </div>
                <div class="wrap-right-navbar"> 

                    <% if (!isUserLoggedIn) { %>
                    <a href="login" class="prevent-a-tag">
                        <i class="bi bi-person icon-person-navbar h4 "></i>
                    </a>
                    <% }else { %>
                    <a href="userDetail.jsp" class="prevent-a-tag">
                        <i class="bi bi-person icon-person-navbar h4 "></i>
                    </a>
                    <%} %>
                    <% if (isUserLoggedIn) { %>
                    <a href="cart.jsp" class="prevent-a-tag">
                        <button class="btn-primary rounded btn-cart">
                            <i class="bi bi-cart h5"></i> Your Cart
                        </button>
                    </a>
                    <a href="paid.jsp" class="prevent-a-tag">
                        <button class="btn-primary rounded btn-cart">
                            <i class="bi bi-wallet2 h5"></i> Your Paid
                        </button>
                    </a>
                    <%if(session.getAttribute("role").equals("Admin")){%>
                    <a href="admin.jsp" class="prevent-a-tag">
                        <button class="btn-primary rounded btn-cart btn-danger">
                            <i class="bi bi-shop h5"></i> Admin
                        </button>
                    </a>
                    <%} }%>
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
            <div id="loginAlert" style="display:none;" class="alert alert-danger mt-2">
                You have to Sign in to using this feature <a href="login.jsp">Sign In</a>
            </div>
            <div class="book-store">
                <i class="bi bi-arrow-left-circle h3" id="arrow-left"></i>
                <div class="row wrap-book-store" id="scroll-book">
                    <% 
                        ProductDAO productDAO = new ProductDAO();
                        List<Product> products = productDAO.getAll();
                        int count = 0;
                        if (products != null && !products.isEmpty()) {
                            for (Product product : products) {
                                if (product != null) {
                                count++;
                                if(count == 10){
                                break;
                        }
                    %>
                    <a href="detail.jsp?productId=<%= product.getProductId() %>" class="prevent-a-tag">
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
                                    <%
                                
                                        int totalPriceAsInt1 = (int) Math.round(product.getPrice());
                                        NumberFormat formatter = NumberFormat.getIntegerInstance();
                                        String formattedPrice11 = formatter.format(totalPriceAsInt1);
                                    %>
                                    <% if (product.getDiscountPercentage() == 0) { %>
                                    <span class="original-price"><%=formattedPrice11 %> đ</span>
                                    <% } else { %>
                                    <div>
                                        <span class="book-price book-original-price" style="text-decoration: line-through;"><%= formattedPrice11 %> đ</span>
                                    </div>
                                    <div>
                                        <%
                                        int totalPriceAsInt = (int) Math.round(product.getPrice() * (1 - product.getDiscountPercentage() / 100));
              
                                        String formattedPrice1 = formatter.format(totalPriceAsInt);
                                        %>
                                        <span class="discounted-price"> <%= formattedPrice1 %>đ</span>
                                    </div>
                                    <% } %>
                                </div>
                                </a>
                                <!-- Form để thêm sản phẩm vào giỏ hàng -->
                                <%  if (isUserLoggedIn) {%>
                                <form action="AddToCartServlet" method="post" class="add-to-cart-home">
                                    <input type="hidden" name="productId" value="<%= product.getProductId()%>">
                                    <input type="hidden" name="method" value="index" >
                                    <button type="submit" class="btn-primary mt-auto btn-add-to-cart "> <i class="bi bi-cart h5"></i>Add to cart</button>
                                </form>
                                <% } else{
                                %>                                   <div class="button-wrap-detail">
                                    <button type="submit" class="btn-primary mt-auto btn-add-to-cart require-login-btn "> <i class="bi bi-cart h5"></i>Add to cart</button>

                                </div>
                                <% } %>

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
                  
                </div>
                <div class="footer-right">
                    <h3>Social Media</h3>
                    <div class="social-media">
                        <a href="https://www.facebook.com/profile.php?id=61553300578539&is_tour_dismissed=true"><i class="bi bi-facebook h5"></i></a>
                    </div>

                </div>
            </div>
        </div>

        <script type="text/javascript">

            $(document).ready(function () {
                hidePopup();
                $(".list-item").on("click", function () {

                    $(".wrap-right-navbar").show();
                })
                $(".require-login-btn").click(function () {
                    $("#loginAlert").show();
                });
                function showPopup() {
                    $('.model').fadeIn(); // This will slowly fade in the popup
                    $('.wrap-model').fadeIn();
                }

                // Function to hide the popup
                function hidePopup() {
                    $('.wrap-model').fadeOut();
                    $('.model').fadeOut(); // This will slowly fade out the popup
                }

                // Example of binding the showPopup function to a button click
                $('.show-list-icon').click(function () {
                    showPopup();
                });

                // Hiding the popup when clicking on the background
                $('.close-model').click(function (event) {
                    // Check if the clicked area is the background and not the model itself
                    hidePopup();
                });
                $('.wrap-model').click(function (event) {

                    // Check if the clicked area is the background and not the model itself
                    if (event.target === this) {
                        hidePopup();
                    }
                });

                // Optionally, to prevent <a> tags from navigating away when clicked, you can use:
            });
        </script>
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