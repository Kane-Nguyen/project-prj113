<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@ page import="model.Order" %>
<%@ page import="dal.OrderDAO" %>
<%@page import="java.util.Calendar"%>
<%@ page import="java.net.URLEncoder" %>
<%@page import="java.util.ArrayList"%>
<%
 if (session == null || session.getAttribute("isLoggedIn") == null || 
 !(Boolean)session.getAttribute("isLoggedIn") || session.getAttribute("role") == null || 
 !session.getAttribute("role").equals("Admin")) {
        
        String originalURL = request.getRequestURI(); // Lấy URL hiện tại
        String queryString = request.getQueryString(); // Lấy query string từ URL (nếu có)
        
        if (queryString != null) {
            originalURL += "?" + queryString;
        }
        
        response.sendRedirect("login.jsp?redirect=" + URLEncoder.encode(originalURL, "UTF-8")); // Redirect to login page with the original URL
        return;
}
        OrderDAO o = new OrderDAO();
        

%>
<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Analysis</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.21/css/dataTables.bootstrap4.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.js"></script>
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.css">

        <style>
            @media (max-width: 768px) {

                .form-inline {
                    display: flex;
                    flex-direction: column
                }
                .form-group{
                    width: 100%;
                }

            }
        </style>
    </head>

    <body>
        <div class="container mt-4">
            <h1 class="text-center" style="color: red;">Analysis Book</h1>
            <div class="row justify-content-center">
                <form id="dateForm" action="AnalysisServlet" method="post" class="form-inline">
                    <div class="form-group mx-2">
                        <select name="day" id="day" class="form-control">
                            <option value="">Day</option>
                            <% for(int i = 1; i <= 31; i++) { %>
                            <option value="<%= i %>"><%= i %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group mx-2">
                        <select name="month" id="month" class="form-control">
                            <option value="">Month</option>
                            <% for(int i = 1; i <= 12; i++) { %>
                            <option value="<%= i %>"><%= String.format("%02d", i) %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group mx-2">
                        <select name="year" id="year" class="form-control">
                            <option value="">Year</option>
                            <% 
                                int currentYear = Calendar.getInstance().get(Calendar.YEAR);
                                for(int i = currentYear; i >= 2020; i--) { %>
                            <option value="<%= i %>"><%= i %></option>
                            <% } %>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary form-group">Submit</button>
                </form>
            </div>
            <div id="errorContainer" class="mt-3"></div>
            <div id="selectedDateDisplay" class="mt-3"></div>


            <%-- Retrieving the list of orders from the request --%>
            <%
                double totalValue = 0;
                int totalBooks = 0;
                List<Order> orders = (List<Order>)request.getAttribute("orders");
                if(orders != null && !orders.isEmpty()) {
            %>
            <div class="table-responsive mt-4">
                <table id="table1" class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>User ID</th>
                            <th>Delivery Address</th>
                            <th>Phone Number</th>
                            <th>Recipient Name</th>
                            <th>Payment Method</th>
                            <th>Total Price</th>
                            <th>Order Status</th>
                            <th>Time of Order</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                                for(Order order : orders) { 
                                        double orderTotalPrice = order.getTotalPrice(); 
                                        totalValue += orderTotalPrice;
                                        totalBooks += 1;
                                        
                        %>
                        <tr>
                            <td><%= order.getOrderID() %></td>
                            <td><%= order.getUserID() %></td>
                            <td><%= order.getDeliveryAddress() %></td>
                            <td><%= order.getPhoneNumber() %></td>
                            <td><%= order.getRecipientName() %></td>
                            <td><%= order.getPaymentMethod() %></td>
                            <td><%= order.getTotalPrice() %></td>
                            <td><%= order.getOrderStatus() %></td>
                            <td><%= order.getTimeBuy() %></td>
                        </tr>
                        <% } %>
                        <%  } else { %>
                    <div class="alert alert-warning" role="alert">
                        No data available for the selected date.
                    </div>
                    <%  }
                    %>
                    </tbody>
                    <tfoot>
                    </tfoot>
                </table>
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="total-section text-center">
                            <h4>Number of Books:</h4>
                            <p class="total-books"><%= totalBooks %></p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="total-section text-center">
                            <h4>Total Value:</h4>
                            <p class="total-value"><%= totalValue %></p>
                        </div>
                    </div>
                </div>

            </div>
            <!-- Bootstrap JS and other scripts -->
            <!-- ... existing script links ... -->
            <script>
                $(document).ready(function () {
                    $('#dateForm').submit(function (event) {
                        // Define the flag for form validation
                        var isValid = true;

                        // Clear any previous error messages
                        $('#errorContainer').empty();

                        // Get the values from the form
                        var day = $('#day').val();
                        var month = $('#month').val();
                        var year = $('#year').val();

                        // Only perform validation if one of the fields is selected
                        if (day || month || year) {
                            // Validate the day, month, and year selections
                            if (day && (!month || !year)) {
                                $('#errorContainer').append('<div class="error-message" style="color: red;">Day is selected without month or year.</div>');
                                isValid = false;
                            }
                            if (month && !year) {
                                $('#errorContainer').append('<div class="error-message" style="color: red;">Month is selected without year.</div>');
                                isValid = false;
                            }
                        }

                        // If there are any validation errors, prevent the form from submitting
                        if (!isValid) {
                            event.preventDefault();
                        } else {
                            // If no validation errors and no date selected, allow the form to submit to show all orders
                            if (!day && !month && !year) {
                                // No date selected, so the form submits and the servlet will handle showing all orders
                            } else {
                                // Code to format and display the selected date adjacent to the submit button
                                var selectedDate = 'Selected Date: ' + (day ? day : 'DD') + '/' + (month ? month : 'MM') + '/' + (year ? year : 'YYYY');
                                $('#selectedDateDisplay').text(selectedDate);
                            }
                        }
                    });
                });

                $(document).ready(function () {
                    $('#table1').DataTable();
                    responsive: true;
                });
            </script>
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
            <script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
            <script src="https://cdn.datatables.net/1.10.21/js/dataTables.bootstrap4.min.js"></script>
    </body>


</html>
