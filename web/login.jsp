<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Home Book Store</title>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/Styleslogin.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    </head>
    <body style="background: linear-gradient(64deg, #69B7FF -26.63%, #FFF 100%);">

        <img src="picture/login_signup_fotgot.png" class="w-100 h-100" alt="alt"/>
        <div class="container pl-5">
            <h1 class="pl-5 pb-4">Welcome Back</h1>
            <c:set var="cookie" value="${pageContext.request.cookies}"/>
            <form action="login" method="post" class="container mt-10 form-login">
                <div class="form-group pl-5 pt-2">
                    <label class="name" for="exampleInputEmail1">Email address</label>
                    <input type="email" name="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" value="${cookie.Ce.value}" placeholder="Enter email">
                    <small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>
                    <span id="error-email" style="color:red; font-weight: 600;"></span>
                </div>
                <div class="form-group pl-5 pt-2">
                    <label class="name" for="exampleInputPassword1">Password</label>
                    <div class="password-container">
                        <input type="password" name="password" class="form-control" id="exampleInputPassword1" value="${cookie.Cp.value}" placeholder="Password">
                        <ion-icon name="eye-off-outline" class="eye-icon" onclick="togglePasswordVisibility(this)"></ion-icon>
                    </div>
                    <span id="error-password" style="color:red; font-weight: 600;"></span>
                </div>
                <div class="form-check pl-5 pt-1">
                    <input type="checkbox" ${cookie.Cr!=null?'checked':''} name="rememberMe" id="rememberMe" value="on">
                    <label class="form-check-label" for="rememberMe">Remember me</label>
                    <a style="padding-left: 145px" href="changePassword.jsp">Forgot Password?<a/>
                </div>
                <input type="hidden" name="redirect" value="<%= request.getParameter("redirect") %>" />
                <div class="button pl-5 pt-4">
                    <button type="submit" value="LOGIN" class="btn btn-primary" style="background: #3F46FF;">Sign In</button>
                </div>
                <div style="padding-left: 170px" class="name-create pt-4">
                    <a href="signup.jsp">Create an account</a>
                </div>
            </form>
        </div>

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

            <% if (session != null && session.getAttribute("isLoggedIn") != null && (Boolean) session.getAttribute("isLoggedIn")) { %>
            window.location.href = "<%=request.getContextPath()%>/index.jsp";
            <% } %>

            if (window.history.replaceState) {
                window.history.replaceState(null, null, window.location.href);
            }

            function togglePasswordVisibility(icon) {
                const passwordInput = icon.previousElementSibling;
                if (passwordInput.type === "password") {
                    passwordInput.type = "text";
                    icon.setAttribute("name", "eye-outline");
                } else {
                    passwordInput.type = "password";
                    icon.setAttribute("name", "eye-off-outline");
                }
            }

            $(document).ready(function () {
              
                // Handle form submission
                $('form').submit(function (e) {
                    let email = $("#exampleInputEmail1").val();
                    let password = $("input[name='password']").val();

                    if (!email) {
                        
                });
                        hasErrors = true;
                        $('#error-email').text('Please enter your Email.');
                    } else {
                        $('#error-email').text('');
                    }
                    if (!password) {
                        hasErrors = true;
                        $('#error-password').text('Please enter your Email.');
                    } else {
                        $('#error-password').text('');
                    }
                });

                // Display server-side error message (if any)
                let serverError = "${requestScope.error}";
                if (serverError) {
                     
                    e.preventDefault();
                    $("#error-message").text(serverError);
                }
            });
        </script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    </body>
</html>