<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,dao.DBConnection" %>
<%@ page session="true" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Previous Orders</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow p-4">
            <h2 class="mb-4 text-center">📦 Your Previous Orders</h2>

            <!-- ✅ Home button -->
            <div class="text-end mb-3">
                <a href="products.jsp" class="btn btn-primary">🏠 Return to Home</a>
            </div>

            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Total</th>
                        <th>Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try {
                        Connection con = DBConnection.getConnection();
                        int userId = (Integer) session.getAttribute("userId"); 
                        PreparedStatement ps = con.prepareStatement(
                            "SELECT o.id, p.name, o.quantity, o.total, o.order_date " +
                            "FROM orders o JOIN products p ON o.product_id = p.id " +
                            "WHERE o.user_id = ? ORDER BY o.order_date DESC");
                        ps.setInt(1, userId);
                        ResultSet rs = ps.executeQuery();

                        while(rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getInt("id") %></td>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getInt("quantity") %></td>
                        <td>&#8377;<%= rs.getDouble("total") %></td>
                        <td><%= rs.getTimestamp("order_date") %></td>
                        <td>🚚 Dispatched</td>
                    </tr>
                <%
                        }
                    } catch(Exception e) { e.printStackTrace(); }
                %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
