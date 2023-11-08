<%-- Document : Addbook Created on : Oct 21, 2023, 4:49:47 PM Author : tranq
--%> <%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@page import="java.util.List" %>
<%@page import="model.Product"%> 
<%@page import="model.CategoryBook"%> 
<%@page import="dal.ProductDAO"%> 
<%@page import="dal.CategoryDAO"%> 
<% if (session == null || session.getAttribute("isLoggedIn") == null ||!(Boolean)session.getAttribute("isLoggedIn")||session.getAttribute("role") ==null || !session.getAttribute("role").equals("Admin")) 
{ String originalURL =request.getRequestURI(); // Lấy URL hiện tại 
String queryString =request.getQueryString(); // Lấy query string từ URL (nếu có) 
if (queryString !=null)
{ originalURL += "?" + queryString; } 
response.sendRedirect("admin.jsp");
}
%>
<% CategoryDAO categoryDAO = new CategoryDAO(); 
   List<CategoryBook> allCategories = categoryDAO.getAll(); 
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>Add Product</title>
        <link rel="stylesheet" href="./css/addbook.css"/>
        <link
            rel="stylesheet"
            href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

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
            input[type="text"],
            input[type="number"],
            textarea {
                width: 100%;
            }
        </style>
    </head>
    <body>
        <div class="wrap-admin-page">
            <div>
                <h2 class="h2">Products Information</h2>
                <div class="product-info-container">
                    <form action="CRUD" method="post">
                        <div class="left-section">
                            <label for="productName">Products Name</label>
                            <input type="text" id="productName" name="productName" required />

                            <label for="description">Description</label>
                            <textarea id="description" name="description" required></textarea>

                            <label for="price">Price</label>
                            <input type="number" id="price" name="price" step="0.01" required />

                            <label for="discountPercentage">Discount Percentage</label>
                            <input type="number" id="discountPercentage" name="discountPercentage" step="0.01" required />
                        </div>

                        <div class="right-section">
                            <label for="imageURL">Image URL</label>
                            <input type="text" id="imageURL" name="imageURL" required />

                            <label for="stockQuantity">Stock Quantity</label>
                            <input type="number" id="stockQuantity" name="stockQuantity" required />
                            <div class="category">
                                <label for="category">Category</label>
                                <select id="category" name="category">
                                    <% for (CategoryBook category : allCategories) { %>
                                    <option value="<%= category.getCategoryID() %>"><%= category.getCategoryName() %></option>
                                    <% } %>
                                </select>
                            </div>
                            <label for="Author">Author</label>
                            <input type="text" id="Author" name="Author" required />
                        </div>
                        <div class="button-section">
                            <a href="admin.jsp">
                                <button type="button">Cancel</button>
                            </a>
                            <button type="submit">Add Products</button>
                        </div>            
                        <input type="hidden" id="method" name="method" value="add"/>
                </div>
            </div>
        </form>
    </div>
</body>
</html>
