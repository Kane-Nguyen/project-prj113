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
import java.util.List;

/**
 *
 * @author Asus
 */
public class DeleteCartServlet extends HttpServlet {

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
            out.println("<title>Servlet DeleteCartServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeleteCartServlet at " + request.getContextPath() + "</h1>");
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
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productIdToRemove = request.getParameter("productId");

        Cookie[] cookies = request.getCookies();
        String cartItems = "";
        String quantityItems = "";

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("cart".equals(cookie.getName())) {
                    cartItems = cookie.getValue();
                }
                if ("quantity".equals(cookie.getName())) {
                    quantityItems = cookie.getValue();
                }
            }
        }

        // Convert the cart and quantity strings to lists of product IDs and quantities
        List<String> productList = new ArrayList<>(Arrays.asList(cartItems.split(":")));
        List<String> quantityList = new ArrayList<>(Arrays.asList(quantityItems.split(":")));

        // Find the index of the product to remove from the list
        int indexToRemove = productList.indexOf(productIdToRemove);

        // Remove both the product and its corresponding quantity from the list
        if (indexToRemove != -1) {
            productList.remove(indexToRemove);
            quantityList.remove(indexToRemove);
        }

        // Update the cart and quantity cookies
        String updatedCartItems = String.join(":", productList);
        String updatedQuantityItems = String.join(":", quantityList);

        Cookie cartCookie = new Cookie("cart", updatedCartItems);
        Cookie quantityCookie = new Cookie("quantity", updatedQuantityItems);

        cartCookie.setMaxAge(24 * 60 * 60); // 1 day
        quantityCookie.setMaxAge(24 * 60 * 60); // 1 day

        response.addCookie(cartCookie);
        response.addCookie(quantityCookie);

        // Redirect or return something after the product has been removed
        response.sendRedirect("cart.jsp");
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
