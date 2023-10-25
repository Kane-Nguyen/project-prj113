package dal;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import model.Users;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsersDAO extends DBContext {
// Hàm mã hóa mật khẩu bằng MD5
    public String hashPassword(String password) {
        try {
            // Tạo một đối tượng MessageDigest với thuật toán MD5
            MessageDigest md = MessageDigest.getInstance("MD5");

            // Chuyển đổi mật khẩu thành chuỗi byte và cập nhật MessageDigest
            md.update(password.getBytes());

            // Lấy giá trị băm dưới dạng một mảng byte
            byte[] byteData = md.digest();

            // Chuyển đổi mảng byte thành chuỗi hex
            StringBuilder sb = new StringBuilder();
            for (byte b : byteData) {
                sb.append(Integer.toString((b & 0xff) + 0x100, 16).substring(1));
            }

            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean insertUser(String fullName, Date birthDate, String phoneNumber,String email, String passWord, String address, String userRole, String SecretString) {
        
        String sql = "INSERT INTO Users (FullName, BirthDate, PhoneNumber, Email, PassWord, Address, UserRole, SecretString) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, fullName);
            st.setDate(2, birthDate);
            st.setString(3, phoneNumber);
            st.setString(4, email);
            // Mã hóa mật khẩu trước khi lưu vào cơ sở dữ liệu bằng MD5
            String hashedPassword = hashPassword(passWord);
            st.setString(5, hashedPassword);
            st.setString(6, address);
            st.setString(7, userRole);
            st.setString(8, SecretString);

            int affectedRows = st.executeUpdate();

            if (affectedRows > 0) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    public List<Users> getAll() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Users u = new Users(
                    rs.getInt("UserID"),
                    rs.getString("FullName"),
                    rs.getDate("BirthDate"),
                    rs.getString("PhoneNumber"),
                    rs.getString("Email"),
                    rs.getString("PassWord"),
                    rs.getString("Address"),
                    rs.getDate("RegistrationDate"),
                    rs.getString("UserRole"),
                    rs.getString("SecretString")
                );
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return list;
    }

  public boolean updatePassword(String email, String newPassword) {
    String sql = "UPDATE Users SET Password = ? WHERE Email = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, newPassword);
        st.setString(2, email);

        // Execute the update
        int updatedRows = st.executeUpdate();
        // Check if any rows were updated
        if (updatedRows > 0) {
            return true;
        }
    } catch (SQLException e) {
        // Log the exception for debugging
        e.printStackTrace();
    }
    return false;
}



}