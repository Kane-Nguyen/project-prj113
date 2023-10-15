<%-- 
    Document   : enterCode
    Created on : Oct 5, 2023, 10:59:21 AM
    Author     : khaye
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <div>

            <form action="verifyCode" method="post">
                Enter the code: <input type="text" name="code">
                <input type="submit" value="Submit">
            </form>
        </div>


    </body>
</html>
