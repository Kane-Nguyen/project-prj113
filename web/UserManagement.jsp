<%-- 
    Document   : payment
    Created on : Oct 25, 2023, 8:15:34 PM
    Author     : tranq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dal.UsersDAO"%>
<%@page import="model.Users" %>
<%@page import="java.util.List"%>
<%@ page import="java.net.URLEncoder" %>
<%
UsersDAO o = new UsersDAO();
List<Users> lo = o.getAll();
%>

<%
 if (session == null || session.getAttribute("isLoggedIn") == null || 
 !(Boolean)session.getAttribute("isLoggedIn")||session.getAttribute("role") == null || !session.getAttribute("role").equals("Admin")) {
        
        String originalURL = request.getRequestURI(); // Lấy URL hiện tại
        String queryString = request.getQueryString(); // Lấy query string từ URL (nếu có)
        
        if (queryString != null) {
            originalURL += "?" + queryString;
        }
        
        response.sendRedirect("login.jsp?redirect=" + URLEncoder.encode(originalURL, "UTF-8")); // Redirect to login page with the original URL
        return;
}

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Management</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <link rel="stylesheet" href="./css/Usermanagement.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

    </head>
    <body>
        <div class="container wrap-admin-page">
            <div class="toolbar">
                <div class="logo">
                    <img class="logo-img" src="./asset/images/home-images/logo.png" alt="logo"/>
                </div>
                <ul class="list-toolbar">
                    <a href="admin.jsp" class="item-admin "><i class="bi bi-book-half h5"></i><li>Book Management</li></a>
                    <a href="payment.jsp" class="item-admin"><i class="bi bi-wallet2 h5"></i><li>Payment</li></a>
                    <a href="analysis.jsp" class="item-admin"><i class="bi bi-bar-chart-fill h5"></i><li>Dashboard</li></a>
                    <a href="UserManagement.jsp" class="item-admin active"><i class="bi bi-people-fill h5"></i><li>User Management</li></a>
                    <a href="Logout" class="item-admin"><i class="bi bi-box-arrow-left"></i></i><li>Log Out</li></a>
                    <a href="index.jsp" class="item-admin"><i class="bi bi-door-open"></i><li>Back to store</li></a>
                </ul>
            </div>
            <div>
                <h1>User Management</h1>
                <table class="table table-bordered">

                    <tr>
                        <th>Full Name</th>
                        <th>Brith Date</th>
                        <th>Phone Number</th>
                        <th>Mail</th>
                        <th>Address</th>
                        <th>Delete</th>
                    </tr>

                    <a href="addUsers.jsp">
                        <button class="btn btn-primary mr-2" type="submit">Add User</button></a>
                    <form id="FormId" action="SaveUserServlet" method="POST">
                        <button class="btn btn-primary" type="submit">Save</button>

                        <% for (Users order : lo) { %>
                        <tr>
                            <td style="display: none"><input type="hidden" style="border:0px;" name="id" value="<%= order.getUserId() %>"></td>
                            <td>
                                <input type="text" id="fullNameInput" name="name" value="<%= order.getFullName() %>" class="form-control">
                                <span id="nameError" class="error-message"></span>
                            </td>


                            <td><input type="date" id="dateInput" style="border:0px;" name="date" value="<%= order.getBirthDate() %>">
                                <span id="dateError" class="error-message"></span>
                            </td>
                            <td>
                                <input type="text" id="phoneInput" name="phone" value="<%= order.getPhoneNumber() %>" class="form-control">
                                <span id="phoneError" class="error-message"></span>
                            </td>

                            <td><input  type="email" id="emailInput" style="border:0px;" name="email" value="<%= order.getEmail() %>">
                                <span  id="emailError" class="error-message"></span>
                            </td>
                            <td><input type="text"  id="addressInput" style="border:0px;" name="address" value="<%= order.getAddress() %>">
                                <span  id="addressError"  class="error-message"></span>
                            </td> 
                        <input type="hidden" style="border:0px;" name="method" value="edit">
                    </form>
                    <td><form action="SaveUserServlet" method="post">
                            <input type="hidden" style="border:0px;" name="id" value="<%= order.getUserId() %>">
                            <input type="hidden" name="method" value="delete">
                            <button type="submit" class="btn btn-primary">Delete</button>  
                        </form></td>                              
                    </tr>
                    <% } %>

                </table>
            </div>
        </div>


        <script>
            $(document).ready(function () {
                $('#FormId').submit(function (event) {
                    var isValid = true;

                    // Validate full name
                    var fullName = $('#fullNameInput').val();
                    if (!fullName) {
                        $('#nameError').text('Full name is required.').css('color', 'red');
                        isValid = false;
                    } else {
                        $('#nameError').text('');
                    }
                    var date = $('#dateInput').val();
                    if (!date) {
                        $('#dateError').text('BirthDate is required.').css('color', 'red');
                        isValid = false;
                    } else {
                        $('#dateError').text('');
                    }
                    var email = $('#emailInput').val();
                    if (!email) {
                        $('#emailError').text('Email is required.').css('color', 'red');
                        isValid = false;
                    } else {
                        $('#emailError').text('');
                    }
                    var address = $('#addressInput').val();
                    if (!address) {
                        $('#addressError').text('address is required.').css('color', 'red');
                        isValid = false;
                    } else {
                        $('#addressError').text('');
                    }

                    // Validate phone number
                    var phone = $('#phoneInput').val();
                    if (!phone || phone.length !== 10 || isNaN(phone)) {
                        $('#phoneError').text('Phone number must be 10 digits.').css('color', 'red');
                        isValid = false;
                    } else {
                        $('#phoneError').text('');
                    }

                    // Add additional input validations here...

                    // Prevent form submission if any field is invalid
                    if (!isValid) {
                        event.preventDefault();
                    }
                });

                // Clear error message when the user starts typing in each field
                $('input').on('input', function () {
                    var inputId = $(this).attr('id');
                    $('#' + inputId + 'Error').text('');
                });
            });
        </script>

    </body>
</html>
