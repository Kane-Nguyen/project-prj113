/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.util.List;
import model.Users;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Login;

/**
 *
 * @author Administrator
 */
public class UsersDAO extends DBContext{
       // Doc tat ca các bang ghi tu Users
    public List<Users> getAll(){
        List<Users> list = new ArrayList<>();
        String sql="select * from Users";
        try {
            PreparedStatement st=connection.prepareStatement(sql);
            ResultSet rs=st.executeQuery();
            while(rs.next()){
                Users u= new Users(rs.getInt("UserID"),rs.getString("FullName"), rs.getDate("BirthDate"), rs.getString("PhoneNumber"),rs.getString("Email"),rs.getString("PassWord"),rs.getString("Address"),rs.getDate("RegistrationDate"),rs.getString("UserRole"));
                 list.add(u);  
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
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
    public static void main(String[] args) {
        UsersDAO u = new UsersDAO();
        List<Users> list = u.getAll();
        System.out.println(list.get(0).getFullName());
    }
    
}
