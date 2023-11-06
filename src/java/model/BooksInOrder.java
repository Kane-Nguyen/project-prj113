/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;


/**
 *
 * @author Administrator
 */
public class BooksInOrder {
   
    
    private int RecordID;
    private int  OrderID;
    private String ProductID;
    private int Quantity;


    public BooksInOrder() {
    }

    public BooksInOrder(int RecordID, int OrderID, String ProductID, int Quantity) {
        this.RecordID = RecordID;
        this.OrderID = OrderID;
        this.ProductID = ProductID;
        this.Quantity = Quantity;
    }

    public int getRecordID() {
        return RecordID;
    }

    public void setRecordID(int RecordID) {
        this.RecordID = RecordID;
    }

    public int getOrderID() {
        return OrderID;
    }

    public void setOrderID(int OrderID) {
        this.OrderID = OrderID;
    }

    public String getProductID() {
        return ProductID;
    }

    public void setProductID(String ProductID) {
        this.ProductID = ProductID;
    }

    public int getQuantity() {
        return Quantity;
    }

    public void setQuantity(int Quantity) {
        this.Quantity = Quantity;
    }

   


    
}
