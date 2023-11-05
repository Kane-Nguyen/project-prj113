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
    <link
      rel="stylesheet"
      href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
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
    <h1>Add Product</h1>
    <div id="addProductForm">
      <form action="CRUD" method="post">
        <table class="table table-bordered">
          <tr>
            <td><label for="productName">Product Name</label></td>
            <td>
              <input type="text" id="productName" name="productName" required />
            </td>
          </tr>
          <tr>
            <td><label for="description">Description</label></td>
            <td>
              <textarea id="description" name="description" required></textarea>
            </td>
          </tr>
          <tr>
            <td><label for="price">Price</label></td>
            <td>
              <input
                type="number"
                id="price"
                name="price"
                step="0.01"
                required />
            </td>
          </tr>
          <tr>
            <td><label for="discountPercentage">Discount Percentage</label></td>
            <td>
              <input
                type="number"
                id="discountPercentage"
                name="discountPercentage"
                step="0.01"
                required />
            </td>
          </tr>
          <tr>
            <td><label for="imageURL">Image URL</label></td>
            <td>
              <input type="text" id="imageURL" name="imageURL" required />
            </td>
          </tr>
          <tr>
            <td><label for="stockQuantity">Stock Quantity</label></td>
            <td>
              <input
                type="number"
                id="stockQuantity"
                name="stockQuantity"
                required />
            </td>
          </tr>
          <tr>
                        <td><label for="category">Category</label></td>
                        <td>
                            <select id="category" name="category">
                                <% for (CategoryBook category : allCategories) { 
                                %>
                                <option value="<%= category.getCategoryID() %>"><%= category.getCategoryName() %></option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
          <tr>
            <td><label for="Author">Author</label></td>
            <td><input type="text" id="Author" name="Author" required /></td>
          </tr>
          <input
            type="text"
            id="method"
            name="method"
            value="add"
            style="display: none" />
        </table>
        <button type="submit">Add Product</button>
      </form>
      <br />
      <form action="admin.jsp">
        <button type="submit">Back</button>
      </form>
    </div>
  </body>
</html>
