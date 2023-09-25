package controller;

import dal.UsersDAO;
import model.Users;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.sql.Date;
import java.util.List;
import java.sql.Date;

public class signup extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String birthDateStr = request.getParameter("birthDate");
        String phoneNumber = request.getParameter("phoneNumber");
        String email = request.getParameter("email");
        String passWord = request.getParameter("passWord");
        String address = request.getParameter("address");
        String userRole = request.getParameter("userRole");

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date utilBirthDate = null;

        try {
            utilBirthDate = dateFormat.parse(birthDateStr);
        } catch (ParseException e) {
            e.printStackTrace();
            // Xử lý lỗi ở đây nếu không thể chuyển đổi ngày sinh từ chuỗi.
        }

        // Chuyển đổi java.util.Date thành java.sql.Date
        java.sql.Date birthDate = new java.sql.Date(utilBirthDate.getTime());

        UsersDAO userDAO = new UsersDAO();
        List<Users> list = userDAO.getAll();

        // Kiểm tra email đã được đăng ký trước đó
        if (email != null && !email.isEmpty()) {
            for (Users user : list) {
                if (user.getEmail().equals(email)) {
                    String redirectURL = "SignUp.html"; // Thay thế URL mong muốn
                    String popupScript = "<script>alert('Email already registered. Please try another email.'); window.location.href='" + redirectURL + "';</script>";
                    response.getWriter().write(popupScript);
                    return;
                }
            }
        }

        // Thêm người dùng mới vào cơ sở dữ liệu
        boolean isSuccess = userDAO.insertUser(fullName, birthDate, phoneNumber, email,passWord, address,userRole);

        if (isSuccess) {
            // Success
            //response.getWriter().write("User registered successfully.");
            String redirectURL = "logIn.html"; // Thay thế URL mong muốn
            String redirectURL1 = "http://localhost:8080/projectPRJ113/";
            String popupScript = "<script>var result = confirm('User registered successfully'); if (result) { window.location.href='" + redirectURL + "'; } else { window.location.href='" + redirectURL1 + "'; }</script>";
            response.getWriter().write(popupScript);
        } else {
            // Failure
            response.getWriter().write("Registration failed. Please try again.");
        }
    }
}
