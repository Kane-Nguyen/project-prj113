<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>LogIn Store</title>
        <meta charset="UTF-8">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/Styleslogin.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    </head>
    <body>

        <img src="picture/login_signup_fotgot.png" class="w-100 h-100 image-background" alt="alt"/>
        <div class="container wrap-form-login">
            <h1 class="pb-4 login-word">Login</h1>
            <c:set var="cookie" value="${pageContext.request.cookies}"/>
            <form action="login" method="post" class="container mt-10 form-login">
                <div class="form-group  pt-2">
                    <label class="name" for="exampleInputEmail1">Email address</label>
                    <input type="email" name="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" value="${cookie.Ce.value}" placeholder="Enter email">
                    <span id="error-email" style="color:red; font-weight: 600;"></span>
                </div>
                <div class="form-group  pt-2 wrap-password">
                    <label class="name" for="exampleInputPassword1">Password</label>
                    <div class="password-container">
                        <input type="password" name="password" class="form-control" id="exampleInputPassword1" value="${cookie.Cp.value}" placeholder="Password">
                        <ion-icon name="eye-off-outline" class="eye-icon" onclick="togglePasswordVisibility(this)"></ion-icon>
                    </div>
                    <span id="error-password" style="color:red; font-weight: 600;"></span>
                </div>

                <%
                    String error = request.getParameter("error");
                    if ("invalid".equals(error)) {
                %>
                <p class="check-error " style="color: red; font-weight: 600;">Please,try again enter your email or password.</p>
                <%
                    }
                %>
                <input type="hidden" name="redirect" value="<%= request.getParameter("redirect") %>" />
                <div class="button  pt-4 ">
                    <button type="submit" value="LOGIN" class="btn btn-primary sign-in-btn" style="background: #3F46FF;">Sign In</button>
                </div>
                <div class="name-create pt-4 create-account-link">

                    <a class="forgot-password-link" href="changePassword.jsp"> <i class="bi bi-file-person forgot-password-icon"></i>Forgot Password?</a>
                    <a href="signup.jsp" class="dont-have-password-link"><i class="bi bi-person-plus-fill dont-have-password-icon"></i>Don't have Account ?</a>
                </div>
            </form>
        </div>
        <script>
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
                    let hasErrors = false; // Initialize hasErrors to false
                    let email = $("#exampleInputEmail1").val();
                    let password = $("input[name='password']").val();

                    if (!email) {
                        hasErrors = true;
                        $('#error-email').text('Please enter your Email.');
                    } else {
                        $('#error-email').text('');
                    }
                    if (!password) {
                        hasErrors = true;
                        $('#error-password').text('Please enter your Password.');
                    } else {
                        $('#error-password').text('');
                    }

                    // If there are errors, prevent the form from submitting
                    if (hasErrors) {
                        e.preventDefault();
                    }
                });
                // Display server-side error message (if any)
                let serverError = "${requestScope.error}";
                if (serverError) {
                    $("#error-password").text(serverError);
                }
            });
        </script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    </body>
</html>