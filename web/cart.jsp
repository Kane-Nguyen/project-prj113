<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dal.ProductDAO"%>
<%@page import="model.Product"%>
<!DOCTYPE html>
<html>
    <head>
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
                <span id="unit-price-<%= itemId %>"><%= String.format("%.3f", discountedPrice) %>VNĐ</span>
                - Quantity: <span id="quantity-<%= itemId %>"><%= quantity %></span>
                <% 
 double quant = Double.parseDouble(quantity); // Hoặc Integer.parseInt(quantity) nếu bạn chắc chắn nó là một số nguyên
                %>
                <input type="hidden" id="totalItem_<%= itemId %>" name="name" value="<%= quant * discountedPrice %>">
                <input type="hidden" id="Stock-<%= itemId %>" value="<%= productDAO.getStockQuantity(itemId)%>">
                <button type="button" onclick="updateQuantity('<%= itemId %>', 'increase',<%= discountedPrice %>)">+</button>
                <button type="button" onclick="updateQuantity('<%= itemId %>', 'decrease',<%= discountedPrice %>)">-</button>
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
        <h2 id="total-price">Total Price: <%= String.format("%.3f", totalPrice) %> VND</h2>
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
            <input type="hidden" name="methodbuy" value="cart">
            <% 
                    }
                }
            } 
            %>
            <input type="submit" value="BuyNow">
        </form>
    </body>
</html>