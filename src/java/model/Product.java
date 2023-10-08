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
public class Product {
    /**
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(255),
    BirthDate DATE,
    PhoneNumber VARCHAR(20),
    Email VARCHAR(255) UNIQUE,
    Password VARCHAR(255),
    Address VARCHAR(255),
    RegistrationDate DATETIME DEFAULT GETDATE(),
    UserRole VARCHAR(50)
     */
    
    private String ProductId;
    private int Discount;
    private String  ProductName;
    private String Description;
    private double Price;
    private String ImageURL;
    private int StockQuantity;
    private String Category;
    private String Manufacturer;
    private Date DateAdded;
    private double DiscountPercentage;

    public Product() {
    }

    public Product(String ProductId, int Discount, String ProductName, String Description, double Price, String ImageURL, int StockQuantity, String Category, String Manufacturer, Date DateAdded, double DiscountPercentage) {
        this.ProductId = ProductId;
        this.Discount = Discount;
        this.ProductName = ProductName;
        this.Description = Description;
        this.Price = Price;
        this.ImageURL = ImageURL;
        this.StockQuantity = StockQuantity;
        this.Category = Category;
        this.Manufacturer = Manufacturer;
        this.DateAdded = DateAdded;
        this.DiscountPercentage = DiscountPercentage;
    }

    public String getProductId() {
        return ProductId;
    }

    public void setProductId(String ProductId) {
        this.ProductId = ProductId;
    }

    public int getDiscount() {
        return Discount;
    }

    public void setDiscount(int Discount) {
        this.Discount = Discount;
    }

    public String getProductName() {
        return ProductName;
    }

    public void setProductName(String ProductName) {
        this.ProductName = ProductName;
    }

    public String getDescription() {
        return Description;
    }

    public void setDescription(String Description) {
        this.Description = Description;
    }

    public double getPrice() {
        return Price;
    }

    public void setPrice(double Price) {
        this.Price = Price;
    }

    public String getImageURL() {
        return ImageURL;
    }

    public void setImageURL(String ImageURL) {
        this.ImageURL = ImageURL;
    }

    public int getStockQuantity() {
        return StockQuantity;
    }

    public void setStockQuantity(int StockQuantity) {
        this.StockQuantity = StockQuantity;
    }

    public String getCategory() {
        return Category;
    }

    public void setCategory(String Category) {
        this.Category = Category;
    }

    public String getManufacturer() {
        return Manufacturer;
    }

    public void setManufacturer(String Manufacturer) {
        this.Manufacturer = Manufacturer;
    }

    public Date getDateAdded() {
        return DateAdded;
    }

    public void setDateAdded(Date DateAdded) {
        this.DateAdded = DateAdded;
    }

    public double getDiscountPercentage() {
        return DiscountPercentage;
    }

    public void setDiscountPercentage(double DiscountPercentage) {
        this.DiscountPercentage = DiscountPercentage;
    }

    public String getProductID() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    
    
    
    
}
