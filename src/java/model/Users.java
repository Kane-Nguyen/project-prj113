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
public class Users {


    /**
     * UserID INT IDENTITY(1,1) PRIMARY KEY, FullName VARCHAR(255), BirthDate
     * DATE, PhoneNumber VARCHAR(20), Email VARCHAR(255) UNIQUE, Password
     * VARCHAR(255), Address VARCHAR(255), RegistrationDate DATETIME DEFAULT
     * GETDATE(), UserRole VARCHAR(50)
     */

    private int userId;
    private String fullName;
    private Date birthDate;
    private String phoneNumber;
    private String email;
    private String passWord;
    private String address;
    private Date regisstrationDate;
    private String userRole;
    private String CartItems;
    private String SecretString;

    public Users() {
    }

    public class Login {

        private String fullName;
        private Date birthDate;
        private String phoneNumber;
        private String email;
        private String passWord;
        private String address;
        private String userRole;
        private String SecretString;

        public Login(String fullName, Date birthDate, String phoneNumber, String email, String passWord, String address, String userRole, String SecretString) {
            this.fullName = fullName;
            this.birthDate = birthDate;
            this.phoneNumber = phoneNumber;
            this.email = email;
            this.passWord = passWord;
            this.address = address;
            this.userRole = userRole;
            this.SecretString = SecretString;
        }

    }

    public Users(int userId, String fullName, Date birthDate, String phoneNumber, String email, String passWord, String address, Date regisstrationDate, String userRole, String CartItems, String SecretString) {
        this.userId = userId;
        this.fullName = fullName;
        this.birthDate = birthDate;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.passWord = passWord;
        this.address = address;
        this.regisstrationDate = regisstrationDate;
        this.userRole = userRole;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Date getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassWord() {
        return passWord;
    }

    public void setPassWord(String passWord) {
        this.passWord = passWord;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getRegisstrationDate() {
        return regisstrationDate;
    }

    public void setRegisstrationDate(Date regisstrationDate) {
        this.regisstrationDate = regisstrationDate;
    }

    public String getUserRole() {
        return userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public String getCartItems() {
        return CartItems;
    }

    public void setCartItems(String CartItems) {
        this.CartItems = CartItems;
    }

    public String getSecretString() {
        return SecretString;
    }

    public void setSecretString(String SecretString) {
        this.SecretString = SecretString;
    }

}
