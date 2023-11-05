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
        <style>
            /* Custom styles */
            .card-img-top {
                height: 200px;
                object-fit: contain;
                width: 100%;
            }
        </style>
        <script>
            $(document).ready(function () {
                // Function to handle the checkbox change
                function handleCheckboxChange() {
                    var selectedValues = $('input[name="cardId"]:checked').map(function () {
                        return this.value;
                    }).get();

                    if (selectedValues.length >= 2) { // If 2 or more checkboxes are checked
                        $.ajax({
                            url: 'filterProducts', // URL to the server-side filter function
                            type: 'GET',
                            data: {
                                'selectedCategories': selectedValues // Send the selected values to the server
                            },
                            success: function (response) {
                                // Update the products list
                                $('#products-container').html(response);
                            }
                        });
                    }
                }

                // Attach the change event to checkboxes
                $('input[name="cardId"]').change(handleCheckboxChange);

                // Call the function in case some checkboxes are already checked on page load
                handleCheckboxChange();
            });

        </script>
    </head>
    <body>
        <div class="container-fluid">
            <h1>All Products</h1>
            <div class="row">
                <div class="col-lg-2 col-md-3">
                    <h4>Select your choice</h4>
                    <form action="select" method="get">
                        <% 
                        // Check for previous filter settings from the request parameters
                        String[] selectedCategories = request.getParameterValues("cardId");
                        Set<String> selected = selectedCategories != null ? new HashSet<>(Arrays.asList(selectedCategories)) : new HashSet<>();
                        %>
                        <!-- Show All Checkbox -->
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="cardId" value="all" id="cardIdAll" <%= selected.contains("all") ? "checked" : "" %>>
                            <label class="form-check-label" for="cardIdAll">Show All</label>
                        </div>
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
                                            case 7: out.print("detective"); break;
                                            case 8: out.print("LIGHT NOVEL"); break;
                                            case 9: out.print("Comic"); break;
                                            case 10: out.print("Fantasy"); break;
                                            case 11: out.print("Criminal"); break;
                                            default: out.print("Category " + i); break;
                                } %>
                            </label>
                        </div>
                        <% } %>
                        <button type="submit" class="btn btn-primary mt-2">Filter</button>
                    </form>
                </div>
                <!-- Products Column -->
                <div class="col-lg-10 col-md-9">
                    <div class="row">
                        <%-- Retrieve the list of products from request attribute --%>
                        <% 
                        List<Product> productList = (List<Product>) request.getAttribute("products");
                        if (productList == null || productList.isEmpty()) {
                            out.println("<p>No products found.</p>");
                        } else {
                            for (Product product : productList) {
                        %>
                        <div class="col-xl-3 col-lg-4 col-md-6 col-sm-12 mb-4">
                            <div class="card h-100">
                                <img src="<%= product.getImageURL() %>" class="card-img-top" alt="<%= product.getProductName() %>">
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title"><%= product.getProductName() %></h5>
                                    <p class="card-text flex-fill"><%= product.getDescription() %></p>
                                    <p class="card-text">Price: $<%= product.getPrice() %></p>
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
    </body>
</html>