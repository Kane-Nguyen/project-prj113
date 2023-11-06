 <%-- 
    Document   : userDetail
    Created on : Oct 19, 2023, 5:17:35 PM
    Author     : TU ANH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="dal.UsersDAO" %>
<%@page import="model.Users" %>
<%@page import="java.util.List"%>

<%
UsersDAO u = new UsersDAO();
//List<Users> l = u.getAllById();
int id=-1;
Object sessionId = session.getAttribute("userID");
if (sessionId != null) {
    try {
        id = Integer.parseInt(sessionId.toString());
        System.out.println(id);
        
        // The rest of your code
    } catch (NumberFormatException e) {
        // Handle exception: not a number
        System.out.println("ID is not a number");
    }
} else {
    // Handle exception: session attribute 'id' is null
    System.out.println("ID is null");
}
List<Users> l = u.getAllById(id);
%>




<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="./css/userdetail.css"/>
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
                    <form action="SaveUserServlet" method="post">                               
                        <input type="hidden" name="id" id="id" value="${sessionScope.userID}" >
                    <div class="form-group">
                        <div class="user-id"><label for="fullName">Your name</label></div>                    
                        <input type="text" name="name" id="name" value="<%=l.get(0).getFullName()%>" >
                    </div>
                    <div class="form-group">
                        <div class="user-id"<label for="fullName">Birthday</label></div> 
                        <input type="text" name="date" id="birthday" value="<%=l.get(0).getBirthDate()%>" >
                    
                    </div>
                    <div class="form-group">
                        <div class="user-id"<label for="fullName">Email</label></div> 
                        <input type="text"name="email" id="email" value="<%=l.get(0).getEmail()%>" >
                    </div>
                    <div class="form-group">
                        <div class="user-id"<label for="fullName">Address</label></div> 
                        <input type="text" name="address" id="address" value="<%=l.get(0).getAddress()%>" >
                    </div>
                    <div class="form-group">
                        <div class="user-id"<label for="fullName">Contact Number</label></div> 
                        <input type="text" name="phone" id="phone" value="<%=l.get(0).getPhoneNumber()%>" >
                          </div>
                          <input name="method" type="hidden" value="edit">
                          <input name="method1" type="hidden" value="edit1">
                    <button type="submit" id="showSecretButton1">Save</button>
                      </form>
                        <div class="form-group">
                            <div class="user-id"<label for="fullName"></label><a href="changePassword.jsp">Change Password</a></div> 
                        </div>
                        <div class="form-group d-flex">
                            <div class="user-id">
                                <button id="showSecretButton">Show Secret String</button> <span id="secretStringDiv" style="display: none;">Secret String: ${sessionScope.SecretString}</span>                          
                            </div>
                               
                        </div>
                              
                    </c:if>

                    <c:if test="${empty sessionScope.isLoggedIn}">
                        <p>You are not logged in.</p>
                        <a href="http://localhost:8080/projectPRJ113/login" alt="btn-link-login" class="btn btn-outline-success me-2">Login</a>
                    </c:if>
             

                </body>
                <script>
                    document.getElementById("showSecretButton").addEventListener("click", function () {
                        // Create a custom modal for password input
                        var modal = document.createElement('div');
                        modal.id = "passwordModal";
                        modal.innerHTML = `
                        <div class="modal-content">
                            <span class="close" onclick="closeModal()">&times;</span>
                            <label for="password">Enter your password:</label>
                            <input type="password" id="password">
                            <div class="error-message" id="password-error"></div>
                            <button id="submitPassword">Submit</button>
                        </div>
                    `;
                        document.body.appendChild(modal);

                        // Show the modal
                        modal.style.display = "block";

                        // Handle the submit button
                        document.getElementById("submitPassword").addEventListener("click", function () {
                            var password = document.getElementById("password").value;

                            var xhr = new XMLHttpRequest();
                            xhr.open("POST", "userDetailPW", true);
                            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
                            xhr.onreadystatechange = function () {
                                if (xhr.readyState === 4 && xhr.status === 200) {
                                    var response = xhr.responseText;
                                    if (response === "error") {
                                        document.getElementById("password-error").innerHTML = "Wrong password, please re-enter!";
                                    } else {
                                        closeModal();
                                        var successModal = document.createElement('div');
                                        successModal.id = "successModal";
                                        successModal.innerHTML = `
                        <div class="modal2-content">
                            <span class="close" onclick="closeSuccessModal()">&times;</span>
                            <p>Password is correct!</p>
                            <button id="okButton">OK</button>
                        </div>
                    `;
                                        document.body.appendChild(successModal);
                                        successModal.style.display = "block";

                                        // Handle the "OK" button in the success modal
                                        document.getElementById("okButton").addEventListener("click", function () {
                                            closeSuccessModal(); // Close the success modal
                                            // If the response is not an error, display the secretString
                                            document.getElementById("secretStringDiv").style.display = "inline";
                                        });
                                    }
                                }
                            };
                            xhr.send("password=" + password);
                        });
                    });


                    // Function to close the modal
                    function closeModal() {
                        var modal = document.getElementById("passwordModal");
                        if (modal) {
                            modal.style.display = "none";
                            modal.remove();
                        }
                    }
                    // Function to close the success modal
                    function closeSuccessModal() {
                        var successModal = document.getElementById("successModal");
                        if (successModal) {
                            successModal.style.display = "none";
                            successModal.remove();
                        }
                    }
                </script>
                </html>