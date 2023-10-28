<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dal.ProductDAO"%>
<%@page import="model.Product"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Shopping Cart</title>
        <script>
            function updateQuantity(productId, action) {
                console.log("Update Quantity called for Product ID: " + productId + ", Action: " + action);  // Debug line
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "UpdateQuantityServlet", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.send("productId=" + productId + "&action=" + action);
                xhr.onload = function () {
                    if (xhr.status == 200) {
                        var newQuantity = xhr.responseText;
                        document.getElementById("quantity-" + productId).innerText = newQuantity;
                        updateTotalPrice();
                    }
                };
            }
            function updateTotalPrice() {
                var cartItems = getCookie("cart").split(":");
                var quantities = getCookie("quantity").split(":");
                var totalPrice = 0;

                if (cartItems[0] === "") {
                    document.getElementById("total-price").innerText = "Total Price: $0.000";
                    return;
                }

                for (var i = 0; i < cartItems.length; i++) {
                    var productId = cartItems[i];
                    var quantity = parseInt(quantities[i]);
                    var unitPriceElement = document.getElementById("unit-price-" + productId);

                    if (unitPriceElement) {
                        var unitPrice = parseFloat(unitPriceElement.innerText.replace('$', ''));
                        totalPrice += (unitPrice * quantity);
                    }
                }

                document.getElementById("total-price").innerText = "Total Price: " + totalPrice.toFixed(3) + "VNĐ";
            }

            function removeProduct(productId) {
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "DeleteCartServlet", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.send("productId=" + productId);
                xhr.onload = function () {
                    if (xhr.status == 200) {
                        var listItem = document.getElementById("quantity-" + productId).parentNode;
                        listItem.parentNode.removeChild(listItem);

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
    <body onload="setInitialQuantities()">
        <h1>Shopping Cart</h1>
        <ul>
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

                            if (product != null) {
                                double unitPrice = product.getPrice();
                                double discount = product.getDiscountPercentage();
                                double discountedPrice = unitPrice * (1 - discount / 100);
                                totalPrice += discountedPrice * Integer.parseInt(quantity);
                %>
            <li>
                <img src="<%= product.getImageURL() %>" width="50" height="50">
                Original Price: <span id="original-price-<%= itemId %>"><%= unitPrice %>VNĐ</span>
                <span id="unit-price-<%= itemId %>"><%= discountedPrice %>VNĐ</span>
                - Quantity: <span id="quantity-<%= itemId %>"><%= quantity %></span>
                <button type="button" onclick="updateQuantity('<%= itemId %>', 'increase')">+</button>
                <button type="button" onclick="updateQuantity('<%= itemId %>', 'decrease')">-</button>
                <button type="button" onclick="removeProduct('<%= itemId %>')">X</button>
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
        <h2 id="total-price">Total Price: <%= totalPrice %> </h2>
        <a href="index.jsp">Back to Product List</a>
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
            <% 
                    }
                }
            } 
            %>
            <input type="submit" value="BuyNow">
        </form>
    </body>
</html>