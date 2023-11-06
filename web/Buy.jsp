<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@page
import="java.util.ArrayList"%> <%@page import="dal.ProductDAO"%> <%@page
import="model.Product"%>

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Buy Page</title>
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" />
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="./css/buy.css" />
  </head>
  <body>
    <div class="container wraper-outside">
      <form action="ProcessOrderServlet" method="post">
        <h1 class="big-title">Order Summary</h1>
        <a href="index.jsp" class="btn-primary mr-3 btn">Home</a>
        <a href="cart.jsp" class="btn btn-primary"> Cart</a>
        <div class="wraper">
          <div class="left-content">
            <ul class="product-list">
              <% ProductDAO productDAO = new ProductDAO(); String[] productIds =
              request.getParameterValues("productId"); String[] productNames =
              request.getParameterValues("productName"); String[] quantities =
              request.getParameterValues("quantity"); String[] originalPrices =
              request.getParameterValues("originalPrice"); String[]
              discountedPrices = request.getParameterValues("discountedPrice");
              String methodbuy = request.getParameter("methodbuy"); String
              errorMessage = request.getParameter("errorMessage"); String
              iderorr= request.getParameter("productId"); double totalPrice = 0;
              int a=0; if(errorMessage != null && !errorMessage.isEmpty()){ %>
              <div class="alert alert-danger">
                <p>
                  Insufficient quantity of
                  <%=productDAO.getProductNameById(iderorr)%>
                </p>
              </div>
              <% }else if( productIds == null || productIds.length == 0 ){ %>
              <h3>You don't have any Product in cart</h3>

              <a href="index.jsp" class="btn"></a>

              <% } else{ %> <% for (int i = 0; i < productIds.length; i++) {
              String itemId = productIds[i]; Product product =
              productDAO.getProductById(itemId); String quantityStr = i <
              quantities.length ? quantities[i] : "N/A"; int quantity = 1; //
              Giá trị mặc định nếu không có dữ liệu quantity if (quantityStr !=
              null && !quantityStr.isEmpty()) { quantity =
              Integer.parseInt(quantityStr); } if (product != null) { double
              unitPrice = product.getPrice(); double discount =
              product.getDiscountPercentage(); double discountedPrice =
              unitPrice * (1 - discount / 100); double itemTotal =
              discountedPrice * quantity; totalPrice += itemTotal;
              System.out.println(quantity); System.out.println("quantity
              "+quantity+" "+ itemId); %>

              <li class="product-item">
                <img
                  src="<%= product.getImageURL() %>"
                  width="130"
                  height="200" />
                <div class="wrap-content-left">
                  <p class="title"><%= product.getProductName() %></p>
                  <div class="wrap-content-right">
                    <input
                      type="number"
                      name="quantity"
                      id="quantity_<%=a%>"
                      value="<%= quantity %>"
                      onchange="updateQuantityAndTotal('<%=a%>', <%= discountedPrice %>);largeThan0('<%=a%>',<%= discountedPrice %>)" />

                    <input
                      type="hidden"
                      id="stock_<%=a%>"
                      value="<%= product.getStockQuantity() %>" />
                    <span id="itemTotal_<%=a%>">
                      <%= String.format("%.3f", itemTotal) %>VNĐ</span
                    >
                  </div>
                </div>
              </li>
              <span id="stock_error_<%=a%>" style="color: #000"></span>
              <% a++; } else { %>
              <li>Product ID <%= itemId %> not found</li>

              <% } } %>
            </ul>
            <h4 class="total-price">
              Totol price :
              <span id="totalPrice"
                ><%= String.format("%.3f", totalPrice) %></span
              >VNĐ
            </h4>
          </div>

          <div class="right-content">
            <% int id = -1; Object sessionId = session.getAttribute("userID");
            if (sessionId != null) { try { id =
            Integer.parseInt(sessionId.toString()); } catch
            (NumberFormatException e) { System.out.println("ID is not a
            number"); } } else { System.out.println("ID is null"); } %>

            <h2 class="title-buy">Enter Order Information</h2>
            <div class="wrap-field-content">
              <label for="deliveryAddress">Delivery Address:</label>
              <input
                type="text"
                id="deliveryAddress"
                name="deliveryAddress"
                required /><br />

              <label for="phoneNumber">Phone Number:</label>
              <input
                type="text"
                id="phoneNumber"
                name="phoneNumber"
                required /><br />

              <label for="recipientName">Recipient Name:</label>
              <input
                type="text"
                id="recipientName"
                name="recipientName"
                required /><br />

              <label for="paymentMethod">Payment Method:</label>
              <input
                type="text"
                id="paymentMethod"
                name="paymentMethod"
                value="COD"
                disabled /><br />
              <input
                type="hidden"
                id="paymentMethod"
                name="paymentMethod"
                value="COD" /><br />
              <input
                type="hidden"
                id="total2"
                name="totalPrice"
                value="<%= totalPrice %>" />

              <input type="hidden" name="productIds" value="<%= String.join(",",
              productIds) %>">
              <input type="hidden" name="userID" value="<%= id %>" />
              <input
                class="submit-form"
                type="submit"
                value="Place Order"
                onchange="return  validateForm()" />
              <input type="hidden" name="methodbuy" value="<%=methodbuy%>" />
            </div>
          </div>
        </div>
      </form>
    </div>
    <script>
      function updateQuantityAndTotal(a, unitPrice) {
        var stock = parseInt($("#stock_" + a).val());
        var quantity = parseInt($("#quantity_" + a).val());

        if (quantity > stock) {
          $("#stock_error_" + a).text(
            "Cannot purchase more than the available stock!"
          );
          return;
        }

        var itemTotal = unitPrice * quantity;
        $("#itemTotal_" + a).text(itemTotal.toFixed(3) + "VNĐ");

        var productIds = '<%= String.join(",", productIds) %>'.split(",");
        var totalPrice = 0;

        for (var i = 0; i < productIds.length; i++) {
          var itemTotalText = $("#itemTotal_" + i).text();
          var itemTotal = parseFloat(itemTotalText.replace("VNĐ", ""));
          totalPrice += itemTotal;
        }

        $("#totalPrice").text(totalPrice.toFixed(3));
        $("#total2").val(totalPrice.toFixed(3));
        if (quantity <= stock) {
          $("#stock_error_" + a).text("");
        }
      }

      function validateForm() {
        var productIds = '<%= String.join(",", productIds) %>'.split(",");

        for (var i = 0; i < productIds.length; i++) {
          var stock = parseInt($("#stock_" + i).val());
          var quantity = parseInt($("#quantity_" + i).val());

          if (quantity > stock) {
            alert(
              "Cannot place order! Product " +
                (i + 1) +
                " has insufficient stock."
            );
            return false;
          }
        }
        return true;
      }

      function largeThan0(a, unitPrice) {
        var quantity = parseInt($("#quantity_" + a).val());

        if (quantity <= 0) {
          alert("Please enter Quantity more than 0");
          $("#quantity_" + a).val(1);
          $("#itemTotal_" + a).text(unitPrice.toFixed(3) + "VNĐ");
        }
      }
    </script>
    <%}%>
  </body>
</html>
