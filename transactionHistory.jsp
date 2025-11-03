<%@ page import="java.sql.*" %>
<%@ page import="dao.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Transaction History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4">My Transaction History</h2>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Transaction ID</th>
                <th>Order ID</th>
                <th>Amount (₹)</th>
                <th>Payment Method</th>
                <th>Status</th>
                <th>Date</th>
            </tr>
        </thead>
        <tbody>
        <%
            Integer userId = (Integer) session.getAttribute("userId");
            if(userId != null) {
                try {
                    Connection con = DBConnection.getConnection();
                    PreparedStatement ps = con.prepareStatement(
                        "SELECT * FROM transactions WHERE user_id = ? ORDER BY transaction_date DESC"
                    );
                    ps.setInt(1, userId);
                    ResultSet rs = ps.executeQuery();
                    while(rs.next()) {
        %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getInt("order_id") %></td>
                <td>₹<%= rs.getDouble("amount") %></td>
                <td><%= rs.getString("payment_method") %></td>
                <td><%= rs.getString("status") %></td>
                <td><%= rs.getTimestamp("transaction_date") %></td>
            </tr>
        <%
                    }
                    rs.close();
                    ps.close();
                    con.close();
                } catch(Exception e) {
                    out.println("<tr><td colspan='6' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                }
            } else {
                out.println("<tr><td colspan='6'>User not logged in.</td></tr>");
            }
        %>
        </tbody>
    </table>
    <a href="products.jsp" class="btn btn-primary">Back to Shopping</a>
</div>
</body>
</html>
