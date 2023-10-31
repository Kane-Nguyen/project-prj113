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

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
     throws ServletException, IOException {
        request.getRequestDispatcher("signup.jsp").forward(request, response);
    }
    
     @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String birthDateStr = request.getParameter("birthDate");
        String phoneNumber = request.getParameter("phoneNumber");
        String email = request.getParameter("email");
        String passWord = request.getParameter("passWord");
        String address = request.getParameter("address");
        String userRole = request.getParameter("userRole");
        String SecretString = request.getParameter("SecretString");
        
        if(userRole == null || userRole.isEmpty()){
            userRole = "User";
        }
        
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

        request.setAttribute("fullName", fullName);
        request.setAttribute("birthDate", birthDateStr);
        request.setAttribute("phoneNumber", phoneNumber);
        request.setAttribute("address", address);
        request.setAttribute("userRole", userRole);
        request.setAttribute("SecretString", SecretString);
        // Kiểm tra email đã được đăng ký trước đó
        if (email != null && !email.isEmpty()) {
            for (Users user : list) {
                if (user.getEmail().equals(email)) {
                    // Hiển thị thông báo lỗi và ngăn chặn chuyển hướng
                    request.setAttribute("error", "Email already registered. Please try another email.");
                    request.getRequestDispatcher("signup.jsp").forward(request, response);
                    return;
                }
            }
        }

        // Thêm người dùng mới vào cơ sở dữ liệu
        boolean isSuccess = userDAO.insertUser(fullName, birthDate, phoneNumber, email, passWord, address, userRole, SecretString);

        if (isSuccess) {
            // Success
            //response.getWriter().write("User registered successfully.");
            String redirectURL = "login.jsp"; // Thay thế URL mong muốn
            String redirectURL1 = "http://localhost:8080/projectPRJ113/";
            String popupScript = "<script>var result = confirm('User registered successfully'); if (result) { window.location.href='" + redirectURL + "'; } else { window.location.href='" + redirectURL1 + "'; }</script>";
            response.getWriter().write(popupScript);
        } else {
            // Failure
            response.getWriter().write("Registration failed. Please try again.");
        }
    }
}