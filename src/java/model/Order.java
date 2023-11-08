/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Administrator
 */
public class Order {
   
    
    private int OrderID;
    private int  UserID;
    private String DeliveryAddress;
    private String PhoneNumber;
    private String RecipientName;
    private String PaymentMethod;
    private double TotalPrice;
    private String OrderStatus;
    private String TimeBuy;

    public Order() {
    }

    public Order(int OrderID, int UserID, String DeliveryAddress, String PhoneNumber, String RecipientName, String PaymentMethod, double TotalPrice, String OrderStatus, String TimeBuy) {
        this.OrderID = OrderID;
        this.UserID = UserID;
        this.DeliveryAddress = DeliveryAddress;
        this.PhoneNumber = PhoneNumber;
        this.RecipientName = RecipientName;
        this.PaymentMethod = PaymentMethod;
        this.TotalPrice = TotalPrice;
        this.OrderStatus = OrderStatus;
        this.TimeBuy = TimeBuy;
    }

    public int getOrderID() {
        return OrderID;
    }

    public void setOrderID(int OrderID) {
        this.OrderID = OrderID;
    }

    public int getUserID() {
        return UserID;
    }

    public void setUserID(int UserID) {
        this.UserID = UserID;
    }

    public String getDeliveryAddress() {
        return DeliveryAddress;
    }

    public void setDeliveryAddress(String DeliveryAddress) {
        this.DeliveryAddress = DeliveryAddress;
    }

    public String getPhoneNumber() {
        return PhoneNumber;
    }

    public void setPhoneNumber(String PhoneNumber) {
        this.PhoneNumber = PhoneNumber;
    }

    public String getRecipientName() {
        return RecipientName;
    }

    public void setRecipientName(String RecipientName) {
        this.RecipientName = RecipientName;
    }

    public String getPaymentMethod() {
        return PaymentMethod;
    }

    public void setPaymentMethod(String PaymentMethod) {
        this.PaymentMethod = PaymentMethod;
    }

    public double getTotalPrice() {
        return TotalPrice;
    }

    public void setTotalPrice(double TotalPrice) {
        this.TotalPrice = TotalPrice;
    }

    public String getOrderStatus() {
        return OrderStatus;
    }

    public void setOrderStatus(String OrderStatus) {
        this.OrderStatus = OrderStatus;
    }

    public String getTimeBuy() {
        return TimeBuy;
    }

    public void setTimeBuy(String TimeBuy) {
        this.TimeBuy = TimeBuy;
    }
    
}
