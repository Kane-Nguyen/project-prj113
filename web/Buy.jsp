<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dal.ProductDAO"%>
<%@page import="model.Product"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Buy Page</title>
   
</head>
<body>
    <h1>Order Summary</h1>
    <form action="ProcessOrderServlet" method="post">
        <ul>
            <%
                ProductDAO productDAO = new ProductDAO();
                String[] productIds = request.getParameterValues("productId");
                double totalPrice = 0;

                for (int i = 0; i < productIds.length; i++) {
                    String itemId = productIds[i];
                    Product product = productDAO.getProductById(itemId);
                    String quantityStr = i < productIds.length ? request.getParameter("quantity" + itemId) : "N/A";
                    int quantity = 1; // Default value if no quantity data
                    if (quantityStr != null && !quantityStr.isEmpty()) {
                        quantity = Integer.parseInt(quantityStr);
                    }

                    if (product != null) {
                        double unitPrice = product.getPrice();
                        double discount = product.getDiscountPercentage();
                        double discountedPrice = unitPrice * (1 - discount / 100);
                        double itemTotal = discountedPrice * quantity;
                        totalPrice += itemTotal;
            %>
            <li>
                <img src="<%= product.getImageURL() %>" width="50" height="50">
                <p><%= product.getProductName() %></p>
                Original Price: <%= unitPrice %>VNĐ
                <br>
                Discounted Price: <%= discountedPrice %>VNĐ
                <br>
                Quantity:
                <input type="number" id="quantity<%= itemId %>" name="quantity<%= itemId %>" value="<%= quantity %>" min="1" onchange="updateQuantityAndTotal('<%= itemId %>', <%= discountedPrice %>)">
                <br>
                Item Total: <span id="itemTotal<%= itemId %>"><%= itemTotal %></span>VNĐ
            </li>
            <%
                    } else {
            %>
            <li>Product ID <%= itemId %> not found</li>
            <%
                    }
                }
            %>
        </ul>
        <h2>Total Price: <span id="totalPrice"><%= totalPrice %></span>VNĐ</h2>

        <a href="cart.jsp">Cart</a>

        <!-- your existing code for user ID and other fields -->
        <input type="hidden" name="productIds" value="<%= String.join(",", productIds) %>">
        <input type="submit" value="Place Order">
    </form>
         <script>
        function updateQuantityAndTotal(productId, unitPrice) {
            var quantity = document.getElementById('quantity' + productId).value;
            var itemTotal = unitPrice * quantity;
            document.getElementById('itemTotal' + productId).innerText = itemTotal + 'VNĐ';

            // Cập nhật totalPrice
            var productIds = '<%= String.join(",", productIds) %>'.split(',');
            var totalPrice = 0;
            for (var i = 0; i < productIds.length; i++) {
                var itemId = productIds[i];
                var itemTotal = parseFloat(document.getElementById('itemTotal' + itemId).innerText);
                totalPrice += itemTotal;
            }
            document.getElementById('totalPrice').innerText = totalPrice + 'VNĐ';
        }
    </script>
</body>
</html>
