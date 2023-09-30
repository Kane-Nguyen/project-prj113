<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>LogIn Store</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="css/style.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    </head>
    <body>
        <c:set var="cookie" value="${pageContext.request.cookies}"/>
        <form action="login" method="post" class="container mt-10">
            <div class="form-group">
                <label for="exampleInputEmail1">Email address</label>
                <input type="email" name="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" value="${cookie.Ce.value}" placeholder="Enter email">
                <small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>
            </div>
            <div class="form-group">
                <label for="exampleInputPassword1">Password</label>
                <input type="password" name="password" class="form-control" id="exampleInputPassword1" value="${cookie.Cp.value}" placeholder="Password">
            </div>
            <div class="form-check">
                <input type="checkbox" ${cookie.Cr!=null?'checked':''} name="rememberMe" id="rememberMe" value="on">
                <label class="form-check-label" for="rememberMe">Remember me</label>
            </div>
            <button type="submit" value="LOGIN" class="btn btn-primary">Submit</button>
            <a href="SignUp.html">Don't have a password?<a/>
        </form>
        <h3 style="color:red; text-align: center;">${requestScope.error}</h3>
        
        <script>
            // JavaScript code to toggle password visibility
            document.getElementById("rememberMe").addEventListener("change", function () {
                var passwordInput = document.getElementById("exampleInputPassword1");
                if (this.checked) {
                    passwordInput.type = "text";
                } else {
                    passwordInput.type = "password";
                }
            });
        </script>
    </body>
</html>
