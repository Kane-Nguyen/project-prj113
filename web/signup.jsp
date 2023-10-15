<%-- 
    Document   : signup
    Created on : Sep 27, 2023, 2:09:04 PM
    Author     : TU ANH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>Sign Up Form by Code</title>

        <link rel="stylesheet"
              href="fonts/material-icon/css/material-design-iconic-font.min.css">

        <link rel="stylesheet" href="css/stylesighup.css">
    </head>
    <style>
        /* CSS để định dạng thông báo lỗi */
        .error-message {
            color: red; /* Màu chữ đỏ */
        }
    </style>
    <body>

        <div class="main">

            <!-- Sign up form -->
            <section class="signup">
                <div class="container">
                    <div class="signup-content">
                        <div class="signup-form">
                            <h2 class="form-title">Sign up</h2>

                            <form method="POST" action="signup" class="register-form"
                                  id="register-form">
                                <div class="form-group">
                                    <label for="fullName"><i
                                            class="zmdi zmdi-account material-icons-name"></i></label> <input
                                        type="text" name="fullName" id="fullName" placeholder="Your Name" value='${requestScope.fullName}' />
                                    <span class="error-message" id="fullName-error"></span>
                                </div>
                                <div class="form-group">
                                    <label for="birthDate"><i class="zmdi zmdi-calendar"></i></label>
                                    <input type="date" name="birthDate" id="birthDate" placeholder="Your Date of Birth" value='${requestScope.birthDate}' />
                                    <span class="error-message" id="birthDate-error"></span>
                                </div>
                                <div class="form-group">
                                    <label for="phoneNumber"><i class="zmdi zmdi-phone"></i></label>
                                    <input type="tel" name="phoneNumber" id="phoneNumber" placeholder="Your Phone Number" pattern="[0-9]+" title="Please enter a valid phone number (digits only)." value='${requestScope.phoneNumber}' />
                                    <span class="error-message" id="phoneNumber-error"></span>
                                </div>
                                <div class="form-group">
                                    <label for="email"><i class="zmdi zmdi-email"></i></label> <input
                                        type="email" name="email" id="email" placeholder="Your Email" value='${requestScope.email}' />
                                    <span class="error-message" id="email-error"></span>
                                    <div id="email-exists-error" class="error-message" style="display: none;"></div>
                                </div>
                                <h5 style="color:red; ">${requestScope.error}</h5>
                                <div class="form-group">
                                    <label for="passWord"><i class="zmdi zmdi-lock"></i></label> <input
                                        type="passWord" name="passWord" id="passWord" placeholder="Password" value='${requestScope.passWord}' />
                                    <span class="error-message" id="passWord-error"></span>
                                </div>
                                <div class="form-group">
                                    <label for="address"><i class="zmdi zmdi-pin"></i></label>
                                    <input type="text" name="address" id="address" placeholder="Your Address" value='${requestScope.address}' />
                                    <span class="error-message" id="address-error"></span>
                                </div>
                              
                                <div class="form-group form-button">
                                    <input type="submit" name="signup" id="signup"
                                           class="form-submit" value="Register" />
                                </div>
                                <!-- Thêm phần tử div để hiển thị thông báo lỗi -->
                                <div class="form-group error-message" id="fullName-error"></div>
                                <div class="form-group error-message" id="birthDate-error"></div>
                                <div class="form-group error-message" id="phoneNumber-error"></div>
                                <div class="form-group error-message" id="email-error"></div>
                                <div class="form-group error-message" id="passWord-error"></div>
                                <div class="form-group error-message" id="address-error"></div>
                               
                            </form>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
    <script>
        // Sử dụng JavaScript để kiểm tra biểu mẫu trước khi submit
        document.getElementById("register-form").addEventListener("submit", function (event) {
            // Kiểm tra từng trường nhập liệu
            var fullName = document.getElementById("fullName").value;
            var birthDate = document.getElementById("birthDate").value;
            var phoneNumber = document.getElementById("phoneNumber").value;
            var email = document.getElementById("email").value;
            var passWord = document.getElementById("passWord").value;
            var address = document.getElementById("address").value;
            var userRole = 'User';

            // Đặt biến để kiểm tra xem có lỗi không
            var hasError = false;

            // Kiểm tra từng trường nhập liệu, nếu trống thì hiển thị thông báo lỗi
            if (fullName.trim() === "") {
                document.getElementById("fullName-error").innerHTML = "Please enter your name.";
                hasError = true;
            } else {
                document.getElementById("fullName-error").innerHTML = "";
            }

            if (birthDate.trim() === "") {
                document.getElementById("birthDate-error").innerHTML = "Please enter your date of birth.";
                hasError = true;
            } else {
                document.getElementById("birthDate-error").innerHTML = "";
            }

            if (phoneNumber.trim() === "") {
                document.getElementById("phoneNumber-error").innerHTML = "Please enter your phone number.";
                hasError = true;
            } else {
                document.getElementById("phoneNumber-error").innerHTML = "";
            }

            if (email.trim() === "") {
                document.getElementById("email-error").innerHTML = "Please enter your email.";
                hasError = true;
            } else if (!email.endsWith("@gmail.com")) {
                document.getElementById("email-error").innerHTML = "Please enter a valid Gmail address.";
                hasError = true;
            } else {
                document.getElementById("email-error").innerHTML = "";
            }

            if (passWord.trim() === "") {
                document.getElementById("passWord-error").innerHTML = "Please enter a password.";
                hasError = true;
            } else if (passWord.length < 6) {
                document.getElementById("passWord-error").innerHTML = "Password must be at least 6 characters long.";
                hasError = true;
            } else {
                document.getElementById("passWord-error").innerHTML = "";
            }

            if (address.trim() === "") {
                document.getElementById("address-error").innerHTML = "Please enter your address.";
                hasError = true;
            } else {
                document.getElementById("address-error").innerHTML = "";
            }

            if (userRole.trim() === "") {
                document.getElementById("userRole-error").innerHTML = "Please enter your role.";
                hasError = true;
            } else {
                document.getElementById("userRole-error").innerHTML = "";
            }

            // Nếu có lỗi, ngăn chặn sự kiện submit
            if (hasError) {
                event.preventDefault();
            }
        });
    </script>
</body>
</html>