<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="dal.OrderDAO"%>
<%@page import="model.Order"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
String ordersJSON = request.getParameter("orders");
JSONArray jsonArray = new JSONArray(ordersJSON);
OrderDAO dao = new OrderDAO();

for (int i = 0; i < jsonArray.length(); i++) {
    JSONObject jsonOrder = jsonArray.getJSONObject(i);
    Order order = new Order();

    // Lấy thông tin từ JSON object và set vào model
    order.setOrderID(jsonOrder.getInt("orderID"));
    order.setUserID(jsonOrder.getInt("userID"));
    order.setDeliveryAddress(jsonOrder.getString("deliveryAddress"));
    order.setPhoneNumber(jsonOrder.getString("phoneNumber"));
    order.setRecipientName(jsonOrder.getString("recipientName"));
    order.setPaymentMethod(jsonOrder.getString("paymentMethod"));
    order.setTotalPrice(Double.parseDouble(jsonOrder.getString("totalPrice")));
    order.setOrderStatus(jsonOrder.getString("orderStatus"));

    // Cập nhật thông tin order vào database
    dao.updateOrder(order);
}

response.setContentType("application/json");
response.getWriter().write("{\"status\": \"success\"}");
%>
