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


        <form action="ProcessOrderServlet" method="post">
            <h1>Order Summary</h1>


            <ul>
                <%
                    ProductDAO productDAO = new ProductDAO();
                    String[] productIds = request.getParameterValues("productId");
                    String[] productNames = request.getParameterValues("productName");
                    String[] quantities = request.getParameterValues("quantity");
                    String[] originalPrices = request.getParameterValues("originalPrice");
                    String[] discountedPrices = request.getParameterValues("discountedPrice");
                    String methodbuy = request.getParameter("methodbuy");
                    double totalPrice = 0;

                    for (int i = 0; i < productIds.length; i++) {
                        String itemId = productIds[i];
                        
            
                            Product product = productDAO.getProductById(itemId);
                            String quantityStr = i < quantities.length ? quantities[i] : "N/A";
                            int quantity = 1; // Giá trị mặc định nếu không có dữ liệu quantity

                            if (quantityStr != null && !quantityStr.isEmpty()) {
                                quantity = Integer.parseInt(quantityStr);
                            }

                            if (product != null) {
                                double unitPrice = product.getPrice();
                                double discount = product.getDiscountPercentage();
                                double discountedPrice = unitPrice * (1 - discount / 100);
                                double itemTotal = discountedPrice * quantity;
                                totalPrice += itemTotal;
                                System.out.println(quantity);
                                System.out.println("quantity "+quantity+" "+ itemId);
                          
                            

                %>
                <li>
                    <img src="<%= product.getImageURL() %>" width="50" height="50">
                    <p><%= product.getProductName() %></p>
                    Original Price: <%= String.format("%.3f", unitPrice) %>VNĐ
                    <br>
                    Discounted Price: <%= String.format("%.3f", discountedPrice) %>VNĐ
                    <br>
                    Quantity: 
                    <input type="number" name="quantity" value="<%= quantity %>" min="1">
                    <br>
                    Item Total: <%= String.format("%.3f", itemTotal) %>VNĐ
                </li>
                <%
                      System.out.println("Important "+  "quantity"+itemId );
                        } else {
                %>
                <li>Product ID <%= itemId %> not found</li>
                    <%
                            }
                        }
                    %>
            </ul>
            <h2>Total Price: <%= String.format("%.3f",totalPrice) %>VNĐ</h2>

            <a href="cart.jsp">Cart</a>
            <%
          
    int id = -1;
    Object sessionId = session.getAttribute("userID");
    if (sessionId != null) {
        try {
            id = Integer.parseInt(sessionId.toString());
        } catch (NumberFormatException e) {
            System.out.println("ID is not a number");
        }
    } else {
        System.out.println("ID is null");
    }
            %>



            <h2>Enter Order Information</h2>
            <label for="deliveryAddress">Delivery Address:</label>
            <input type="text" id="deliveryAddress" name="deliveryAddress" required><br>

            <label for="phoneNumber">Phone Number:</label>
            <input type="text" id="phoneNumber" name="phoneNumber" required><br>

            <label for="recipientName">Recipient Name:</label>
            <input type="text" id="recipientName" name="recipientName" required><br>

            <label for="paymentMethod">Payment Method:</label>
            <input type="text" id="paymentMethod" name="paymentMethod" value="COD" disabled><br>
            <input type="hidden" id="paymentMethod" name="paymentMethod" value="COD"><br>
            <input type="hidden" name="totalPrice" value="<%= totalPrice %>">

            <input type="hidden" name="productIds" value="<%= String.join(",", productIds) %>">   
            <input type="hidden" name="userID" value="<%= id %>">
            <input type="submit" value="Place Order">
            <input type="hidden" name="methodbuy" value="<%=methodbuy%>">
        </form>
        <script>
            function updateQuantityAndTotal(productId, unitPrice) {
                var quantity = document.getElementById('quantity' + productId).value;
                var itemTotal = unitPrice * quantity;
                document.getElementById('itemTotal' + productId).innerText = itemTotal + 'VNĐ';

                // Update totalPrice
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
