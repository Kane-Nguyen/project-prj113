<%@page import="java.util.List"%>
<%@page import="model.Product"%>
<%@page import="dal.ProductDAO"%>
<%@page import="java.util.*"%>
<%@page import="dal.CategoryDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>All Products</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/ShowAll.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
    </head>
    <body>
        <div class="container-fluid">


            <h1 style="text-align: center">Bookstore</h1>
            <div class="product-row row">
                <i class="bi bi-list h4 list-show-all-book ml-5"></i> <a class="btn btn-primary" href="index.jsp" style="color: white; text-decoration: none; font-size: 15px; font-weight: 400 ;margin-left: 5px;height: 40px;">Home</a>
                <div class="col-lg-2 col-md-3 col-sm-12 filter-form ">
                    <form action="select" method="get">
                        <% 
                        String[] selectedCategories = request.getParameterValues("cardId");
                        Set<String> selected = selectedCategories != null ? new HashSet<>(Arrays.asList(selectedCategories)) : new HashSet<>();
                        %>
                        <% for(int i = 1; i <= 12; i++) { %>
                        <div class="form-check hidden">
                            <input class="form-check-input" type="checkbox" name="cardId" value="<%= i %>" id="cardId<%= i %>" <%= selected.contains(String.valueOf(i)) ? "checked" : "" %>>
                            <label class="form-check-label" for="cardId<%= i %>">
                                <% switch(i) {
                                    case 1: out.print("Self-help"); break;
                                    case 2: out.print("Literature"); break;
                                    case 3: out.print("Psychology"); break;
                                    case 4: out.print("Horror"); break;
                                    case 5: out.print("Mystery"); break;
                                    case 6: out.print("Manga"); break;
                                    case 7: out.print("Detective"); break;
                                    case 8: out.print("Light Novel"); break;
                                    case 9: out.print("Comic"); break;
                                    case 10: out.print("Fantasy"); break;
                                    case 11: out.print("Criminal"); break;
                                    default: out.print("Legend"); break;
                                } %>
                            </label>
                        </div>
                        <% } %>
                        <div><i class="bi bi-arrow-bar-up h4 scroll-up"></i>
                        </div>
                    </form>

                </div>
                <!-- Products Column -->
                <div class="col-lg-10 col-md-9 col-sm-12">
                    <div class="row" id="products-container">
                        <%  
                        CategoryDAO cbDAO = new CategoryDAO();
                        ProductDAO productDAO = new ProductDAO();
                        List<Product> productList = productDAO.getAll();
                        List<Product> requestProductList = (List<Product>) request.getAttribute("products");
                      
                        if (requestProductList != null) {
                            productList = requestProductList;
                        }
                        if (productList == null || productList.isEmpty()) {
                            out.println("<p>No products found.</p>");
                        } else {
                            for (Product product : productList) {
                        %>
                        <div class="col-6 col-xl-2-4 mb-4">
                            <div class="card h-100">
                                <img src="<%= product.getImageURL() %>" class="card-img-top" alt="<%= product.getProductName() %>">
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title"><%= product.getProductName() %></h5>
                                    <%
                                     int totalPriceAsInt = (int) Math.round(product.getPrice());
                                        NumberFormat formatter = NumberFormat.getIntegerInstance();
                                        String formattedPrice11 = formatter.format(totalPriceAsInt);
                                    %>
                                    <p class="card-text">Price: <%=  formattedPrice11%> VNĐ</p>
                                    <p>genre: <span class="category-detail"><%= cbDAO.getCategoryByProductId(product.getCategoryId()) %></span></p>
                                    <a href="<%= "detail.jsp?productId=" + product.getProductId() %>" class="btn btn-primary mt-auto">View Details</a>
                                </div>
                            </div>
                        </div>
                        <% 
                            }
                        }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS and Popper.js -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script>
            $(document).ready(function () {
                $('.filter-form').hide();
                $('.list-show-all-book').on("click", function () {

                    $('.filter-form').show();
                });
                $('.scroll-up').on("click", function () {

                    $('.filter-form').hide();
                });
                

                $('input[name="cardId"]').change(function () {
                    this.form.submit();
                });
            });

            $(document).ready(function () {
                $("#toggleCheckbox").click(function () {
                    $(".form-check").toggle();
                });
            });
        </script>
    </body>
</html>
