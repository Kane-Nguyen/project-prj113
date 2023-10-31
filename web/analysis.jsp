<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dal.HistoryDAO"%>
<%@page import="model.History"%>
<%@page import="java.util.Calendar"%>
<%@ page import="java.net.URLEncoder" %>
<%
 if (session == null || session.getAttribute("isLoggedIn") == null || 
 !(Boolean)session.getAttribute("isLoggedIn")||session.getAttribute("role") == null || !session.getAttribute("role").equals("Admin")) {
        
        String originalURL = request.getRequestURI(); // Lấy URL hiện tại
        String queryString = request.getQueryString(); // Lấy query string từ URL (nếu có)
        
        if (queryString != null) {
            originalURL += "?" + queryString;
        }
        
        response.sendRedirect("login.jsp?redirect=" + URLEncoder.encode(originalURL, "UTF-8")); // Redirect to login page with the original URL
        return;
}

%>
<!DOCTYPE html>
<html>
    <head>

        <title>Analysis</title>
        <!-- Bootstrap CSS -->
        <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <!-- DataTables CSS -->
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.css">
        <!-- FontAwesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
        <!-- jQuery -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
        <!-- DataTables JS -->
        <script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.js"></script>
        <!-- Bootstrap JS -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
                padding: 20px;
            }

            .custom-container {
                background-color: #ffffff;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            }

            .custom-header {
                margin-top: 20px;
                margin-bottom: 20px;
                color: #17a2b8;
            }

            .custom-table {
                width: 100%;
                border-collapse: collapse;
                box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            }

            .custom-table th, .custom-table td {
                border: 1px solid #e0e0e0;
                padding: 10px 15px;
                text-align: left;
            }

            .custom-table th {
                background-color: #f5f5f5;
                color: #555;
            }

            .custom-table tbody tr:hover {
                background-color: #f6f6f6;
            }

            .custom-table tbody tr:nth-child(odd) {
                background-color: #fafafa;
            }

            .custom-form {
                margin-bottom: 20px;
            }

            .custom-select, .custom-button {
                margin-right: 10px;
                padding: 5px 10px;
            }

            .custom-button {
                background-color: #007BFF;
                color: #FFF;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: 0.3s;
            }

            .custom-button:hover {
                background-color: #0056b3;
            }
            .form-group {
                display: inline-block;
                margin-right: 20px;
            }

            .select-inline {
                display: inline-block;
                width: auto;
            }

        </style>
    </head>

    <body>

        <div class="custom-container">
            <%   
        // Lấy thông tin từ form
        String monthParam = request.getParameter("month");
        String yearParam = request.getParameter("year");
        String dayParam = request.getParameter("day");
            
            
                Integer selectedMonth = (Integer) request.getAttribute("selectedMonth");
                Integer selectedYear = (Integer) request.getAttribute("selectedYear");
                Integer selectedDay = (Integer) request.getAttribute("selectedDay");          
                String monthString = (selectedMonth != null) ? " Month : " + selectedMonth + " - " : "";
                String yearString = (selectedYear != null) ? " Year: " + selectedYear : "";
                String dayString = (selectedDay != null) ? "Day : " + selectedDay + " - " : " ";      
                Calendar now = Calendar.getInstance();       
                if (selectedMonth == null) {
                    selectedMonth = now.get(Calendar.MONTH) + 1;
                }     
                if (selectedYear == null) {
                    selectedYear = now.get(Calendar.YEAR);
                }        
                if (selectedDay == null) {
                    selectedDay = now.get(Calendar.DAY_OF_MONTH);
                }
            %>

            <form action="AnalysisServlet" method="post"  class="custom-form">
                <label for="day">Select Day:</label>
                <select name="day" class="form-control select-inline">
                    <option value="">All</option>
                    <% for(int i = 1; i <= 31; i++) { %>
                    <option value="<%= i %>" <%= (selectedDay != null && selectedDay == i) ? "selected" : "" %>> <%= i %> </option>
                    <% } %>
                </select>
                
                <label for="month">Select Month:</label>
                <select name="month" class="form-control select-inline">
                    <option value="">All</option>
                    <% 
                       for(int i = 1; i <= 12; i++) { 
                    %>
                    <option value="<%= i %>" <%= (selectedMonth != null && selectedMonth == i) ? "selected" : "" %>> <%= i %> </option>
                    <% } %>
                </select>


                <label for="year">Select Year:</label>
                <select name="year" class="form-control select-inline">
                    <% 
                       for(int i = 2020; i <= 2023; i++) { 
                    %>
                    <option value="<%= i %>" <%= (selectedYear != null && selectedYear == i) ? "selected" : "" %>> <%= i %> </option>
                    <% } %>
                </select>
                <div class="select-inline">
                    <input type="submit" value="Show" class="btn btn-primary"> 
                </div>
            </form>

            <h2 class="text-center custom-header">Analysis for <%= dayString %><%= monthString %><%= yearString %></h2>

            <table id="table1" class="custom-table">
                <thead>
                    <tr>
                        <th>Number</th>
                        <th>UserID</th>
                        <th>Product Name</th>
                        <th>Price</th>
                        <th>Discount Percentage</th>
                        <th>Sale price</th>
                        <th>Time Buy</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        double totalRevenue = 0;
                        List<History> histories = (List<History>) request.getAttribute("histories");
                        if(histories != null && !histories.isEmpty()) {
                            for(History history : histories) {
                                double salePrice = history.getPrice() * (1 - history.getDiscountPercentage()/100);
                                totalRevenue += salePrice;
                    %>
                    <tr>
                        <td><%= history.getHistoryID() %></td>
                        <td><%= history.getUserID() %></td>
                        <td><%= history.getProductName() %></td>
                        <td><%= history.getPrice() %></td>
                        <td><%= history.getDiscountPercentage() %></td>
                        <td><%= salePrice %></td>
                        <td><%= history.getTimeBuy() %></td>
                    </tr>
                    <% 
                            }
                        } else {
                    %>
                    <tr>
                        <td style="text-align: center" colspan="7">No data available for the selected month, year or day.</td>
                    </tr>
                    <% 
                        }
                    %>
                </tbody>
                <tfoot>
                    <!-- You can put aggregate information here if needed -->
                </tfoot>
            </table>




            <% if (histories != null && !histories.isEmpty()) { %>
            <p><strong>Total books sold this (<%= dayString %><%= monthString %><%= yearString %>): </strong> <%= histories.size() %> books</p>
            <p><strong>Total Price in (<%= dayString %><%= monthString %><%= yearString %>): </strong> <%= totalRevenue %> VND</p>
            <% } else { %>
            <p><strong>Total books sold this  (<%= dayString %><%= monthString %><%= yearString %>): </strong> 0</p>
            <p><strong>Total Price in (<%= dayString %><%= monthString %><%= yearString %>): </strong> 0</p>
            <% } %>
        </div>

        <script>
            $(document).ready(function () {
                $('#table1').DataTable();
            });
        </script>

    </body>

</html>
