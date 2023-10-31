<%-- Document : edit Created on : Oct 21, 2023, 4:54:53 PM Author : tranq --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@page import="java.util.List" %> 

<%@page import="model.Product"%> 
<%@page import="model.CategoryBook"%> 
<%@page import="dal.ProductDAO"%> 
<%@page import="dal.CategoryDAO"%> 
<%
    // Check if the user is logged in and an admin
    if (session == null || session.getAttribute("isLoggedIn") == null ||
        !(Boolean) session.getAttribute("isLoggedIn") ||
        session.getAttribute("role") == null || 
        !session.getAttribute("role").equals("Admin")) {

        // Redirect to login page if not
        String originalURL = request.getRequestURI();
        String queryString = request.getQueryString();
        if (queryString != null) {
            originalURL += "?" + queryString;
        }
        response.sendRedirect("admin.jsp");
        return;
    }

    String id = request.getParameter("id");
    int index = -1;

    // Check if product ID exists
    if (id == null || id.isEmpty()) {
        response.sendRedirect("admin.jsp?error=missing_id");
        return;
    }
    
    // Look for the product in the database
    ProductDAO p = new ProductDAO();
    List<Product> list = p.getAll();
    
    for (int i = 0; i < list.size(); i++) {
        if(list.get(i).getProductId().equals(id)) {
            index = i;
            break;
        }
    }

    // If product not found, redirect
    if (index == -1) {
        response.sendRedirect("admin.jsp?error=product_not_found");
        return;
    }
%>
<% CategoryDAO categoryDAO = new CategoryDAO(); 
   List<CategoryBook> allCategories = categoryDAO.getAll(); 
   String currentCategoryName = categoryDAO.getCategoryByProductId(list.get(index).getCategoryId()); 
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>Edit Product</title>
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
        <h1>Edit Product</h1>
        <div id="editProductForm">
            <form action="CRUD" method="post">
                <table class="table table-bordered">
                    <tr>
                        <td><label for="productName">Product Name</label></td>
                        <td>
                            <input
                                type="text"
                                id="productName"
                                name="productName"
                                value="<%= list.get(index).getProductName() %>" />
                        </td>
                    </tr>
                    <tr>
                        <td><label for="description">Description</label></td>
                        <td>
                            <textarea id="description" name="description">
                                <%= list.get(index).getDescription() %></textarea
                            >
                        </td>
                    </tr>
                    <tr>
                        <td><label for="price">Price</label></td>
                        <td>
                            <input
                                type="number"
                                id="price"
                                name="price"
                               value="<%= (int)Math.floor(list.get(index).getPrice()) %>" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label for="discountPercentage">Discount Percentage</label>
                        </td>
                        <td>
                            <input
                                type="number"
                                id="discountPercentage"
                                name="discountPercentage"
                                value="<%= list.get(index).getDiscountPercentage() %>" />
                        </td>
                    </tr>
                    <tr>
                        <td><label for="imageURL">Image URL</label></td>
                        <td>
                            <input
                                type="text"
                                id="imageURL"
                                name="imageURL"
                                value="<%= list.get(index).getImageURL() %>" />
                        </td>
                    </tr>
                    <tr>
                        <td><label for="stockQuantity">Stock Quantity</label></td>
                        <td>
                            <input
                                type="number"
                                id="stockQuantity"
                                name="stockQuantity"
                                value="<%= list.get(index).getStockQuantity() %>" />
                        </td>
                    </tr>
                    <tr>
                        <td><label for="category">Category</label></td>
                        <td>
                            <select id="category" name="category">
                                <% for (CategoryBook category : allCategories) { 
                                   String selected = category.getCategoryName().equals(currentCategoryName) ? "selected" : "";
                                %>
                                <option value="<%= category.getCategoryID() %>" <%= selected %>><%= category.getCategoryName() %></option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    
                    <tr>
                        <td><label for="manufacturer">Manufacturer</label></td>
                        <td>
                            <input
                                type="text"
                                id="Author"
                                name="Author"
                                value="<%= list.get(index).getAuthor() %>" />
                        </td>
                    </tr>
                   

                    <tr>
                        <td>
                            <input
                                type="text"
                                id="method"
                                name="method"
                                value="edit"
                                style="display: none" />
                        </td>
                        <td>
                            <input
                                type="text"
                                id="id1"
                                name="id1"
                                value="<%= list.get(index).getProductId() %>"
                                style="display: none" />
                        </td>
                    </tr>
                </table>
                <button type="submit">Edit</button>
            </form>
            <form action="admin.jsp">
                <button type="submit">Back</button>
            </form>
        </div>
    </body>

</html>
</Product>
