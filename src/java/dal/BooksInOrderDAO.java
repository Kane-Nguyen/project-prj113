/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import java.util.List;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.BooksInOrder;

/**
 *
 * @author Administrator
 */
public class BooksInOrderDAO extends DBContext {
    // Doc tat ca các bang ghi tu Users

    public List<BooksInOrder> getAll() {
        List<BooksInOrder> list = new ArrayList<>();
        String sql = "select * from BooksInOrder";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                BooksInOrder p = new BooksInOrder(rs.getInt("RecordID"), rs.getInt("OrderID"),
                        rs.getString("ProductID"), rs.getInt("Quantity"));
                list.add(p);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<BooksInOrder> getBookById(int id) {
        List<BooksInOrder> list = new ArrayList<>();
        String sql = "select * from BooksInOrder where OrderID=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id); // Set the parameter before executing the query
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                BooksInOrder p = new BooksInOrder(rs.getInt("RecordID"), rs.getInt("OrderID"),
                        rs.getString("ProductID"), rs.getInt("Quantity"));
                list.add(p);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public void insertBooksInOrder(int OrderID, String ProductID, int Quantity) {

        String sql = "INSERT INTO BooksInOrder (OrderID, ProductID, Quantity) VALUES (?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, OrderID);
            st.setNString(2, ProductID);
            st.setInt(3, Quantity);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }

    }

    public static void main(String[] args) {
        BooksInOrderDAO u = new BooksInOrderDAO();
        List<BooksInOrder> l = u.getBookById(1);
        System.out.println(l.get(0).getProductID());

    }

}
