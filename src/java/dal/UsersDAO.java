/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Date;
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
    public Users getUserByEmailAndPassword(String email, String password) {
    String sql = "SELECT * FROM Users WHERE Email=? AND PassWord=?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, email);
        st.setString(2, password);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return new Users(
                rs.getInt("UserID"), rs.getString("FullName"), rs.getDate("BirthDate"),
                rs.getString("PhoneNumber"), rs.getString("Email"),
                rs.getString("PassWord"), rs.getString("Address"),
                rs.getDate("RegistrationDate"), rs.getString("UserRole")
            );
        }
    } catch (SQLException e) {
        System.out.println(e);
    }
    return null;
}
   public int getLastUserID() {
    String sql = "SELECT MAX(UserID) as LastUserID FROM Users";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return rs.getInt("LastUserID");
        }
    } catch (SQLException e) {
        System.out.println(e);
    }
    return -1; // Hoặc giá trị mặc định khác tùy bạn
}
    


     public void addUser(Users user) {
        String sql = "INSERT INTO Users (UserID ,FullName, BirthDate, PhoneNumber, Email, Password, Address) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
   
            st.setString(2, user.getFullName());
            st.setDate(3, (Date) user.getBirthDate());
            st.setString(4, user.getPhoneNumber());
            st.setString(5, user.getEmail());
            st.setString(6, user.getPassWord());
            st.setString(7, user.getAddress());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

     public Users getUserByEmail(String email) {
       String sql = "SELECT * FROM Users WHERE Email=?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, email);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return new Users(
                rs.getInt("UserID"), rs.getString("FullName"), rs.getDate("BirthDate"),
                rs.getString("PhoneNumber"), rs.getString("Email"),
                rs.getString("PassWord"), rs.getString("Address"),
                rs.getDate("RegistrationDate"), rs.getString("UserRole")
            );
        }
    } catch (SQLException e) {
        System.out.println(e);
    }
    return null;
}

    public static void main(String[] args) {
        UsersDAO u = new UsersDAO();
        List<Users> list = u.getAll();
        System.out.println(list.get(0).getFullName());
    }

  
    
}
