// Import necessary classes and packages
package dal;

import java.util.ArrayList;
import java.util.List;
import model.Users;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

// Giả sử rằng DBContext của bạn đã cài đặt một biến kết nối tên là 'connection'.
public class UsersDAO extends DBContext {

    public boolean insertUser(String email, String password, String fullname) {
        // SQL query to insert a new user
        String sql = "INSERT INTO Users (Email, PassWord, FullName) VALUES (?, ?, ?)";

        try {
            // Create a PreparedStatement object to execute the SQL query
            PreparedStatement st = connection.prepareStatement(sql);

            // Set the email, password, and fullname for the query
            st.setString(1, email);
            st.setString(2, password);
            st.setString(3, fullname);

            // Execute the insert and store the number of affected rows
            int affectedRows = st.executeUpdate();

            // Check if the user was inserted successfully
            if (affectedRows > 0) {
                return true;  // User was inserted successfully
            }
        } catch (SQLException e) {
            // Print the stack trace for any SQL exception
            System.out.println(e);
        }
        return false;  // User insertion failed
    }

    // Method to get all user records from the database
    public List<Users> getAll() {

        // Initialize a new ArrayList to store the Users objects that will be created from the database records
        List<Users> list = new ArrayList<>();

        // SQL query as a String to select all records from the Users table
        String sql = "select * from Users";

        try {
            // Create a PreparedStatement object to execute the SQL query
            PreparedStatement st = connection.prepareStatement(sql);

            // Execute the SQL query and store the result set
            ResultSet rs = st.executeQuery();

            // Loop through the result set and create a new Users object for each record, adding it to the list
            while (rs.next()) {
                Users u = new Users(rs.getInt("UserID"), rs.getString("FullName"), rs.getDate("BirthDate"), rs.getString("PhoneNumber"), rs.getString("Email"), rs.getString("PassWord"), rs.getString("Address"), rs.getDate("RegistrationDate"), rs.getString("UserRole"));
                list.add(u);
            }
        } catch (SQLException e) {
            // Print the stack trace for any SQL exception
            System.out.println(e);
        }

        // Return the list of Users objects created from the database records
        return list;
    }

}
