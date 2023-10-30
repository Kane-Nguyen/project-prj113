<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dal.ProductDAO"%>
<%@page import="model.Product"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Buy Page</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
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
                    String errorMessage = request.getParameter("errorMessage");
                    String iderorr= request.getParameter("productId");
                    double totalPrice = 0;
                    int a=0;
                    if(errorMessage != null && !errorMessage.isEmpty()){
                %>
                <div class="alert alert-danger">
                    <p>Insufficient quantity of <%=productDAO.getProductNameById(iderorr)%></p>
                </div> <%
                    }else if( productIds == null || productIds.length == 0 ){
                %>
                <h3>You don't have any Product in cart</h3>

                <a href="index.jsp" class="btn"></a>

               
                <%
                }


                
            else{
                %>
                <a href="index.jsp" class="btn-primary">Home</a>
                <%
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
                    <input type="number" name="quantity" id="quantity_<%=a%>" value="<%= quantity %>" onchange="updateQuantityAndTotal('<%=a%>', <%= discountedPrice %>);largeThan0('<%=a%>',<%= discountedPrice %>)">
                    <span id="stock_error_<%=a%>" style="color: red"></span>
                    <input type="hidden" id="stock_<%=a%>" value="<%= product.getStockQuantity() %>">
                    <p>Item Total: <span id="itemTotal_<%=a%>">  <%= String.format("%.3f", itemTotal) %>VNĐ</span></p> 

                </li>
                <%
                    System.out.println("a "+a);
                    a++;
                      System.out.println("Important "+  "quantity"+itemId );
                        } else {
                %>
                <li>Product ID <%= itemId %> not found</li>

                <%
                        
                        }
                    }
                %>
            </ul>
            <h2>Overall Total Price: <span id="totalPrice"><%= String.format("%.3f", totalPrice) %></span>VNĐ</h2>


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
            <input type="hidden" id="total2" name="totalPrice" value="<%= totalPrice %>">



            <input type="hidden" name="productIds" value="<%= String.join(",", productIds) %>">   
            <input type="hidden" name="userID" value="<%= id %>">
            <input type="submit" value="Place Order" onchange="return  validateForm()">
            <input type="hidden" name="methodbuy" value="<%=methodbuy%>">
        </form>

        <script>
        function updateQuantityAndTotal(a, unitPrice) {
                // Get the quantity for the current product
                var stock = parseInt(document.getElementById('stock_' + a).value);
                var quantity = parseInt(document.getElementById('quantity_' + a).value);

                console.log("quantity " + quantity);
                console.log("stock: " + stock);
                // Check if the requested quantity is more than available stock
                if (quantity > stock) {
                    document.getElementById('quantity_' + a).value = stock;

                    document.getElementById('stock_error_' + a).innerText = "Cannot purchase more than the available stock!";
                    updateQuantityAndTotal(a, unitPrice);
                    return;
                } else {
                    document.getElementById('stock_error_' + a).innerText = "";
                }

                // Update item total for the current product
                var itemTotal = unitPrice * quantity;
                document.getElementById('itemTotal_' + a).innerText = itemTotal.toFixed(3) + "VNĐ";

                // Calculate and update the overall total price
                var productIds = '<%= String.join(",", productIds) %>'.split(',');
                var totalPrice = 0;
                for (var i = 0; i < productIds.length; i++) {
                    var itemTotalText = document.getElementById('itemTotal_' + i).innerText;
                    var itemTotal = parseFloat(itemTotalText.replace('VNĐ', ''));
                    totalPrice += itemTotal;
                }
                document.getElementById('totalPrice').innerText = totalPrice.toFixed(3);
                document.getElementById('total2').value = totalPrice.toFixed(3);
            }
            function validateForm() {
                var productIds = '<%= String.join(",", productIds) %>'.split(',');
                for (var i = 0; i < productIds.length; i++) {
                    var stock = parseInt(document.getElementById('stock_' + i).value);
                    var quantity = parseInt(document.getElementById('quantity_' + i).value);

                    if (quantity > stock) {
                        alert("Cannot place order! Product " + (i + 1) + " has insufficient stock.");
                        return false;
                    }
                }
                return true;
            }
            function largeThan0(a, unitPrice) {
                var quantity = parseInt(document.getElementById('quantity_' + a).value);
                if (quantity <= 0) {
                    alert("Please enter Quantity more than 0 ");
                    document.getElementById('quantity_' + a).value = 1;
                    document.getElementById('itemTotal_' + a).innerText = unitPrice.toFixed(3) + "VNĐ";
                }
            }

        </script>
        <%}%>   
    </body>
</html>
