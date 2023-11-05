<%@page import="java.util.List"%>
<%@page import="model.Product"%>
<%@page import="dal.ProductDAO"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>All Products</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/ShowAll.css">
    </head>
    <body>
        <div class="container-fluid">
            <h1>All Products</h1>
            <div class="product-row row">
                <div class="col-lg-2 col-md-3 col-sm-12 filter-form">
                    <h4>Select your choice</h4>
                    <button id="toggleCheckbox" class="btn btn-primary mt-2">Menu</button>
                    <form action="select" method="get">
                        <% 
                        String[] selectedCategories = request.getParameterValues("cardId");
                        Set<String> selected = selectedCategories != null ? new HashSet<>(Arrays.asList(selectedCategories)) : new HashSet<>();
                        %>
                        <% for(int i = 1; i <= 12; i++) { %>
                        <div class="form-check">
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
                    </form>
                    <button class="btn btn-primary mt-2"><a href="index.jsp" style="color: white; text-decoration: none">Back to home</a></button>
                </div>
                <!-- Products Column -->
                <div class="col-lg-10 col-md-9 col-sm-12">
                    <div class="row" id="products-container">
                        <% 
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
                        <div class="col-4 col-xl-2-4 mb-4">
                            <div class="card h-100">
                                <img src="<%= product.getImageURL() %>" class="card-img-top" alt="<%= product.getProductName() %>">
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title"><%= product.getProductName() %></h5>
                                    <p class="card-text">Price: <%= product.getPrice() %> VND</p>
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
