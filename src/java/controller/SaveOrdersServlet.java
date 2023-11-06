/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author tranq
 */
public class SaveOrdersServlet extends HttpServlet {

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
            out.println("<title>Servlet SaveOrdersServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SaveOrdersServlet at " + request.getContextPath() + "</h1>");
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
        String[] orderIDs = request.getParameterValues("orderID");
        String[] userIDs = request.getParameterValues("userID");
        String[] deliveryAddresses = request.getParameterValues("deliveryAddress");
        String[] phoneNumbers = request.getParameterValues("phoneNumber");
        String[] recipientNames = request.getParameterValues("recipientName");
        String[] paymentMethods = request.getParameterValues("paymentMethod");
        String[] totalPrices = request.getParameterValues("totalPrices");
        String[] orderStatuses = request.getParameterValues("orderStatus");
       
        String method = request.getParameter("method");
         OrderDAO o = new OrderDAO();
        if(method.equals("Cancel")){
             int iddelete= Integer.parseInt(request.getParameter("iddelete"));
            o.updateOrderStatus(iddelete,"Cancel");
            System.out.println("Cancel Done");
            response.sendRedirect("paid.jsp");
            return;
        }else if(method.equals("delete")){
             int iddelete= Integer.parseInt(request.getParameter("iddelete"));
               o.deleteProductAndRelatedData(iddelete);
               System.out.println("delete Done");
               response.sendRedirect("payment.jsp");
            return;
        }
       
        boolean allUpdatesSuccessful = true;
        for (int i = 0; i < orderIDs.length; i++) {
            int orderIdInt = Integer.parseInt(orderIDs[i]);
            int userIdInt = Integer.parseInt(userIDs[i]);
            double totalPriceDouble = Double.parseDouble(totalPrices[i]);
            boolean isSuccessful = o.updateOrder(orderIdInt, userIdInt, deliveryAddresses[i], phoneNumbers[i], recipientNames[i], paymentMethods[i], orderStatuses[i], totalPriceDouble);
            if (!isSuccessful) {
                allUpdatesSuccessful = false;
                System.out.println("Update failed for Order ID: " + orderIdInt);
            }
        }

        if (allUpdatesSuccessful) {
            System.out.println("All updates done");
            response.sendRedirect("payment.jsp");
        } else {
            System.out.println("Some updates failed");
            request.setAttribute("errorMessage", "Some updates failed. Please try again.");
            request.getRequestDispatcher("payment.jsp").forward(request, response);
        }

        response.setStatus(HttpServletResponse.SC_OK);
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
