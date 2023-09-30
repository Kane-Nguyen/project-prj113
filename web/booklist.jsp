<%-- 
    Document   : booklist
    Created on : Sep 30, 2023, 11:06:41 PM
    Author     : TU ANH
--%>

            <%@ page import="java.util.List" %>
            <%@ page import="model.Products" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>BOOKSLIST</title>
</head>
<body>
    <h1>BOOKSLIST</h1>
    <table border="1">
        <thead>
            <tr>
                <th>ProductID</th>
                <th>ProductName</th>
                <th>Description</th>
                <th>Price</th>
                <th>ImageURL</th>
                <th>StockQuantity</th>
                <th>Category</th>
                <th>Manufacturer</th>
                <th>DateAdded</th>
                <th>Edit</th>
                <th>Delete</th>
            </tr>
        </thead>
        <tbody>
            <%@ page import="dal.ProductsDAO" %>
            <%@ page import="model.Products" %>

            <%
                ProductsDAO productsDAO = new ProductsDAO();
                List<Products> productList = productsDAO.getAllProducts();
                for (Products product : productList) {
            %>
            <tr>
                <td><%= product.getProductID() %></td>
                <td><%= product.getProductName() %></td>
                <td><%= product.getDescription() %></td>
                <td><%= product.getPrice() %></td>
                <td><img src="<%= product.getImageURL() %>" alt="<%= product.getImageURL() %>"></td>                
                <td><%= product.getStockQuantity() %></td>
                <td><%= product.getCategory() %></td>
                <td><%= product.getManufacturer() %></td>
                <td><%= product.getDateAdded() %></td>
                <td>
                    <button onclick="editProduct('<%= product.getProductID() %>')">Edit</button>
                </td>
                <td>
                    <button onclick="deleteProduct('<%= product.getProductID() %>')">Delete</button>
                </td>
            </tr>
            <%
                }
            %>
            <button id="createBookButton">Create New Book</button>
        </tbody>
    </table>
</body>
</html>

