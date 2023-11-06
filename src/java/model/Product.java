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
   
    
    private String ProductId;
    private String  ProductName;
    private String Description;
    private double Price;
    private String ImageURL;
    private int StockQuantity;
    private int CategoryId;
    private String Author;
    private Date DateAdded;
    private double DiscountPercentage;

    public Product() {
    }

    public Product(String ProductId, String ProductName, String Description, double Price, String ImageURL, int StockQuantity, int CategoryId, String Author, Date DateAdded, double DiscountPercentage) {
        this.ProductId = ProductId;
        this.ProductName = ProductName;
        this.Description = Description;
        this.Price = Price;
        this.ImageURL = ImageURL;
        this.StockQuantity = StockQuantity;
        this.CategoryId = CategoryId;
        this.Author = Author;
        this.DateAdded = DateAdded;
        this.DiscountPercentage = DiscountPercentage;
    }

    public String getProductId() {
        return ProductId;
    }

    public void setProductId(String ProductId) {
        this.ProductId = ProductId;
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

    public int getCategoryId() {
        return CategoryId;
    }

    public void setCategoryId(int CategoryId) {
        this.CategoryId = CategoryId;
    }

    public String getAuthor() {
        return Author;
    }

    public void setAuthor(String Author) {
        this.Author = Author;
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

    
    
}
