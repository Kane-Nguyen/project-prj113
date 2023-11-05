<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dal.ProductDAO"%>
<%@page import="model.Product"%>
<!DOCTYPE html>
<html>
    <head>
        <style>
            .cart-container {
                font-family: Arial, sans-serif;
                margin: 40px;
            }
            .cart-header {
                text-align: center;
                font-weight: 400;
                font-size: 2rem;
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
                display: flex;
                flex-direction: column;
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
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
    

        <meta charset="UTF-8">
        <title>Shopping Cart</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script>
            function updateQuantity(productId, action, discountedPrice) {
                console.log(action);
                console.log(`Update Quantity called for Product ID: ${productId}, Action: ${action}`);
                var stock = parseInt($('#Stock-' + productId).val());
                var quantity = parseInt($('#quantity-' + productId).text());

                if (quantity >= stock && action === "increase") {
                    alert("khong du sach");
                    console.log("khong du sach");
                    return;
                }

                $.post("UpdateQuantityServlet", {
                    productId: productId,
                    action: action,
                    stock: stock
                }, function (newQuantity) {
                    $('#quantity-' + productId).text(newQuantity);
                    var total = newQuantity * discountedPrice;

                    $('#totalItem_' + productId).val("Total Price: " + total.toFixed(3) + " VND");
                    let grandTotal = 0;

                    $("[id^='totalItem_']").each(function () {
                        const value = $(this).val();
                        const amount = parseFloat(value.replace("Total Price: ", "").replace(" VND", ""));

                        if (!isNaN(amount)) {
                            grandTotal += amount;
                        }
                    });
                    $("#total-price").text("Total Price: " + grandTotal.toFixed(3) + " VND");

                }).fail(function (err) {
                    console.error("XHR error:", err);
                });





            }

//                function updateTotalPrice() {
//else                    var cartItems = getCookie("cart").split(":");
//                    var quantities = getCookie("quantity").split(":");
//                    var totalPrice = 0;
//
//                    if (cartItems[0] === "") {
//                        $("#total-price").text("Total Price: $0.000");
//                        return;
//                    }
//
//                    for (var i = 0; i < cartItems.length; i++) {
//                        var productId = cartItems[i];
//                        var quantity = parseInt(quantities[i]);
//                        var unitPrice = parseFloat($('#unit-price-' + productId).text().replace('$', ''));
//                        totalPrice += (unitPrice * quantity);
//                    }
//
//                    $("#total-price").text(`Total Price: ${totalPrice.toFixed(3)}VNĐ`);
//                }

            function removeProduct(productId) {
                $.post("DeleteCartServlet", {
                    productId: productId
                }, function () {
                    $('#quantity-' + productId).parent().remove();
                    updateTotalPrice();
                });
            }

            function setInitialQuantities() {
                var cartItems = getCookie("cart").split(":");
                var quantities = getCookie("quantity").split(":");

                for (var i = 0; i < cartItems.length; i++) {
                    var productId = cartItems[i];
                    var quantity = quantities[i];
                    $("#quantity-" + productId).text(quantity);
                }
                updateTotalPrice();
            }

            function getCookie(cname) {
                var name = cname + "=";
                var decodedCookie = decodeURIComponent(document.cookie);
                var ca = decodedCookie.split(';');

                for (var i = 0; i < ca.length; i++) {
                    var c = ca[i].trim();
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
                setCookie("cart", "", -1);
                setCookie("quantity", "", -1);
            }

            setInitialQuantities(); // Call the function initially to set quantities
            ;


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
                <li class="list-group-item flex-item" style="text-align: center; color: red">Cart is empty</li>
                    <% 
                        } else {
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
                                    totalPrice += discountedPrice * Integer.parseInt(quantity);
                    %>
                <li class="list-group-item cart-item">
                    <div class="d-flex justify-content-between align-items-center">
                        <!-- Image and Product Details -->
                        <div class="d-flex align-items-center">
                            <!-- Image -->
                            <div class="cart-image-container mr-3">
                                <img src="<%= product.getImageURL() %> " class="img-fluid cart-thumbnail" width="70">
                            </div>
                            <!-- Product Details -->
                            <div class="product-details">
                                <span><%= product.getProductName() %></span>
                                <!-- Original Price can be uncommented if needed, styled as muted text -->
                                <!-- <strong class="text-muted">Original Price:</strong>
                                <span class="text-muted" id="original-price-<%= itemId %>"><%= unitPrice %> VND</span> -->
                                <span id="unit-price-<%= itemId %>" class="price"><%= discountedPrice %> VND</span>
                            </div>

                        </div>

                        <!-- Quantity Control and Remove Product Button -->
                        <div class="d-flex align-items-center">
                            <!-- Quantity Control -->
                            <div class="quantity-control mr-3">
                                <!--<span class="mr-2">Quantity:</span>-->
                                <button type="button" class="btn btn-light btn-sm mr-1" onclick="updateQuantity('<%= itemId %>', 'decrease')">
                                   <i class="bi bi-dash"></i>
                                </button>
                                <span id="quantity-<%= itemId %>" class="mr-1"><%= quantity %></span>
                                <button type="button" class="btn btn-light btn-sm mr-3" onclick="updateQuantity('<%= itemId %>', 'increase')">
                                  <i class="bi bi-plus"></i>
                                </button>
                            </div>
                            <!-- Remove Product Button -->
                            <button type="button" class="btn btn-danger btn-sm" onclick="removeProduct('<%= itemId %>')">
                                <i class="bi bi-trash"></i> Remove
                            </button>
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
            <h2  class="cart-total" id="total-price">Total Price: <%= totalPrice %> </h2>

            <a href="index.jsp" class="btn btn-primary mt-3">Back to Product List</a>
            <form action="Buy.jsp" method="post" onsubmit="clearCartCookies()" class="mt-3">
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
                <input type="submit" value="BuyNow" class="btn  btn-primary">
            </form>
        </div>
    </body>
</html>