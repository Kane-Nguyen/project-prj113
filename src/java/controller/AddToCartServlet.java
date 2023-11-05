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

/**
 *
 * @author tranq
 */
public class AddToCartServlet extends HttpServlet {

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
            out.println("<title>Servlet AddToCartServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddToCartServlet at " + request.getContextPath() + "</h1>");
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("productId");

        Cookie[] cookies = request.getCookies();
        String cartItems = "";
        String quantities = "";

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("cart")) {
                    cartItems = cookie.getValue();
                } else if (cookie.getName().equals("quantity")) {
                    quantities = cookie.getValue();
                }
            }
        }

        String[] productIds = cartItems.split(":");
        String[] quantityValues = quantities.split(":");
        boolean productExists = false;

        // Check if product already exists in cart
        for (int i = 0; i < productIds.length; i++) {
            if (productIds[i].equals(productId)) {
                int currentQuantity = Integer.parseInt(quantityValues[i]);
                currentQuantity++;
                quantityValues[i] = String.valueOf(currentQuantity);
                productExists = true;
                break;
            }
        }

        // If product doesn't exist in cart, add it
        if (!productExists) {
            cartItems = cartItems.isEmpty() ? productId : cartItems + ":" + productId;
            quantities = quantities.isEmpty() ? "1" : quantities + ":1";
        } else {
            // Update quantities string
            quantities = String.join(":", quantityValues);
        }

        Cookie cartCookie = new Cookie("cart", cartItems);
        Cookie quantityCookie = new Cookie("quantity", quantities);

        cartCookie.setMaxAge(24 * 60 * 60);
        quantityCookie.setMaxAge(24 * 60 * 60);

        response.addCookie(cartCookie);
        response.addCookie(quantityCookie);
        String method = request.getParameter("method");
        if(method.equals("index")){
            response.sendRedirect("index.jsp");
            return;
        }
        response.sendRedirect("detail.jsp?productId=" + productId);
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
