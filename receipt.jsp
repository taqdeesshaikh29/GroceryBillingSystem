<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="dao.DBConnection" %>
<%@ page session="true" %>
<html>
<head>
    <title>Receipt</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Courier New', Courier, monospace;
            background: #f5f5f5;
        }
        .receipt-container {
            background: #fff;
            padding: 30px;
            margin: auto;
            max-width: 700px;
            border: 1px solid #ccc;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .receipt-header {
            text-align: center;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid #000;
        }
        th, td {
            padding: 8px 12px;
            text-align: center;
        }
        .total-row td {
            font-weight: bold;
        }
        .buttons {
            margin-top: 20px;
            text-align: center;
        }
    </style>
    <script>
        function printReceipt() {
            window.print();
        }

        function offlineReceipt() {
            alert("The receipt will be provided with the delivery");
        }
    </script>
</head>
<body>
    <div class="receipt-container">
        <div class="receipt-header">
            <h2>4 Square Mini Mart</h2>
            <p>Thank you for shopping with us!</p>
        </div>

        <%
            // Check if user is logged in
            Integer userId = (Integer) session.getAttribute("userId");
            if(userId == null) {
        %>
            <p style="color:red; text-align:center;">Error: User not logged in or session expired.</p>
        <%
            } else {
                List<Map<String,Object>> cart = new ArrayList<>();
                double total = 0;

                try {
                    Connection con = DBConnection.getConnection();

                    // Step 1: Get the latest order date for this user
                    PreparedStatement psLatest = con.prepareStatement(
                        "SELECT MAX(order_date) AS latest_order_date FROM orders WHERE user_id = ?"
                    );
                    psLatest.setInt(1, userId);
                    ResultSet rsLatest = psLatest.executeQuery();

                    Timestamp latestOrderDate = null;
                    if(rsLatest.next()) {
                        latestOrderDate = rsLatest.getTimestamp("latest_order_date");
                    }
                    rsLatest.close();
                    psLatest.close();

                    if(latestOrderDate != null) {
                        // Step 2: Fetch all items for the latest order
                        PreparedStatement ps = con.prepareStatement(
                            "SELECT p.name, o.quantity, (p.price - IFNULL(p.discount,0)) AS price " +
                            "FROM orders o " +
                            "JOIN products p ON o.product_id = p.id " +
                            "WHERE o.user_id = ? AND o.order_date = ?"
                        );
                        ps.setInt(1, userId);
                        ps.setTimestamp(2, latestOrderDate);
                        ResultSet rs = ps.executeQuery();

                        while(rs.next()) {
                            Map<String,Object> item = new HashMap<>();
                            String name = rs.getString("name");
                            int qty = rs.getInt("quantity");
                            double price = rs.getDouble("price");

                            item.put("name", name);
                            item.put("quantity", qty);
                            item.put("price", price);
                            cart.add(item);

                            total += price * qty;
                        }
                        rs.close();
                        ps.close();
                    }

                    con.close();
                } catch(Exception e) {
                    out.println("<p style='color:red; text-align:center;'>Error fetching order: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                }
        %>

        <table>
            <thead>
                <tr>
                    <th>Item Name</th>
                    <th>Quantity</th>
                    <th>Price (₹)</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if(cart.isEmpty()) {
                %>
                <tr>
                    <td colspan="3">No items found for your latest order.</td>
                </tr>
                <%
                    } else {
                        for(Map<String,Object> item : cart) {
                %>
                <tr>
                    <td><%= item.get("name") %></td>
                    <td><%= item.get("quantity") %></td>
                    <td>₹<%= ((Double)item.get("price")) * (Integer)item.get("quantity") %></td>
                </tr>
                <%
                        }
                    }
                %>
                <tr class="total-row">
                    <td colspan="2">Total</td>
                    <td>₹<%= total %></td>
                </tr>
            </tbody>
        </table>

        <div class="buttons">
            <button class="btn btn-success" onclick="printReceipt()">Print Receipt</button>
            <button class="btn btn-secondary" onclick="offlineReceipt()">Offline Receipt</button>
            <form action="logout.jsp" method="post" style="display:inline;">
                <button type="submit" class="btn btn-danger">Logout</button>
            </form>
        </div>

        <%
            } // end else (userId check)
        %>
    </div>
</body>
</html>
