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

    public boolean insertUser(String fullName, Date birthDate, String phoneNumber, String email, String passWord, String address, String userRole) {
        String sql = "INSERT INTO Users (FullName, BirthDate, PhoneNumber, Email, PassWord, Address, UserRole) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, fullName);
            st.setDate(2, birthDate);
            st.setString(3, phoneNumber);
            st.setString(4, email);
            st.setString(5, passWord);
            st.setString(6, address);
            st.setString(7, userRole);

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
                        rs.getString("CartItems"),
                        rs.getString("SecretString")
                );
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return list;
    }
    
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(password.getBytes());
            byte[] bytes = md.digest();
            StringBuilder sb = new StringBuilder();
            for (byte aByte : bytes) {
                sb.append(Integer.toString((aByte & 0xff) + 0x100, 16).substring(1));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
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
    public static void main(String[] args) {
        UsersDAO u = new UsersDAO();
        List<Users> l = u.getAll();
               System.out.println(l.get(0).getFullName());
    }


}
