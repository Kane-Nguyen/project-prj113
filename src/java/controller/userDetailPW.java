/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

// CheckPasswordServlet.java
package controller;

import dal.UsersDAO;
import model.Users;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.bind.DatatypeConverter;

@WebServlet(name = "userDetailPW", urlPatterns = {"/userDetailPW"})
public class userDetailPW extends HttpServlet {
     public static boolean verify(String inputPassword, String hashPassWord)
            throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(inputPassword.getBytes());
        byte[] digest = md.digest();
        String myChecksum = DatatypeConverter
                .printHexBinary(digest).toUpperCase();
        System.out.println(myChecksum);
        return hashPassWord.equals(myChecksum);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String enteredPassword = request.getParameter("password");
        String secretString = "";  // Initialize this with your actual secret string
        if (enteredPassword == null || enteredPassword.isEmpty()) {
            response.getWriter().write("error"); // Mật khẩu trống hoặc null, trả về lỗi
            return;
        }
        UsersDAO userDAO = new UsersDAO();
        List<Users> list = userDAO.getAll();

        // Compare the entered password with the one in the database
        boolean isPasswordCorrect = false;
        for (Users user : list) {
            try {
                if ( verify(enteredPassword,user.getPassWord())) {
                    isPasswordCorrect = true;
                    break;
                }
            } catch (NoSuchAlgorithmException ex) {
                Logger.getLogger(userDetailPW.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        if (isPasswordCorrect) {
            response.getWriter().write(secretString);
        } else {
            response.getWriter().write("error");
        }
    }
}