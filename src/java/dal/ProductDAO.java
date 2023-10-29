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
                Product p = new Product(rs.getString("ProductID"), rs.getString("ProductName"),
                        rs.getString("Description"), rs.getDouble("Price"), rs.getString("ImageURL"),
                        rs.getInt("StockQuantity"), rs.getInt("CategoryID"), rs.getString("Author"),
                        rs.getDate("DateAdded"), rs.getDouble("DiscountPercentage"));
                list.add(p);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public void addProduct(String ProductName, String Description, double Price, double DiscountPercentage, String ImageURL,
            int StockQuantity, int CategoryId, String Author) {

        String sql = "INSERT INTO Products (ProductID, ProductName, Description, Price, DiscountPercentage, ImageURL, StockQuantity, CategoryID, Author) VALUES (NEWID(), ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, ProductName);
            st.setString(2, Description);
            st.setDouble(3, Price);
            st.setDouble(4, DiscountPercentage);
            st.setString(5, ImageURL);
            st.setInt(6, StockQuantity);
            st.setInt(7, CategoryId);
            st.setString(8, Author);

            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }

    }

    public void editProduct(String ProductName, String Description, double Price, String ImageURL,
            int StockQuantity, int CategoryId, String Author, double DiscountPercentage, String id) {

        String sql = "UPDATE Products SET ProductName=?, Description=?, Price=?, ImageURL=?,"
                + " StockQuantity=?, CategoryID=?, Author=?, DiscountPercentage=? WHERE ProductID=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);

            st.setString(1, ProductName);
            st.setString(2, Description);
            st.setDouble(3, Price);
            st.setString(4, ImageURL);
            st.setInt(5, StockQuantity);
            st.setInt(6, CategoryId);
            st.setString(7, Author);
            st.setDouble(8, DiscountPercentage);
            st.setString(9, id);

            st.executeUpdate();

        } catch (SQLException e) {
            // Log the exception
            System.out.println("SQL Error: " + e.getMessage());
        }
    }

  public void deleteProductAndRelatedData(String productID) throws SQLException {
    PreparedStatement stReviewsAndRatings = null;
    PreparedStatement stHistoryBuyBook = null;
    PreparedStatement stBooksInOrder = null;
    PreparedStatement stTransactionHistory = null;
    PreparedStatement stOrders = null;
    PreparedStatement stProducts = null;

    String deleteReviewsAndRatingsSQL = "DELETE FROM ReviewsAndRatings WHERE ProductID=?";
    String deleteHistoryBuyBookSQL = "DELETE FROM HistoryBuyBook WHERE ProductID=?";
    String deleteBooksInOrderSQL = "DELETE FROM BooksInOrder WHERE ProductID=?";
    String deleteTransactionHistorySQL = "DELETE FROM TransactionHistory WHERE OrderID IN (SELECT OrderID FROM Orders WHERE UserID IN (SELECT UserID FROM Users WHERE UserID IN (SELECT UserID FROM Orders WHERE OrderID IN (SELECT OrderID FROM BooksInOrder WHERE ProductID=?))))";
    String deleteOrdersSQL = "DELETE FROM Orders WHERE OrderID IN (SELECT OrderID FROM BooksInOrder WHERE ProductID=?)";
    String deleteProductsSQL = "DELETE FROM Products WHERE ProductID=?";

    try {
        connection.setAutoCommit(false);

        // 1. Delete from ReviewsAndRatings
        stReviewsAndRatings = connection.prepareStatement(deleteReviewsAndRatingsSQL);
        stReviewsAndRatings.setString(1, productID);
        stReviewsAndRatings.executeUpdate();

        // 2. Delete from HistoryBuyBook
        stHistoryBuyBook = connection.prepareStatement(deleteHistoryBuyBookSQL);
        stHistoryBuyBook.setString(1, productID);
        stHistoryBuyBook.executeUpdate();

        // 3. Delete from BooksInOrder
        stBooksInOrder = connection.prepareStatement(deleteBooksInOrderSQL);
        stBooksInOrder.setString(1, productID);
        stBooksInOrder.executeUpdate();

        // 4. Delete from TransactionHistory
        stTransactionHistory = connection.prepareStatement(deleteTransactionHistorySQL);
        stTransactionHistory.setString(1, productID);
        stTransactionHistory.executeUpdate();

        // 5. Delete from Orders
        stOrders = connection.prepareStatement(deleteOrdersSQL);
        stOrders.setString(1, productID);
        stOrders.executeUpdate();

        // 6. Delete from Products
        stProducts = connection.prepareStatement(deleteProductsSQL);
        stProducts.setString(1, productID);
        stProducts.executeUpdate();

        connection.commit();
    } catch (SQLException e) {
        if (connection != null) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        e.printStackTrace();
    } finally {
        if (stReviewsAndRatings != null) stReviewsAndRatings.close();
        if (stHistoryBuyBook != null) stHistoryBuyBook.close();
        if (stBooksInOrder != null) stBooksInOrder.close();
        if (stTransactionHistory != null) stTransactionHistory.close();
        if (stOrders != null) stOrders.close();
        if (stProducts != null) stProducts.close();
        connection.setAutoCommit(true);
    }
}


   public Product getProductById(String id) {
    Product product = null;
    String sql = "SELECT * FROM Products WHERE ProductID = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, id);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            product = new Product(rs.getString("ProductID"), rs.getString("ProductName"),
                    rs.getString("Description"), rs.getDouble("Price"), rs.getString("ImageURL"),
                    rs.getInt("StockQuantity"), rs.getInt("CategoryID"), rs.getString("Author"),
                    rs.getDate("DateAdded"), rs.getDouble("DiscountPercentage"));
        }
    } catch (SQLException e) {
        System.out.println("SQL Error: " + e.getMessage());
    }
    return product;
}
public int getStockQuantity(String productID) {
    int stockQuantity = -1; // Gán giá trị mặc định là -1, có nghĩa là không tìm thấy sản phẩm
    String sql = "SELECT StockQuantity FROM Products WHERE ProductID = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, productID);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            stockQuantity = rs.getInt("StockQuantity");
        }
    } catch (SQLException e) {
        System.out.println("SQL Error: " + e.getMessage());
    }
    return stockQuantity;
}
public void updateStockQuantity(String productID, int newQuantity) {
    String sql = "UPDATE Products SET StockQuantity=? WHERE ProductID=?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);

        st.setInt(1, newQuantity);
        st.setString(2, productID);

        st.executeUpdate();
    } catch (SQLException e) {
        System.out.println("SQL Error: " + e.getMessage());
    }
}

public String getProductNameById(String id) {
    String productName = null;
    String sql = "SELECT ProductName FROM Products WHERE ProductID = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, id);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            productName = rs.getString("ProductName");
        }
    } catch (SQLException e) {
        System.out.println("SQL Error: " + e.getMessage());
    }
    return productName;
}


    public static void main(String[] args) {
        ProductDAO u = new ProductDAO();
        List<Product> l = u.getAll();
        System.out.println(l.get(0).getProductName());
    }

}