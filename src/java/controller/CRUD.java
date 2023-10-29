/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.ProductDAO;
import jakarta.servlet.annotation.WebServlet;
import static java.lang.System.out;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Product;

/**
 *
 * @author tranq
 */
public class CRUD extends HttpServlet {
    // Khởi tạo vị trí tìm kiếm với giá trị không hợp lệ

    int index = -1;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

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
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        if (action.equals("delete")) {
            {
                try {
                    ProductDAO p = new ProductDAO();
                    p.deleteProductAndRelatedData(id);
                    response.sendRedirect("admin.jsp");  // chuyển hướng người dùng về admin.jsp
                } catch (SQLException ex) {
                    // Xử lý ngoại lệ tại đây
                }
            }
        } else if ("edit".equals(action)) {
            request.getRequestDispatcher("edit.jsp").forward(request, response);
        } else if ("add".equals(action)) {
            request.getRequestDispatcher("Addbook.jsp").forward(request, response);
        }

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
        String id = request.getParameter("id1");
        ProductDAO productDAO = new ProductDAO();

        String productName = request.getParameter("productName");
        String description = request.getParameter("description");
        double discountpercentage = Double.parseDouble(request.getParameter("discountPercentage"));
        double price = Double.parseDouble(request.getParameter("price"));
        String imageURL = request.getParameter("imageURL");
        int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
       int category = Integer.parseInt(request.getParameter("CategoryId"));
        String Author = request.getParameter("Author");
        String method = request.getParameter("method");

        try {
            if ("add".equals(method)) {
                productDAO.addProduct(productName, description, price, discountpercentage, imageURL, stockQuantity, category, Author);           
                response.sendRedirect("admin.jsp");
            } else if ("edit".equals(method)) {
                productDAO.editProduct(productName, description, price, imageURL, stockQuantity, category, Author, discountpercentage, id);
                response.sendRedirect("admin.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();        
            String errorMessage = "Có lỗi xảy ra. Vui lòng thử lại sau.";
            request.setAttribute("errorMessage", errorMessage);
            if ("add".equals(method)) {
                request.getRequestDispatcher("add.jsp").forward(request, response);
            } else if ("edit".equals(method)) {
                request.getRequestDispatcher("edit.jsp?id=" + id).forward(request, response);
            }
        }

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
