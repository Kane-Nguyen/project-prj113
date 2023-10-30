<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form action="changepassword" method="post">
            <label for="emailForgot">Enter your email: </label>
            <input type="email" name="email" id="emailForgot">
            <label for="secretStringForgot">Enter your Secret String:</label>
            <input type="password" name="secretString" id="secretStringForgot">
            Enter new password: <input type="password" name="newPassword">
            Confirm new password: <input type="password" name="confirmNewPassword">
            <input type="submit" value="Change Password">
        </form>
        <h5 style="color:red; ">${requestScope.error}</h5>

    </body>
</html>