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

    public boolean updateOrderStatus(int id, String orderStatus) {
        String sql = "UPDATE Orders SET OrderStatus = ? WHERE OrderID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);

            st.setString(1, orderStatus);
            st.setInt(2, id);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
            return false;
        }
    }

    public boolean deleteProductAndRelatedData(int OrderID) {
        PreparedStatement stTransactionHistory = null;
        PreparedStatement stOrders = null;
        PreparedStatement stBookInOrder = null;

        String deleteBookInOrderSQL = "DELETE FROM BooksInOrder WHERE OrderID=?";
        String deleteHistoryBuyBookSQL = "DELETE FROM TransactionHistory WHERE OrderID=?";
        String deleteOrderSQL = "DELETE FROM Orders WHERE OrderID=?";

        try {
            connection.setAutoCommit(false);

            // 1. Delete from HistoryBuyBook
            stBookInOrder = connection.prepareStatement(deleteBookInOrderSQL);
            stBookInOrder.setInt(1, OrderID);
            stBookInOrder.executeUpdate();

            stTransactionHistory = connection.prepareStatement(deleteHistoryBuyBookSQL);
            stTransactionHistory.setInt(1, OrderID);
            stTransactionHistory.executeUpdate();

            // 2. Delete from Orders
            stOrders = connection.prepareStatement(deleteOrderSQL);
            stOrders.setInt(1, OrderID);
            stOrders.executeUpdate();

            // If both deletes are successful, commit the transaction
            connection.commit();
            return true; // Return true if the operation was successful
        } catch (SQLException e) {
            // Log the SQLException
            e.printStackTrace(); // This prints the stack trace to the server logs
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    // Log the exception that occurred during the rollback
                    ex.printStackTrace(); // This prints the stack trace to the server logs
                }
            }
            return false; // Return false if there was an exception and a rollback occurred
        } finally {
            try {
                if (stTransactionHistory != null) {
                    stTransactionHistory.close();
                }
                if (stOrders != null) {
                    stOrders.close();
                }
                if (stBookInOrder != null) {
                    stBookInOrder.close();
                }
                if (connection != null) {
                    connection.setAutoCommit(true);
                }
            } catch (SQLException e) {
                // Log the exception that occurred during cleanup
                e.printStackTrace(); // This prints the stack trace to the server logs
            }
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
                        rs.getString("PaymentMethod"), rs.getDouble("TotalPrice"), rs.getString("OrderStatus"), rs.getString("TimeBuy"));
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
                        rs.getString("PaymentMethod"), rs.getDouble("TotalPrice"), rs.getString("OrderStatus"), rs.getString("TimeBuy"));
                list.add(p);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
    
    public List<Order> getAllShipped() {
        List<Order> list = new ArrayList<>();
        String sql = "select * from Orders where OrderStatus = 'Shipped'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Order p = new Order(rs.getInt("OrderID"), rs.getInt("UserID"),
                        rs.getString("DeliveryAddress"), rs.getString("PhoneNumber"), rs.getString("RecipientName"),
                        rs.getString("PaymentMethod"), rs.getDouble("TotalPrice"), rs.getString("OrderStatus"), rs.getString("TimeBuy"));
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
            st.setString(7, OrderStatus);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }

    }

    public List<Order> getOrdersByDate(int day, int month, int year) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE DAY(TimeBuy) = ? AND MONTH(TimeBuy) = ? AND YEAR(TimeBuy) = ? and OrderStatus = 'Shipped'";
        try ( PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, day);
            st.setInt(2, month);
            st.setInt(3, year);
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Order p = new Order(rs.getInt("OrderID"), rs.getInt("UserID"),
                            rs.getString("DeliveryAddress"), rs.getString("PhoneNumber"), rs.getString("RecipientName"),
                            rs.getString("PaymentMethod"), rs.getDouble("TotalPrice"), rs.getString("OrderStatus"), rs.getString("TimeBuy"));
                    orders.add(p);
                }
            }

        } catch (SQLException e) {
            System.out.println(e);
        }
        return orders;
    }

    public List<Order> getOrdersByMonthAndYear(int month, int year) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE MONTH(TimeBuy) = ? AND YEAR(TimeBuy) = ? and OrderStatus = 'Shipped'";
        try ( PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, month);
            st.setInt(2, year);
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Order p = new Order(rs.getInt("OrderID"), rs.getInt("UserID"),
                            rs.getString("DeliveryAddress"), rs.getString("PhoneNumber"), rs.getString("RecipientName"),
                            rs.getString("PaymentMethod"), rs.getDouble("TotalPrice"), rs.getString("OrderStatus"), rs.getString("TimeBuy"));
                    orders.add(p);
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return orders;
    }

    public List<Order> getOrdersByYear(int year) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE YEAR(TimeBuy) = ? and OrderStatus = 'Shipped' ";
        try ( PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, year);
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Order p = new Order(rs.getInt("OrderID"), rs.getInt("UserID"),
                            rs.getString("DeliveryAddress"), rs.getString("PhoneNumber"), rs.getString("RecipientName"),
                            rs.getString("PaymentMethod"), rs.getDouble("TotalPrice"), rs.getString("OrderStatus"), rs.getString("TimeBuy"));
                    orders.add(p);
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return orders;
    }

   

    public static void main(String[] args) throws SQLException {
        OrderDAO u = new OrderDAO();
        System.out.println(u.getAll().get(0).getTimeBuy());

    }
}
    