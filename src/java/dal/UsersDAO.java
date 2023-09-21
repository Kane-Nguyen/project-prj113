// Import necessary classes and packages
package dal;

import java.util.ArrayList;
import java.util.List;
import model.Users;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Administrator
 */
// Define the UsersDAO class that extends the DBContext class to interact with your database
public class UsersDAO extends DBContext {

    public boolean updatePassword(String email, String newPassword) {
        // SQL query to update password based on the email
        String sql = "UPDATE Users SET PassWord = ? WHERE Email = ?";

        try {
            // Create a PreparedStatement object to execute the SQL query
            PreparedStatement st = connection.prepareStatement(sql);

            // Set the new password and email for the query
            st.setString(1, newPassword);
            st.setString(2, email);

            // Execute the update and store the number of affected rows
            int affectedRows = st.executeUpdate();

            // Check if the password was updated successfully
            if (affectedRows > 0) {
                return true;  // Password was updated successfully
            }
        } catch (SQLException e) {
            // Print the stack trace for any SQL exception
            System.out.println(e);
        }
        return false;  // Password update failed
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

    // Main method to test the getAll method
    public static void main(String[] args) {

        // Create a new UsersDAO object
        UsersDAO u = new UsersDAO();

        // Call the getAll method and store the list of Users objects
        List<Users> list = u.getAll();

        // Print the full name of the first user in the list
        System.out.println(list.get(4).getEmail());
        System.out.println(list.get(4).getPassWord());
    }
}
