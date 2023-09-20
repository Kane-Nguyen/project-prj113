/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Login;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
/**
 *
 * @author Lenovo
 */
public class DAO extends DBContext {

    public Login check(String email, String password) {
        String sql = "SELECT Email, Password FROM Users\n"
                + "WHERE Email = ? and Password = ?;";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            st.setString(2, password);
            ResultSet rs = st.executeQuery();
            if(rs.next()){
                Login a = new Login(rs.getString("Email"),
                                    rs.getString("Password"));
                return a;
            }
        } catch (SQLException e) {
        }
        return null;
    }

}
