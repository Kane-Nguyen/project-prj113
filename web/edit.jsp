<%-- 
    Document   : edit
    Created on : Oct 21, 2023, 4:54:53 PM
    Author     : tranq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="model.Product"%>
<%@page import="dal.ProductDAO"%>
<%
 if (session == null || session.getAttribute("isLoggedIn") == null || 
 !(Boolean)session.getAttribute("isLoggedIn")||session.getAttribute("role") == null || !session.getAttribute("role").equals("Admin")) {
        
        String originalURL = request.getRequestURI(); // Lấy URL hiện tại
        String queryString = request.getQueryString(); // Lấy query string từ URL (nếu có)
        
        if (queryString != null) {
            originalURL += "?" + queryString;
        }
        
        response.sendRedirect("admin.jsp"); // Redirect to login page with the original URL
        return;
}

%>
<% 
    String id = request.getParameter("id");
    int index = -1;
     if (id == null || id.isEmpty()) {
        response.sendRedirect("admin.jsp?error=missing_id");
        return; // Dừng xử lý tiếp theo
    }
    response.setContentType("text/html;charset=UTF-8");
    ProductDAO p = new ProductDAO();
    List<Product> list = p.getAll();
    for (int i = 0; i < list.size(); i++) {
        if (list.get(i).getProductId().equals(id)) {
            index = i;
            break;
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset='UTF-8'>
        <title>Edit Product</title>
        <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css'>
        <script src='https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js'></script>
        <script src='https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js'></script>
        <script src='https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js'></script>
        <style>
            body {
                font-family: Arial, sans-serif;
            }
            table {
                width: 100%;
                margin-top: 20px;
            }
            td {
                padding: 8px;
            }
            input[type='text'], input[type='number'], textarea {
                width: 100%;
            }
        </style>
    </head>
    <body>
        <h1>Edit Product</h1>
        <div id='editProductForm'>
            <form action='CRUD' method='post'>
                <table class='table table-bordered'>
                    <tr>
                        <td><label for='productName'>Product Name</label></td>
                        <td><input type='text' id='productName' name='productName' value='<%= list.get(index).getProductName() %>'></td>
                    </tr>
                    <tr>
                        <td><label for='description'>Description</label></td>
                        <td><textarea id='description' name='description'><%= list.get(index).getDescription() %></textarea></td>
                    </tr>
                    <tr>
                        <td><label for='price'>Price</label></td>
                        <td><input type='number' id='price' name='price' value='<%= list.get(index).getPrice() %>'></td>
                    </tr>
                    <!-- ... (đoạn mã trên không thay đổi) -->
                    <tr>
                        <td><label for='discountPercentage'>Discount Percentage</label></td>
                        <td><input type='number' id='discountPercentage' name='discountPercentage' value='<%= list.get(index).getDiscountPercentage() %>'></td>
                    </tr>
                    <tr>
                        <td><label for='imageURL'>Image URL</label></td>
                        <td><input type='text' id='imageURL' name='imageURL' value='<%= list.get(index).getImageURL() %>'></td>
                    </tr>
                    <tr>
                        <td><label for='stockQuantity'>Stock Quantity</label></td>
                        <td><input type='number' id='stockQuantity' name='stockQuantity' value='<%= list.get(index).getStockQuantity() %>'></td>
                    </tr>
                    <tr>
                        <td><label for='category'>Category</label></td>
                        <td><input type='text' id='category' name='category' value='<%= list.get(index).getCategory() %>'></td>
                    </tr>
                    <tr>
                        <td><label for='manufacturer'>Manufacturer</label></td>
                        <td><input type='text' id='manufacturer' name='manufacturer' value='<%= list.get(index).getManufacturer() %>'></td>
                    </tr>
                    <!-- ... (đoạn mã dưới không thay đổi) -->

                    <tr>
                        <td><input type='text' id='method' name='method' value='edit' style='display:none'></td>
                        <td><input type='text' id='id1' name='id1' value='<%= list.get(index).getProductId() %>' style='display:none'></td>
                    </tr>
                </table>
                <button type='submit'>Edit</button>
            </form>
            <form action='admin.jsp'>
                <button type='submit'>Back</button>
            </form>
        </div>
    </body>
</html>
