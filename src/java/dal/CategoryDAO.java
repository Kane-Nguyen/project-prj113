/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.CategoryBook;

/**
 *
 * @author khaye
 */
public class CategoryDAO extends DBContext {

    public List<CategoryBook> getAll() {
        List<CategoryBook> list = new ArrayList<>();
        String sql = "select * from Categories";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CategoryBook cb = new CategoryBook(rs.getInt("CategoryID"), rs.getString("CategoryName"));
                list.add(cb);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public String getCategoryByProductId(int CategoryID) {
        String sql = "select CategoryName from Categories where CategoryID = ?";
        String categoryName = "";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, CategoryID);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                categoryName = rs.getString("CategoryName");
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return categoryName;
    }

    public static void main(String[] args) {
        CategoryDAO cbDao = new CategoryDAO();
        System.out.println(cbDao.getCategoryByProductId(1));
    }

}
