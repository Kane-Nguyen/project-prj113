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
        // Get the required parameters
        String productId = request.getParameter("productId");
        String action = request.getParameter("action");
        String stockStr = request.getParameter("stock");  // Get the stock value from the client

        if (productId == null || action == null || stockStr == null) {
            // Handle error: missing parameters
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int stock;
        try {
            stock = Integer.parseInt(stockStr);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Cookie[] cookies = request.getCookies();
        String cartItems = "";
        String quantities = "";

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("cart".equals(cookie.getName())) {
                    cartItems = cookie.getValue();
                } else if ("quantity".equals(cookie.getName())) {
                    quantities = cookie.getValue();
                }
            }
        }

        List<String> cartItemList = new ArrayList<>(Arrays.asList(cartItems.split(":")));
        List<String> quantityList = new ArrayList<>(Arrays.asList(quantities.split(":")));

        int indexToUpdate = cartItemList.indexOf(productId);
        if (indexToUpdate == -1) {
            // Handle error: product not in the cart
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        int newQuantity = Integer.parseInt(quantityList.get(indexToUpdate));
        if ("increase".equals(action)) {
            if (newQuantity + 1 > stock) {
                // Handle error: quantity exceeds stock
                response.setStatus(HttpServletResponse.SC_CONFLICT);  // 409 Conflict might be a good status to indicate this issue
                return;
            }
            newQuantity += 1;
        } else if ("decrease".equals(action)) {
            newQuantity -= 1;
            // Ensure that the quantity never goes below 1
            if (newQuantity < 1) {
                newQuantity = 1;
            }
        } else {
            // Handle error: invalid action
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // Update the quantity in the cookie
        quantityList.set(indexToUpdate, String.valueOf(newQuantity));
        String updatedQuantities = String.join(":", quantityList);
        Cookie quantityCookie = new Cookie("quantity", updatedQuantities);
        quantityCookie.setMaxAge(60 * 60 * 24 * 7);  // 1 week expiry
        response.addCookie(quantityCookie);

        // Send the new quantity back as the response
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
