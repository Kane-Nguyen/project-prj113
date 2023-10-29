/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 *
 * @author Asus
 */
public class UpdateQuantityServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateQuantityServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateQuantityServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private static Map<String, Integer> cartItems = new HashMap<>();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productId = request.getParameter("productId");
        String action = request.getParameter("action");
        Cookie[] cookies = request.getCookies();
        String cookieCartItems = "";  // Renamed to avoid shadowing
        String cookieQuantityItems = "";

        // Logging to check the values
        System.out.println("Received productId: " + productId);
        System.out.println("Received action: " + action);

        // Existing code for reading cookies...
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("cart".equals(cookie.getName())) {
                    cookieCartItems = cookie.getValue();
                } else if ("quantity".equals(cookie.getName())) {
                    cookieQuantityItems = cookie.getValue();
                }
            }
        }

        List<String> productList = new ArrayList<>(Arrays.asList(cookieCartItems.split(":")));
        List<String> quantityList = new ArrayList<>(Arrays.asList(cookieQuantityItems.split(":")));

        int indexToUpdate = productList.indexOf(productId);
        if (indexToUpdate == -1) {
            System.out.println("Product not found in the cart");
            return;
        }

        int newQuantity = 1; // Default quantity

        if ("increase".equals(action)) {
            newQuantity = Integer.parseInt(quantityList.get(indexToUpdate)) + 1;
        } else if ("decrease".equals(action)) {
            newQuantity = Integer.parseInt(quantityList.get(indexToUpdate)) - 1;
            // Ensure that the quantity never goes below 0
            if (newQuantity <= 1) {
                newQuantity = 1;
            }
        }

        // Update the quantity in the list
        quantityList.set(indexToUpdate, String.valueOf(newQuantity));

        // Update the cookies
        String updatedCartItems = String.join(":", productList);
        String updatedQuantityItems = String.join(":", quantityList);

        Cookie cartCookie = new Cookie("cart", updatedCartItems);
        Cookie quantityCookie = new Cookie("quantity", updatedQuantityItems);

        cartCookie.setMaxAge(24 * 60 * 60); // 1 day
        quantityCookie.setMaxAge(24 * 60 * 60); // 1 day

        response.addCookie(cartCookie);
        response.addCookie(quantityCookie);

        // Send newQuantity as plain text
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(String.valueOf(newQuantity));
       

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
