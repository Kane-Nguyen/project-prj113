/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import model.Product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

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

    
    public void addProduct(String ProductName, String Description, double Price,double DiscountPercentage, String ImageURL,
       int StockQuantity, String Category, String Manufacturer) {          
      
    String sql = "INSERT INTO Products (ProductID, ProductName, Description, Price, DiscountPercentage, ImageURL, StockQuantity, Category, Manufacturer) VALUES (NEWID(), ?, ?, ?, ?, ?, ?, ?, ?)";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, ProductName);
        st.setString(2, Description);
        st.setDouble(3, Price);
        st.setDouble(4, DiscountPercentage);
        st.setString(5, ImageURL);
        st.setInt(6, StockQuantity);
        st.setString(7, Category);
        st.setString(8, Manufacturer);
        

        st.executeUpdate();
    } catch (SQLException e) {
        System.out.println(e);
    }

}
  
    
public void editProduct(String ProductName, String Description, double Price, String ImageURL, 
        int StockQuantity, String Category, String Manufacturer, double DiscountPercentage, String id ) {
    
  
  
    
    String sql = "UPDATE Products SET ProductName=?, Description=?, Price=?, ImageURL=?,"
            + " StockQuantity=?, Category=?, Manufacturer=?, DiscountPercentage=? WHERE ProductID=?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);

        st.setString(1, ProductName);
        st.setString(2, Description);
        st.setDouble(3, Price);
        st.setString(4, ImageURL);
        st.setInt(5, StockQuantity);
        st.setString(6, Category);
        st.setString(7, Manufacturer);      
        st.setDouble(8, DiscountPercentage);  
        st.setString(9, id);

        st.executeUpdate();
        System.out.println(ImageURL);
        System.out.println("Update successful");
    } catch (SQLException e) {
        // Log the exception
        System.out.println("SQL Error: " + e.getMessage());
    }
}

public void deleteProduct(String productID) throws SQLException {
    String sql = "DELETE FROM Products WHERE ProductID=?";
    PreparedStatement st = null;
    try {
        st = connection.prepareStatement(sql);
        st.setString(1, productID);
        st.executeUpdate();
    } catch (SQLException e) {
        // Use logging framework to log the error
        // log.error("Error while deleting product: " + e.getMessage());
        System.out.println(e);
        throw e; // Rethrow or handle the SQLException
    } finally {
        if (st != null) {
            try {
                st.close();
            } catch (SQLException e) {
                // log or handle the close exception
            }
        }
    }
}



    public static void main(String[] args) {
        ProductDAO u = new ProductDAO();
     
    }

}
