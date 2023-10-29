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
        <link rel="stylesheet" href="CSS/stylesignup.css"/>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    </head>
    <style>
        /* CSS để định dạng thông báo lỗi */
        .error-message {
            color: red; /* Màu chữ đỏ */
        }
    </style>

    <body>

        <div class="container-1">
            <div class="signup_img">
                <img src="img/image 1.png" alt="Image">
            </div>

            <div class="signup-content-full">
                <!-- Sign up form -->
                <section class="signup">
                    <div class="container">
                        <div class="signup-form">
                            <h2 class="form-title">Create an account</h2>

                            <form method="POST" action="signup" class="register-form"
                                  id="register-form">
                                <div class="form-group">
                                    <div><label for="fullName">Your name</label></div>
                                    <input type="text" name="fullName" id="fullName" placeholder="First Last" style="width: 65%" value='${requestScope.fullName}' />
                                    <span class="error-message" id="fullName-error"></span>
                                </div>
                                <div class="form-group">
                                    <div><label for="birthDate">Date</label></div>
                                    <input type="date" name="birthDate" id="birthDate" placeholder="your brithday" style="width: 65%" value='${requestScope.birthDate}' />
                                    <span class="error-message" id="birthDate-error"></span>
                                </div>
                                <div class="form-group">
                                    <div><label for="phoneNumber">Phone</label></div>
                                    <input type="tel" name="phoneNumber" id="phoneNumber" placeholder="Phone" style="width: 65%" pattern="[0-9]+" title="Please enter a valid phone number (digits only)." value='${requestScope.phoneNumber}' />
                                    <span class="error-message" id="phoneNumber-error"></span>
                                </div>
                                <div class="form-group">
                                    <div><label for="email">Email</label></div>
                                    <input type="email" name="email" id="email" placeholder="you@email.com" style="width: 65%" value='${requestScope.email}' />
                                    <span class="error-message" id="email-error"></span>
                                    <div id="email-exists-error" class="error-message" style="display: none;"></div>
                                </div>
                                <h9 style="color:red;">${requestScope.error} </h9>
                                <div class="form-group">
                                    <div><label for="passWord">Password</label></div>
                                    <input type="passWord" name="passWord" id="passWord" placeholder="By.Y0u02" style="width: 65%" value='${requestScope.passWord}' />
                                    <span class="error-message" id="passWord-error"></span>
                                </div>
                                <div class="form-group">
                                    <div><label for="address">Address</label> </div>
                                    <input type="text" name="address" id="address" placeholder="Your Address" style="width: 65%" value='${requestScope.address}' />
                                    <span class="error-message" id="address-error"></span>
                                </div>
                                <div class="form-button">
                                    <input type="submit" name="signup" id="signup"
                                           class="form-submit" value="Create An Account" style="width: 65%"/>
                                </div>

                                <div class="center">
                                    <div class="form-login">
                                        <p>Already A Member? <a href="login" style="color: rgb(64, 70, 245);">Log in.<a/></p> 
                                    </div>
                                </div>
                                <!-- Thêm phần tử div để hiển thị thông báo lỗi -->
                                <div class="form-group error-message" id="fullName-error"></div>
                                <div class="form-group error-message" id="birthDate-error"></div>
                                <div class="form-group error-message" id="phoneNumber-error"></div>
                                <div class="form-group error-message" id="email-error"></div>
                                <div class="form-group error-message" id="passWord-error"></div>
                                <div class="form-group error-message" id="address-error"></div>
                                <div class="form-group" style="display: none;">
                                    <label for="userRole"><i class="zmdi zmdi-star zmdi-hc-fw" style="color: black;"></i></label>
                                    <input type="text" name="userRole" id="userRole" placeholder="Your Role" value="user" readonly />
                                    <span class="error-message" id="userRole-error"></span>
                                </div>
                            </form>
                        </div>
                    </div>
            </div>
        </section>
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
            var userRole = document.getElementById("userRole").value;

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
                document.getElementById("birthDate-error").innerHTML = "Please enter your birthdate.";
                hasError = true;
            } else {
                document.getElementById("birthDate-error").innerHTML = "";
            }

            if (phoneNumber.trim() === "") {
                document.getElementById("phoneNumber-error").innerHTML = "Please enter your phone.";
                hasError = true;
            } else {
                document.getElementById("phoneNumber-error").innerHTML = "";
            }

            if (email.trim() === "") {
                document.getElementById("email-error").innerHTML = "Please enter your email.";
                hasError = true;
            } else if (!email.endsWith("@gmail.com")) {
                document.getElementById("email-error").innerHTML = "Please enter a valid Gmail.";
                hasError = true;
            } else {
                document.getElementById("email-error").innerHTML = "";
            }

            if (passWord.trim() === "") {
                document.getElementById("passWord-error").innerHTML = "Please enter a password.";
                hasError = true;
            } else if (passWord.length < 6) {
                document.getElementById("passWord-error").innerHTML = "Password must least 6 characters.";
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
            // Nếu có lỗi, ngăn chặn sự kiện submit
            if (hasError) {
                event.preventDefault();
            }
        });
    </script>
</body>
</html>
