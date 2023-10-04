package dal;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import model.Users;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsersDAO extends DBContext {

    public boolean insertUser(String fullName, Date birthDate, String phoneNumber,String email, String passWord, String address, String userRole) {
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
                    rs.getString("UserRole")
                );
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return list;
    }
}
