/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.util.List;
import model.Product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Administrator
 */
public class ProductDAO extends DBContext {
    // Doc tat ca các bang ghi tu Users

    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        String sql = "select * from Products";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Product p = new Product(rs.getString("ProductID"),  rs.getInt("Discount"),rs.getString("ProductName"),
                        rs.getString("Description"), rs.getDouble("Price"), rs.getString("ImageURL"),
                        rs.getInt("StockQuantity"), rs.getString("Category"), rs.getString("Manufacturer"),
                        rs.getDate("DateAdded"), rs.getDouble("DiscountPercentage"));
                list.add(p);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public static void main(String[] args) {
        ProductDAO u = new ProductDAO();
        List<Product> list = u.getAll();
        System.out.println(list.get(0).getProductName());
    }

}
