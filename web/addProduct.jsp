<%-- 
    Document   : addProduct
    Created on : Oct 8, 2023, 12:27:18 AM
    Author     : tranq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Product</title>
</head>
<body>
    <h1>Add Product</h1>
   <div id="addProductForm">
   <form action="CRUD" method="post">

    <table>     
       
        <tr>
            <td><label for="productName">Product Name</label></td>
            <td><input type="text" id="productName" name="productName" required></td>
        </tr>
        <tr>
            <td><label for="description">Description</label></td>
            <td><textarea id="description" name="description" required></textarea></td>
        </tr>
        <tr>
            <td><label for="price">Price</label></td>
            <td><input type="number" id="price" name="price" step="0.01" required></td>
        </tr>
         <tr>
            <td><label for="discountpercentage">Discount Percentage</label></td>
            <td><input type="number" id="discountpercentage" name="discountpercentage" step="0.01" required></td>
        </tr>
        <tr>
            <td><label for="imageURL">Image URL</label></td>
            <td><input type="text" id="imageURL" name="imageURL" required></td>
        </tr>
        <tr>
            <td><label for="stockQuantity">Stock Quantity</label></td>
            <td><input type="number" id="stockQuantity" name="stockQuantity" required></td>
        </tr>
        <tr>
            <td><label for="category">Category</label></td>
            <td><input type="text" id="category" name="category" required></td>
        </tr>
        <tr>
            <td><label for="manufacturer">Manufacturer</label></td>
            <td><input type="text" id="manufacturer" name="manufacturer" required></td>
        </tr>
      
    </table>

    <button type="submit">Add Product</button>
     
</form>
       <br>
<form action="list.jsp">
    <button type="submit">back</button>
  </form>
</div>

</body>
</html>
