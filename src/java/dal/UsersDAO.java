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
      
    public static void main(String[] args) {
        UsersDAO u = new UsersDAO();
        List<Users> list = u.getAll();
        System.out.println(list.get(0).getFullName());
        for(int i = 0 ; i < list.size(); i++){
            System.out.println(list.get(i).getEmail());
            System.out.println(list.get(i).getPassWord());
        }
    }
    
}
