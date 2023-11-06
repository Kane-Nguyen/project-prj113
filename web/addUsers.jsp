<%-- 
    Document   : addUser
    Created on : [Your Creation Date Here]
    Author     : [Your Name Here]
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add User</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link href="./css/custom.css" rel="stylesheet"> <!-- Your custom styles -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    </head>
    <body>

        <div class="container mt-5">
            <div class="row">
                <div class="col-md-8 offset-md-2">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Add User</h3>
                        </div>

                        <div class="card-body">
                            <p style="color:red;">${requestScope.error} </p>
                            <form id="addUserForm" action="SaveUserServlet" method="POST">
                                <div class="form-group">
                                    <label for="fullNameInput">Full Name</label>
                                    <input type="text" class="form-control" id="fullNameInput" name="name" placeholder="Enter full name">
                                    <span id="nameError" class="text-danger"></span>
                                </div>
                                <div class="form-group">
                                    <label for="dateInput">Birth Date</label>
                                    <input type="date" class="form-control" id="dateInput" name="date">
                                    <span id="dateError" class="text-danger"></span>
                                </div>
                                <div class="form-group">
                                    <label for="phoneInput">Phone Number</label>
                                    <input type="text" class="form-control" id="phoneInput" name="phone" placeholder="Enter 10-digit phone number">
                                    <span id="phoneError" class="text-danger"></span>
                                </div>
                                <div class="form-group">
                                    <label for="emailInput">Email</label>
                                    <input type="email" class="form-control" id="emailInput" name="email" placeholder="Enter email">
                                    <span id="emailError" class="text-danger"></span>
                                </div>
                                <div class="form-group">
                                    <label for="emailInput">Password</label>
                                    <input type="password" class="form-control" id="passwordInput" name="password" placeholder="Enter Password">
                                    <span id="passwordError" class="text-danger"></span>
                                </div>
                                <div class="form-group">
                                    <label for="roleSelect">Role</label>
                                    <select class="form-control" id="roleSelect" name="role">
                                        <option value="User">User</option>
                                        <option value="Admin">Admin</option>
                                    </select>
                                    <span id="roleError" class="text-danger"></span>
                                </div>
                                <input type="hidden" name="method" value="add">
                                <div class="form-group">
                                    <label for="addressInput">Address</label>
                                    <input type="text" class="form-control" id="addressInput" name="address" placeholder="Enter address">
                                    <span id="addressError" class="text-danger"></span>
                                </div>
                                <button type="submit" class="btn btn-primary">Submit</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            $(document).ready(function () {
                $('#addUserForm').submit(function (event) {
                    var isValid = true;

                    // Validate full name
                    var fullName = $('#fullNameInput').val();
                    if (!fullName) {
                        $('#nameError').text('Full name is required.').css('color', 'red');
                        isValid = false;
                    } else {
                        $('#nameError').text('');
                    }

                    // Validate birth date
                    var birthDate = $('#dateInput').val();
                    if (!birthDate) {
                        $('#dateError').text('Birth date is required.').css('color', 'red');
                        isValid = false;
                    } else {
                        $('#dateError').text('');
                    }

                    // Validate phone number
                    var phone = $('#phoneInput').val();
                    if (!phone || phone.length !== 10 || isNaN(phone)) {
                        $('#phoneError').text('Phone number must be 10 digits.').css('color', 'red');
                        isValid = false;
                    } else {
                        $('#phoneError').text('');
                    }

                    // Validate email
                    var email = $('#emailInput').val();
                    if (!email) {
                        $('#emailError').text('Email is required.').css('color', 'red');
                        isValid = false;
                    } else {
                        $('#emailError').text('');
                    }
                    var email = $('#passwordInput').val();
                    if (!email) {
                        $('#passwordError').text('Email is required.').css('color', 'red');
                        isValid = false;
                    } else {
                        $('#passwordError').text('');
                    }

                    // Validate address
                    var address = $('#addressInput').val();
                    if (!address) {
                        $('#addressError').text('Address is required.').css('color', 'red');
                        isValid = false;
                    } else {
                        $('#addressError').text('');
                    }

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
