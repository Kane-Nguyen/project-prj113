package controller;

import dal.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import model.Order;

public class AnalysisServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AnalysisServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AnalysisServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dayString = request.getParameter("day");
        String monthString = request.getParameter("month");
        String yearString = request.getParameter("year");


        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders = new ArrayList<>();

        try {
            // Default to null if the parameter is not set or is empty
            Integer day = (dayString != null && !dayString.isEmpty()) ? Integer.parseInt(dayString) : null;
            Integer month = (monthString != null && !monthString.isEmpty()) ? Integer.parseInt(monthString) : null;
            Integer year = (yearString != null && !yearString.isEmpty()) ? Integer.parseInt(yearString) : null;

            if (day != null && month != null && year != null) {
                orders = orderDAO.getOrdersByDate(day, month, year);
            } else if (month != null && year != null) {
                orders = orderDAO.getOrdersByMonthAndYear(month, year);
            } else if (year != null) {
                orders = orderDAO.getOrdersByYear(year);
            } else {
                // If no date parameters are provided, retrieve all orders
                orders = orderDAO.getAllProcessing(); // Assuming this method exists in your OrderDAO
            }
        } catch (NumberFormatException e) {
            orders = new ArrayList<>();
        }

        // Set the orders and other attributes for the request
        request.setAttribute("selectedDay", dayString);
        request.setAttribute("selectedMonth", monthString);
        request.setAttribute("selectedYear", yearString);
        request.setAttribute("orders", orders);

        // Forward the request to the JSP page
        request.getRequestDispatcher("/analysis.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
