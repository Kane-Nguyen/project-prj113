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
import model.History;

/**
 *
 * @author Lenovo
 */
public class HistoryDAO extends DBContext {

    public List<History> getHistoryByYear(int year) {
        List<History> historyList = new ArrayList<>();
        String sql = "SELECT h.HistoryID, h.UserID, p.ProductName, p.Price, p.DiscountPercentage, h.TimeBuy "
                + "FROM HistoryBuyBook h "
                + "INNER JOIN Products p ON h.ProductID = p.ProductID "
                + "WHERE YEAR(h.TimeBuy) = ?";
        try ( PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, year);
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    History history = new History();
                    history.setHistoryID(rs.getInt("HistoryID"));
                    history.setUserID(rs.getInt("UserID"));
                    history.setProductName(rs.getString("ProductName"));
                    history.setPrice(rs.getDouble("Price"));
                    history.setDiscountPercentage(rs.getDouble("DiscountPercentage"));
                    history.setTimeBuy(rs.getString("TimeBuy"));
                    historyList.add(history);
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return historyList;
    }

    public List<History> getHistoryByMonthAndYear(int month, int year) {
        List<History> historyList = new ArrayList<>();
        String sql = "SELECT h.HistoryID, h.UserID, p.ProductName, p.Price, p.DiscountPercentage, h.TimeBuy "
                + "FROM HistoryBuyBook h "
                + "INNER JOIN Products p ON h.ProductID = p.ProductID "
                + "WHERE MONTH(h.TimeBuy) = ? AND YEAR(h.TimeBuy) = ?";
        try ( PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, month);
            st.setInt(2, year);
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    History history = new History();
                    history.setHistoryID(rs.getInt("HistoryID"));
                    history.setUserID(rs.getInt("UserID"));
                    history.setProductName(rs.getString("ProductName"));
                    history.setPrice(rs.getDouble("Price"));
                    history.setDiscountPercentage(rs.getDouble("DiscountPercentage"));
                    history.setTimeBuy(rs.getString("TimeBuy"));
                    historyList.add(history);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return historyList;
    }

    public List<History> getHistoryByDayMonthAndYear(int day, int month, int year) {
        List<History> historyList = new ArrayList<>();
        String sql = "SELECT h.UserID, h.HistoryID, p.ProductName, p.Price, p.DiscountPercentage, h.TimeBuy "
                + "FROM HistoryBuyBook h "
                + "INNER JOIN Products p ON h.ProductID = p.ProductID "
                + "WHERE DAY(h.TimeBuy) = ? AND MONTH(h.TimeBuy) = ? AND YEAR(h.TimeBuy) = ?";
        try ( PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, day);
            st.setInt(2, month);
            st.setInt(3, year);
            try ( ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    History history = new History();
                    history.setHistoryID(rs.getInt("HistoryID"));
                    history.setUserID(rs.getInt("UserID"));
                    history.setProductName(rs.getString("ProductName"));
                    history.setPrice(rs.getDouble("Price"));
                    history.setDiscountPercentage(rs.getDouble("DiscountPercentage"));
                    history.setTimeBuy(rs.getString("TimeBuy"));
                    historyList.add(history);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return historyList;
    }

    public int getTotalHistoryCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM HistoryBuyBook";
        try ( PreparedStatement st = connection.prepareStatement(sql)) {
            try ( ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return count;
    }

    public static void main(String[] args) {
        HistoryDAO u = new HistoryDAO();
        int id = 2;
        int k = 10;
        int y = 2023;
        List<History> n = u.getHistoryByMonthAndYear(k, y);
        System.out.println(n.get(0).getTimeBuy());
        System.out.println("Total history records: " + u.getTotalHistoryCount());
        System.out.println();
    }
}
