<%-- 
    Document   : userDetail
    Created on : Oct 19, 2023, 5:17:35 PM
    Author     : TU ANH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="CSS/styleuserDetail.css"/>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>User Detail</title>
    </head>
    <body>
        <div class="container">
            <div class="userDetail-left">
                <div class="ic-home">
                    <a href="index.jsp" <i class="bi bi-house-door" style="width: 10px;"></i></a>
                </div>
            </div>

            <div class="userDetail-right">
                <h1 class="userDetail-tittle">Edit profile</h1>

                <!-- Check if user is logged in -->
                <c:if test="${not empty sessionScope.isLoggedIn}">
                    <div class="form-group">
                    <div class="user-id"><label for="fullName">Your name</label></div>                    
                    <input type="text" id="name" value="${sessionScope.fullName}" disabled>
                    </div>
                    <div class="form-group">
                    <div class="user-id"<label for="fullName">Birthday</label></div> 
                    <input type="text" id="birthday" value="${sessionScope.birthDay}" disabled>
                    </div>
                    <div class="form-group">
                    <div class="user-id"<label for="fullName">Email</label></div> 
                    <input type="text" id="email" value="${sessionScope.email}" disabled>
                    </div>
                    <div class="form-group">
                    <div class="user-id"<label for="fullName">Address</label></div> 
                    <input type="text" id="address" value="${sessionScope.address}" disabled>
                    </div>
                    <div class="form-group">
                    <div class="user-id"<label for="fullName">Contact Number</label></div> 
                    <input type="text" id="phone" value="${sessionScope.phoneNumber}" disabled>
                    <div class="form-group">
                    <div class="user-id"<label for="fullName">Change Password: </label><a href="changePassword.jsp">Change Password</a></div> 
                    </div>
                    <div class="form-group">
                    <div class="user-id"<label for="fullName">Show Secret String: </label><button id="showSecretButton">Show Secret String</button></div>
                    </div>
                    <div id="secretStringDiv" style="display: none;">Secret String: ${sessionScope.SecretString}</div>
                </c:if>

                <c:if test="${empty sessionScope.isLoggedIn}">
                    <p>You are not logged in.</p>
                    <a href="http://localhost:8080/projectPRJ113/login" alt="btn-link-login" class="btn btn-outline-success me-2">Login</a>
                </c:if>
            </div>

    </body>
    <script>
        document.getElementById("showSecretButton").addEventListener("click", function () {
            var password = prompt("Please enter your password:");

            var xhr = new XMLHttpRequest();
            xhr.open("POST", "userDetailPW", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    var response = xhr.responseText;
                    if (response === "error") {
                        alert("Incorrect password. Please try again.");
                    } else {
                        // If the response is not an error, display the secretString
                        document.getElementById("secretStringDiv").style.display = "block";
                    }
                }
            };
            xhr.send("password=" + password);
        });
    </script>
</html>