<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dal.ProductDAO"%>
<%@page import="model.Product"%>
<%@page import="java.text.NumberFormat" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Shopping Cart</title>
        <style>
            .cart-container {
                font-family: Arial, sans-serif;
                margin: 40px;
            }
            .cart-header {
                text-align: center;
                font-weight: 400;
                font-size: 3rem;
                color: #2c3e50;
                margin-top: 0.5em;
                margin-bottom: 0.5em;
            }

            .cart-item {
                border: 1px solid #ccc;
                margin: 10px 0;
                padding: 10px;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .cart-thumbnail {
                max-width: 50px;
                height: auto;
                margin-right: 15px;
            }

            .cart-button {
                padding: 5px 10px;
                margin-left: 10px;
            }

            .cart-total {
                font-size: 24px;
                font-weight: bold;
                margin-top: 20px;
            }

            .cart-image-container {
                width: 150px;
                height: 200px;
                overflow: hidden;
            }

            .cart-image-container img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
            .product-details {
                font-family: 'Helvetica Neue', Arial, sans-serif;
                line-height: 1.5;
                color: #333;
            }

            .product-details strong {
                display: block;
                color: #555;
                margin-bottom: 0.25em
            }

            .product-details .price {
                font-size: 1.2em;
                font-weight: bold;
                color: #e74c3c;
                margin-bottom: 0.5em;
            }

        </style>

        <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

        <script>
            function updateQuantity(productId, action) {
                console.log("Update Quantity called for Product ID: " + productId + ", Action: " + action);
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "UpdateQuantityServlet", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                var stock = parseInt(document.getElementById('Stock-' + productId).value);
                xhr.send("productId=" + productId + "&action=" + action + "&stock=" + stock);

                xhr.onload = function () {
                    console.log('XHR status:', xhr.status);
                    if (xhr.status == 200) {
                        var newQuantity = xhr.responseText;
                        console.log("Server returned quantity:", newQuantity);

                        var stock = parseInt(document.getElementById('Stock-' + productId).value);
                        if (newQuantity > stock && action === "increase") {
                            alert("khong du sach");
                            return;
                        } else {
                            document.getElementById("quantity-" + productId).innerText = newQuantity;
                            updateTotalPrice();
                        }
                    } else {
                        console.error('Error from server:', xhr.responseText);  // Debug line
                    }
                };

                xhr.onerror = function (e) {
                    console.error("XHR error:", e);  // Debug line
                };
            }

            function updateTotalPrice() {
                var cartItems = getCookie("cart").split(":");
                var quantities = getCookie("quantity").split(":");
                var totalPrice = 0;

                if (cartItems[0] === "") {
                    document.getElementById("total-price").innerText = "Total Price: $0";
                    return;
                }

                for (var i = 0; i < cartItems.length; i++) {
                    var productId = cartItems[i];
                    var quantity = parseInt(quantities[i]);
                    var unitPriceElement = document.getElementById("unit-price-" + productId);

                    if (unitPriceElement) {
                        var unitPrice = parseFloat(unitPriceElement.innerText.replace('$', ''));
                        totalPrice += (unitPrice * quantity)*1000;
                    }
                }

                // Format the total price with commas and no decimal places
                var formattedTotalPrice = totalPrice.toLocaleString('en-US', {maximumFractionDigits: 0});

                document.getElementById("total-price").innerText = "Total Price: " + formattedTotalPrice + " VNĐ";
            }


            function removeProduct(productId) {
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "DeleteCartServlet", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.send("productId=" + productId);
                xhr.onload = function () {
                    if (xhr.status == 200) {
                        // Hide the entire list item by changing its display style to 'none'
                        var listItem = document.getElementById('product-item-' + productId);
                        if (listItem) {
                            listItem.style.display = 'none';
                        }

                        // Recalculate total price immediately after removing an item
                        updateTotalPrice();
                    }
                };
            }


            function setInitialQuantities() {
                // Code để đặt số lượng ban đầu từ cookie
                var cartItems = getCookie("cart").split(":");
                var quantities = getCookie("quantity").split(":");
                for (var i = 0; i < cartItems.length; i++) {
                    var productId = cartItems[i];
                    var quantity = quantities[i];
                    var quantityElement = document.getElementById("quantity-" + productId);
                    if (quantityElement) {
                        quantityElement.innerText = quantity;
                    }
                }
                updateTotalPrice();  // Gọi hàm cập nhật tổng giá
            }

            function getCookie(cname) {
                var name = cname + "=";
                var decodedCookie = decodeURIComponent(document.cookie);
                var ca = decodedCookie.split(';');
                for (var i = 0; i < ca.length; i++) {
                    var c = ca[i];
                    while (c.charAt(0) === ' ') {
                        c = c.substring(1);
                    }
                    if (c.indexOf(name) === 0) {
                        return c.substring(name.length, c.length);
                    }
                }
                return "";
            }

            function setCookie(cname, cvalue, exdays) {
                var d = new Date();
                d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
                var expires = "expires=" + d.toUTCString();
                document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
            }

            function clearCartCookies() {
                setCookie("cart", "", -1);  // Setting -1 days will remove the cookie
                setCookie("quantity", "", -1);
            }

        </script>
    </head>
    <body class="cart-container" onload="setInitialQuantities()">
        <div class="container mt-5">
            <h1 class="cart-header"">Shopping Cart</h1>
            <ul class="list-group">
                <%
                    double totalPrice = 0;  // Declare totalPrice here
                    ProductDAO productDAO = new ProductDAO();
                    Cookie[] cookies = request.getCookies();
                    String cartItems = "";
                    String quantities = "";

                if (cookies != null) {
                    for (Cookie cookie : cookies) {
                        if ("cart".equals(cookie.getName())) {
                            cartItems = cookie.getValue();
                        } else if ("quantity".equals(cookie.getName())) {
                            quantities = cookie.getValue();
                        }
                    }
                }

                    if (cartItems.isEmpty()) {
                %>
                <li>Cart is empty</li>
                    <% 
                        } else {
                            String[] cartItemArray = cartItems.split(":");
                            String[] quantityArray = quantities.split(":");

                        for (int i = 0; i < cartItemArray.length; i++) {
                            String itemId = cartItemArray[i];
                            Product product = productDAO.getProductById(itemId);
                            String quantity = i < quantityArray.length ? quantityArray[i] : "N/A";
                             NumberFormat numberFormat = NumberFormat.getNumberInstance();
                                numberFormat.setMinimumFractionDigits(3);
                                numberFormat.setMaximumFractionDigits(3);
                                if (product != null) {
                                    double unitPrice = product.getPrice();
                                    double discount = product.getDiscountPercentage();
                                    double discountedPrice = unitPrice * (1 - discount / 100);
                                    totalPrice += discountedPrice * Integer.parseInt(quantity);
                    %>
                <li class="list-group-item cart-item" id="product-item-<%= itemId %>">
                    <div class="d-flex justify-content-between align-items-center">
                        <!-- Image and Product Details -->
                        <div class="d-flex align-items-center">
                            <!-- Image -->
                            <div class="cart-image-container mr-3">
                                <img src="<%= product.getImageURL() %>"  class="img-fluid cart-thumbnail" width="70">
                            </div>
                            <div class="product-details">
                                <strong>Product:</strong>
                                <span><%= product.getProductName() %></span>
                                <strong>Price:</strong>
                                <%
                                int totalPriceAsInt = (int) Math.round(discountedPrice);
    NumberFormat formatter = NumberFormat.getIntegerInstance();
    String formatteddiscountedPrice = formatter.format(totalPriceAsInt);%>
                                <span id="unit-price-<%= itemId %>"><%= formatteddiscountedPrice %>VND</span>
                            </div>
                        </div>

                        <div class="d-flex align-items-center">
                            <!-- Quantity Control -->
                            <div class="quantity-control mr-3">
                                <!--<span class="mr-2">Quantity:</span>-->
                                <input type="hidden" id="Stock-<%= itemId %>" value="<%= productDAO.getStockQuantity(itemId)%>">
                                <button type="button" class="btn btn-light btn-sm mr-3" onclick="updateQuantity('<%= itemId %>', 'increase')"><i class="fas fa-plus"></i></button>
                                <span id="quantity-<%= itemId %>"><%= quantity %></span>
                                <button type="button" class="btn btn-light btn-sm mr-1" onclick="updateQuantity('<%= itemId %>', 'decrease')"><i class="fas fa-minus"></i></button>
                            </div>
                            <button type="button" class="btn btn-danger btn-sm" onclick="removeProduct('<%= itemId %>')"><i class="fas fa-trash-alt"></i> Remove</button>
                        </div>
                    </div>


                </li>
                <% 
                            } else {
                %>
                <li>Product ID <%= itemId %> not found</li>
                    <%
                                }
                            }
                        }
                    %>
            </ul>
            <%
   
    int totalPriceAsInt = (int) Math.round(totalPrice);
    NumberFormat formatter = NumberFormat.getIntegerInstance();
    String formattedPrice = formatter.format(totalPriceAsInt);
            %>
            <h2 id="total-price">Total Price: <%= formattedPrice %> </h2>


            <form action="Buy.jsp" method="post" onsubmit="clearCartCookies()">
                <% 
                if (!cartItems.isEmpty()) {
                    String[] cartItemArray = cartItems.split(":");
                    String[] quantityArray = quantities.split(":");

                for (int i = 0; i < cartItemArray.length; i++) {
                    String itemId = cartItemArray[i];
                    Product product = productDAO.getProductById(itemId);
                    String quantity = i < quantityArray.length ? quantityArray[i] : "N/A";

                        if (product != null) {
                            double unitPrice = product.getPrice();
                            double discount = product.getDiscountPercentage();
                            double discountedPrice = unitPrice * (1 - discount / 100);
                %>
                <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                <input type="hidden" name="productName" value="<%= product.getProductName() %>">
                <input type="hidden" name="quantity" value="<%= quantity %>"> 
                <input type="hidden" name="originalPrice" value="<%= unitPrice %>">
                <input type="hidden" name="discountedPrice" value="<%= discountedPrice %>">
                <input type="hidden" name="methodbuy" value="cart">
                <% 
                        }
                    }
                } 
                %>
                <input type="submit" class="btn  btn-primary  mt-3" value="BuyNow">
                <a href="index.jsp" class="btn  btn-primary  mt-3">Back to Product List</a>
            </form>
        </div>
    </body>
</html>
