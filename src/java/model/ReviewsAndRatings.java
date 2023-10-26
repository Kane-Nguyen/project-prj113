/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Lenovo
 */
public class ReviewsAndRatings {

    private int reviewID;
    private int userID;
    private String productID;
    private String comment;
    private int rating;
    private String datePosted;

    public ReviewsAndRatings() {
    }

    public ReviewsAndRatings(int reviewID, int userID, String productID, String comment, int rating, String datePosted) {
        this.reviewID = reviewID;
        this.userID = userID;
        this.productID = productID;
        this.comment = comment;
        this.rating = rating;
        this.datePosted = datePosted;
    }

    // Getter và Setter cho các trường dữ liệu

    public int getReviewID() {
        return reviewID;
    }

    public void setReviewID(int reviewID) {
        this.reviewID = reviewID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getProductID() {
        return productID;
    }

    public void setProductID(String productID) {
        this.productID = productID;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getDatePosted() {
        return datePosted;
    }

    public void setDatePosted(String datePosted) {
        this.datePosted = datePosted;
    }
}


