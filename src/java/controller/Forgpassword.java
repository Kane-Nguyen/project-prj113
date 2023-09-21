import controller.Email;
import dal.UsersDAO;
import model.Users;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Properties;
import java.util.Random;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

@WebServlet("/forgotPassword")
public class Forgpassword extends HttpServlet {

    Email e = new Email();
    UsersDAO ud = new UsersDAO();
    List<Users> list = ud.getAll();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        e.setEmail(email);
        RequestDispatcher dispatcher;
        boolean emailFound = false; // Biến để kiểm tra email
        int otpvalue;
        HttpSession mySession = request.getSession();

        if (e.getEmail() != null && !e.getEmail().equals("")) {
            for (Users user : list) {
                if (user.getEmail().equals(email)) {
                    emailFound = true; // Đặt biến thành true nếu tìm thấy email
                    // sending otp
                    Random rand = new Random();
                    otpvalue = rand.nextInt(1255650);

                    String to = e.getEmail();// change accordingly
                    // Get the session object
                    Properties props = new Properties();
                    props.put("mail.smtp.host", "smtp.gmail.com");
                    props.put("mail.smtp.socketFactory.port", "465");
                    props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
                    props.put("mail.smtp.auth", "true");
                    props.put("mail.smtp.port", "465");
                    Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication("nextgooo843@gmail.com", "nobu zoum culg xccq");// Put your email and app password
                            // id and
                            // password here
                        }
                    });
                    // compose message
                    try {
                        MimeMessage message = new MimeMessage(session);
                        message.setFrom(new InternetAddress(email));// change accordingly
                        message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
                        message.setSubject("Hello");
                        message.setText("your OTP is: " + otpvalue);
                        // send message
                        Transport.send(message);
                        System.out.println("message sent successfully");
                    } catch (MessagingException e) {
                        throw new RuntimeException(e);
                    }
                    dispatcher = request.getRequestDispatcher("EnterOtp.jsp");
                    request.setAttribute("message", "OTP is sent to your email id");
                    mySession.setAttribute("otp", otpvalue);
                    mySession.setAttribute("email", e.getEmail());
                    dispatcher.forward(request, response);
                    break;
                }
            }
            if (!emailFound) {
                request.setAttribute("message", "Tài khoản không tồn tại");
                dispatcher = request.getRequestDispatcher("ForgotPasswordPage.html"); // Điều hướng người dùng về trang thông báo HTML
                dispatcher.forward(request, response);
            }
        } else {
            request.setAttribute("message", "Email không được để trống");
            dispatcher = request.getRequestDispatcher("ForgotPasswordPage.html"); // Điều hướng người dùng về trang thông báo HTML
            dispatcher.forward(request, response);
        }
    }
}