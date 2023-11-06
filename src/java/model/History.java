/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */
public class History {

    private int historyID;
    private int userID;
    private int productID;
    private String productName;
    private double price;
    private double discountPercentage;
    private String timeBuy;

    public History(int historyID, int userID, int productID, String productName, double price, double discountPercentage, String timeBuy) {
        this.historyID = historyID;
        this.userID = userID;
        this.productID = productID;
        this.productName = productName;
        this.price = price;
        this.discountPercentage = discountPercentage;
        this.timeBuy = timeBuy;
    }

    public History() {
    }

    public int getHistoryID() {
        return historyID;
    }

    public void setHistoryID(int historyID) {
        this.historyID = historyID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public String getTimeBuy() {
        return timeBuy;
    }

    public void setTimeBuy(String timeBuy) {
        this.timeBuy = timeBuy;
    }

}
