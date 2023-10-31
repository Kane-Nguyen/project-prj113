package controller;

import dal.HistoryDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.List;
import model.History;

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
        String month_raw = request.getParameter("month");
        int year = Integer.parseInt(request.getParameter("year"));
        String day_raw = request.getParameter("day");
        
        HistoryDAO historyDAO = new HistoryDAO();
        List<History> histories;
        
        if (day_raw != null && !day_raw.isEmpty() && month_raw != null && !month_raw.isEmpty()) {
            int day = Integer.parseInt(day_raw);
            int month = Integer.parseInt(month_raw);
            histories = historyDAO.getHistoryByDayMonthAndYear(day, month, year);
            request.setAttribute("selectedDay", day);
            request.setAttribute("selectedMonth", month);
        } else if (month_raw != null && !month_raw.isEmpty()) {
            int month = Integer.parseInt(month_raw);
            histories = historyDAO.getHistoryByMonthAndYear(month, year);
            request.setAttribute("selectedMonth", month);
        } else {
            histories = historyDAO.getHistoryByYear(year);
        }
        
        request.setAttribute("selectedYear", year);
        request.setAttribute("histories", histories);

        request.getRequestDispatcher("analysis.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
