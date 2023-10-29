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
import model.Order;

/**
 *
 * @author Administrator
 */
public class OrderDAO extends DBContext {
    // Doc tat ca các bang ghi tu Users
public boolean updateOrder(int orderID, int userID, String deliveryAddress, String phoneNumber, String recipientName, String paymentMethod, String orderStatus, double totalPrice) {
    String sql = "UPDATE Orders SET UserID = ?, DeliveryAddress = ?, PhoneNumber = ?, RecipientName = ?, PaymentMethod = ?, OrderStatus = ?, TotalPrice = ? WHERE OrderID = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        
        st.setInt(1, userID);
        st.setString(2, deliveryAddress);
        st.setString(3, phoneNumber);
        st.setString(4, recipientName);
        st.setString(5, paymentMethod);
        st.setString(6, orderStatus);
        st.setDouble(7, totalPrice);
        st.setInt(8, orderID); // Điều kiện WHERE dựa trên orderID

        return st.executeUpdate() > 0;
    } catch (SQLException e) {
        System.out.println(e);
        return false;
    }
}

   public List<Order> getById(int id) {
    List<Order> list = new ArrayList<>();
    String sql = "select * from Orders where UserID=?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setInt(1, id); // Set the parameter before executing the query
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            Order p = new Order(rs.getInt("OrderID"), rs.getInt("UserID"),
                    rs.getString("DeliveryAddress"), rs.getString("PhoneNumber"), rs.getString("RecipientName"),
                    rs.getString("PaymentMethod"), rs.getDouble("TotalPrice"), rs.getString("OrderStatus"));               
            list.add(p);
        }
    } catch (SQLException e) {
        System.out.println(e);
    }
    return list;
}

    public List<Order> getAll() {
        List<Order> list = new ArrayList<>();
        String sql = "select * from Orders";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Order p = new Order(rs.getInt("OrderID"), rs.getInt("UserID"),
                        rs.getString("DeliveryAddress"), rs.getString("PhoneNumber"), rs.getString("RecipientName"),
                        rs.getString("PaymentMethod"), rs.getDouble("TotalPrice"), rs.getString("OrderStatus"));               
                list.add(p);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
public int getLatestOrderID() {
    String sql = "SELECT TOP 1 OrderID FROM Orders ORDER BY OrderID DESC";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return rs.getInt("OrderID");
        }
    } catch (SQLException e) {
        System.out.println(e);
    }
    return -1;  // Return -1 if unsuccessful
}

    public void addOrder(int UserID, String deliveryAddress, String phoneNumber, String recipientName, String paymentMethod, double totalPrice, String OrderStatus) {

        String sql = "INSERT INTO Orders (UserID, DeliveryAddress, PhoneNumber, RecipientName, PaymentMethod, TotalPrice, OrderStatus) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, UserID);
            st.setNString(2, deliveryAddress);
            st.setString(3, phoneNumber);
            st.setString(4, recipientName);
            st.setString(5, paymentMethod);
            st.setDouble(6, totalPrice);
            st.setString(7,OrderStatus );
           st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }

    }


    public static void main(String[] args) {
        OrderDAO u = new OrderDAO();
        int id = 1;
        List<Order> l = u.getById(id);
        System.out.println(l.get(0).getOrderID());
    }

}
