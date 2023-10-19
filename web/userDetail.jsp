<%-- 
    Document   : userDetail
    Created on : Oct 19, 2023, 5:17:35 PM
    Author     : TU ANH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Detail</title>
</head>
<body>
    <h1>User Detail</h1>

    <!-- Check if user is logged in -->
    <c:if test="${not empty sessionScope.isLoggedIn}">
        <p>Email: ${sessionScope.email}</p>
        <p>Your Name: ${sessionScope.fullName}</p>
        <p>Your Birthday: ${sessionScope.birthDay}</p>
        <p>Your Phone: ${sessionScope.phoneNumber}</p>
        <p>Your Address: ${sessionScope.address}</p>
        
        <p><a href="changePassword.jsp">Change Password</a></p>
        <button id="showSecretButton">Show Secret String</button>
        <div id="secretStringDiv" style="display: none;">Secret String: ${sessionScope.SecretString}</div>
    </c:if>

    <c:if test="${empty sessionScope.isLoggedIn}">
        <p>You are not logged in.</p>
        <a href="http://localhost:8080/projectPRJ113/login" alt="btn-link-login" class="btn btn-outline-success me-2">Login</a>
    </c:if>

    <script>
        document.getElementById("showSecretButton").addEventListener("click", function() {
            var password = prompt("Please enter your password:");

            var xhr = new XMLHttpRequest();
            xhr.open("POST", "userDetailPW", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
            xhr.onreadystatechange = function() {
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
</body>
</html>
