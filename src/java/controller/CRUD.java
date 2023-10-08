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
@WebServlet(name = "admin", urlPatterns = {"/admin"})
public class CRUD extends HttpServlet {
    // Khởi tạo vị trí tìm kiếm với giá trị không hợp lệ

    int index = -1;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        ProductDAO p = new ProductDAO();
        List<Product> list = p.getAll();
        String id = request.getParameter("id");
        String action = request.getParameter("action");

        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).getProductId().equals(id)) {  // Giả sử getId() trả về Integer
                index = i;
                System.out.println(index);
                System.out.println("done");
                break;
            }
        }
        System.out.println(index);
        try ( PrintWriter out = response.getWriter()) {
            if (null == action) {
                // Default or unknown action
                out.println("Unknown or no action specified");
            } else {
                switch (action) {
                    case "edit":
                        out.println("<!DOCTYPE html>");
                        out.println("<html>");
                        out.println("<head>");
                        out.println("<meta charset='UTF-8'>");
                        out.println("<title>Edit Product</title>");
                        out.println("<style>");
                        out.println("body { font-family: Arial, sans-serif; }");
                        out.println("table { width: 100%; margin-top: 20px; }");
                        out.println("td { padding: 8px; }");
                        out.println("input[type='text'], input[type='number'], textarea { width: 100%; }");
                        out.println("</style>");
                        out.println("</head>");
                        out.println("<body>");
                        out.println("<h1>Edit Product</h1>");
                        out.println("<div id='editProductForm'>");
                        out.println("<form action='CRUD' method='post'>");
                        out.println("<table>");
                        out.println("<tr>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='productName'>Product Name</label></td>");
                        out.println("<td><input type='text' id='productName' name='productName' value='" + list.get(index).getProductName() + "'></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='description'>Description</label></td>");
                        out.println("<td><textarea id='description' name='description'>" + list.get(index).getDescription() + "</textarea></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='price'>Price</label></td>");
                        out.println("<td><input type='number' id='price' name='price' value='" + list.get(index).getPrice() + "'></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='discountPercentage'>Discount Percentage</label></td>");
                        out.println("<td><input type='number' id='discountPercentage' name='discountPercentage' value='" + list.get(index).getDiscountPercentage() + "'></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='imageURL'>Image URL</label></td>");
                        out.println("<td><input type='text' id='imageURL' name='imageURL' value='" + list.get(index).getImageURL() + "'></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='stockQuantity'>Stock Quantity</label></td>");
                        out.println("<td><input type='number' id='stockQuantity' name='stockQuantity' value='" + list.get(index).getStockQuantity() + "'></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='category'>Category</label></td>");
                        out.println("<td><input type='text' id='category' name='category' value='" + list.get(index).getCategory() + "'></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='manufacturer'>Manufacturer</label></td>");
                        out.println("<td><input type='text' id='manufacturer' name='manufacturer' value='" + list.get(index).getManufacturer() + "'></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><input type='text' id='method' name='method' value='edit' style='display:none'></td>");
                        out.println("<td><input type='text' id='id1' name='id1' value='" + list.get(index).getProductId() + "' style='display:none'></td>");
                        out.println("</table>");
                        out.println("<button type='submit'>Edit</button>");
                        out.println("</form>");
                        out.println("<form action='admin.jsp'>");
                        out.println("<button type='submit'>Back</button>");
                        out.println("</form>");
                        out.println("</div>");
                        out.println("</body>");
                        out.println("</html>");
                        break;
                    case "AddBook":
                        out.println("<!DOCTYPE html>");
                        out.println("<html>");
                        out.println("<head>");
                        out.println("<meta charset='UTF-8'>");
                        out.println("<title>Add Product</title>");
                        out.println("<style>");
                        out.println("body { font-family: Arial, sans-serif; }");
                        out.println("table { width: 100%; margin-top: 20px; }");
                        out.println("td { padding: 8px; }");
                        out.println("input[type='text'], input[type='number'], textarea { width: 100%; }");
                        out.println("</style>");
                        out.println("</head>");
                        out.println("<body>");
                        out.println("<h1>Add Product</h1>");
                        out.println("<div id='addProductForm'>");
                        out.println("<form action='CRUD' method='post'>");
                        out.println("<table>");
                        out.println("<tr>");
                        out.println("<td><label for='productName'>Product Name</label></td>");
                        out.println("<td><input type='text' id='productName' name='productName' required></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='description'>Description</label></td>");
                        out.println("<td><textarea id='description' name='description' required></textarea></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='price'>Price</label></td>");
                        out.println("<td><input type='number' id='price' name='price' step='0.01' required></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='discountpercentage'>Discount Percentage</label></td>");
                        out.println("<td><input type='number' id='discountPercentage' name='discountPercentage' step='0.01' required></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='imageURL'>Image URL</label></td>");
                        out.println("<td><input type='text' id='imageURL' name='imageURL' required></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='stockQuantity'>Stock Quantity</label></td>");
                        out.println("<td><input type='number' id='stockQuantity' name='stockQuantity' required></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='category'>Category</label></td>");
                        out.println("<td><input type='text' id='category' name='category' required></td>");
                        out.println("</tr>");
                        out.println("<tr>");
                        out.println("<td><label for='manufacturer'>Manufacturer</label></td>");
                        out.println("<td><input type='text' id='manufacturer' name='manufacturer' required></td>");
                        out.println("</tr>");
                        out.println("<td><input type='text' id='method' name='method'value='add' style='display:none'></td>");
                        out.println("</table>");
                        out.println("<button type='submit'>Add Product</button>");
                        out.println("</form>");
                        out.println("<br>");
                        out.println("<form action='admin.jsp'>");
                        out.println("<button type='submit'>Back</button>");
                        out.println("</form>");
                        out.println("</div>");
                        out.println("</body>");
                        out.println("</html>");
                        out.println("You chose to Add a Product");
                        break;

                }
            }

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
        String action = request.getParameter("action");
        String id = request.getParameter("id");
        if (action.equals("delete")) {
            {
                try {
                    ProductDAO p = new ProductDAO();
                    p.deleteProduct(id);
                    response.sendRedirect("admin.jsp");  // chuyển hướng người dùng về admin.jsp
                } catch (SQLException ex) {
                    // Xử lý ngoại lệ tại đây
                }
            }
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
        String category = request.getParameter("category");
        String manufacturer = request.getParameter("manufacturer");
        String method = request.getParameter("method");

        if ("add".equals(method)) {
            productDAO.addProduct(productName, description, price, discountpercentage, imageURL, stockQuantity, category, manufacturer);
        } else if ("edit".equals(method)) {
            productDAO.editProduct(productName, description, price, imageURL, stockQuantity, category, manufacturer, discountpercentage, id);
        }
        response.sendRedirect("admin.jsp");
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
