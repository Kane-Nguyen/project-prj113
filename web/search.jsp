<%@page import="dal.ProductDAO"%>
<%@page import="java.util.List"%>
<%@page import="model.Product"%>
<%@page import="java.net.URLDecoder"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>All Products</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
    <%
             String query = request.getParameter("search");
             if(query == null || query.isEmpty()){
              response.sendRedirect("index.jsp");
        }
              ProductDAO productDAO = new ProductDAO();
              List<Product> productList = productDAO.searchProductsByName(query);
    %>
    <body>
        <h1>All Products</h1>
        <div class="container">
            <div class="navbar-nav ml-auto row navbar">
                <i class="bi bi-list h4"></i>
                <div class="wrap-search-bar">
                    <form id="searchForm" action="search.jsp" method="post" accept-charset="UTF-8">           
                        <input class="search-bar" id="searchInput" name="search" placeholder="Nhập để tìm kiếm" value="<%=query%>">
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

            <div class="container">
                <div class="row">
                    <%
                        if (productList.isEmpty()) {
                    %>
                    <div class="col-12">
                        <div class="alert alert-info" role="alert">
                            Your keyword's not matching any books.
                        </div>
                    </div>
                    <%
                        } else {
                            for (Product product : productList) {
                    %>
                    <div class="col-md-4 mb-4">
                        <a href="<%= "detail.jsp?productId=" + product.getProductId() %>" class="card-link" style="text-decoration: none; color: inherit;">
                            <div class="card h-100">
                                <img src="<%= product.getImageURL() %>" class="card-img-top" alt="<%= product.getProductName() %>">
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title"><%= product.getProductName() %></h5>
                                    <p class="card-text flex-fill"><%= product.getDescription() %></p>
                                    <p class="card-text">Price: <%= product.getPrice() %> VNĐ</p>
                                    <a href="<%= "detail.jsp?productId=" + product.getProductId() %>" class="btn btn-primary mt-auto">View Details</a>
                                </div>
                            </div>
                        </a>
                    </div>
                    <%
                        } }
                    %>
                </div>
            </div>



            <!-- Bootstrap JS (optional) -->
            <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
</html>
