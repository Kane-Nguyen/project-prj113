<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" href="css/StyleForgotPassword.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
          <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    </head>
    <body>
        <img src="picture/login_signup_fotgot.png" class="w-100 h-100 image-background" alt="alt"/>
        <div class="container wrap-form-forgot-password">
            <h2>Forgot Password</h2>
            <form action="changepassword" method="post" class="container mt-10 wrap-form-forgot-password-inside">
                <div class="form-group item-field">
                    <label class="name" for="emailForgot">Your email :</label>
                    <input type="email" name="email" id="emailForgot" class="form-control" placeholder="Enter email">
                      <span id="error-email" style="color:red; font-weight: 600;"></span>
                </div>
                <div class="form-group item-field">
                    <label class="name" for="secretStringForgot">Your Secret String:</label>
                    <input type="password" name="secretString" id="secretStringForgot" class="form-control" placeholder="Enter secretString">
                    <span id="error-secretString" style="color:red; font-weight: 600;"></span>
                </div>
                <div class="form-group item-field">
                    <label class="name" for="newPassword">New password:  </label>
                    <div class="password-container">
                        <input type="password" name="newPassword" class="form-control" placeholder="Enter new password">
                        <ion-icon name="eye-off-outline" class="eye-icon" onclick="togglePasswordVisibility(this)"></ion-icon>
                    </div>
                    <span id="error-newPassword" style="color:red; font-weight: 600;"></span>
                </div>
                <div class="form-group item-field">
                    <label class="name" for="confirmNewPassword">Confirm new password:</label>
                    <div class="password-container">
                        <input type="password" name="confirmNewPassword" class="form-control" placeholder="Enter Confirm new password">
                        <ion-icon name="eye-off-outline" class="eye-icon" onclick="togglePasswordVisibility(this)"></ion-icon>
                    </div>
                    <span id="error-confirmNewPassword" style="color:red; font-weight: 600;"></span>
                </div>

                <div class="button">
                    <input type="submit" value="Change Password" class="btn btn-primary" style="background: #3F46FF;">
                </div>
                <div class="form-check">
                    <a href="signup.jsp" ><i class="bi bi-arrow-bar-left icon-forgot-password"></i>Back to create account</a>
                    <a href="login.jsp"><i class="bi bi-person-check icon-forgot-password"></i>Sign in</a>
                </div>
            </form>
        </div>
        <script>
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
                    let email = $("#emailForgot").val().trim();
                    let secretString = $("#secretStringForgot").val().trim();
                    let newPassword = $("input[name='newPassword']").val().trim();
                    let confirmNewPassword = $("input[name='confirmNewPassword']").val().trim();
                    let hasErrors = false;

                    if (!email) {
                        hasErrors = true;
                        $('#error-email').text('Please enter your Email.');
                    } else {
                        $('#error-email').text('');
                    }

                    if (!secretString) {
                        hasErrors = true;
                        $('#error-secretString').text('Please enter your secret string.');
                    } else {
                        $('#error-secretString').text('');
                    }

                    if (!newPassword) {
                        hasErrors = true;
                        $('#error-newPassword').text('Please enter your new password.');
                    } else {
                        $('#error-newPassword').text('');
                    }

                    if (!confirmNewPassword) {
                        hasErrors = true;
                        $('#error-confirmNewPassword').text('Please confirm your new password.');
                    } else if (newPassword !== confirmNewPassword) {
                        hasErrors = true;
                        $('#error-confirmNewPassword').text('Passwords do not match.');
                    } else {
                        $('#error-confirmNewPassword').text('');
                    }

                    if (hasErrors) {
                        e.preventDefault(); // Prevent form submission if there are errors.
                    }
                });

                // Display server-side error message (if any)
                let serverError = "${requestScope.error}";
                if (serverError) {
                    $("#error-message").text(serverError);
                }
            });
        </script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
    </body>
</html>