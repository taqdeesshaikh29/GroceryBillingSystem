<%@ page import="java.util.*, java.util.Map" %>
<%@ page session="true" %>
<html>
<head>
    <title>Your Cart</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4"><i class="fa fa-shopping-cart"></i> Your Shopping Cart</h2>

    <%
        Map<Integer, Map<String,Object>> cart = (Map<Integer, Map<String,Object>>) session.getAttribute("cart");
        if(cart != null && !cart.isEmpty()) {
            double grandTotal = 0;
    %>

    <form action="CartServlet" method="post">
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>Item</th>
                    <th>Price</th>
                    <th>Qty</th>
                    <th>Unit</th>
                    <th>Total</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <%
                for(Map.Entry<Integer, Map<String,Object>> entry : cart.entrySet()) {
                    int productId = entry.getKey();
                    Map<String,Object> item = entry.getValue();
                    double price = (double)item.get("price");
                    int qty = (int)item.get("qty");
                    double total = price * qty;
                    grandTotal += total;

                    String unitType = item.get("unitType") != null ? (String)item.get("unitType") : "unit";
                    String unitQuantity = item.get("unitQuantity") != null ? (String)item.get("unitQuantity") : "1";
            %>
                <tr>
                    <td><%= item.get("name") %></td>
                    <td>&#8377;<%= price %></td>
                    <td>
                        <input type="number" name="qty_<%=productId%>" value="<%= qty %>" min="1" class="form-control w-50">
                    </td>
                    <td><%= unitQuantity %> <%= unitType %></td>
                    <td>&#8377;<%= total %></td>
                    <td>
                        <button type="submit" name="remove" value="<%=productId%>" class="btn btn-danger btn-sm">
                            <i class="fa fa-trash"></i> Remove
                        </button>
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <div class="d-flex justify-content-between align-items-center">
            <h4>Grand Total: <span class="text-success">&#8377;<%= grandTotal %></span></h4>
            <div>
                <a href="products.jsp" class="btn btn-secondary">
                    <i class="fa fa-arrow-left"></i> Continue Shopping
                </a>
                <button type="submit" name="action" value="update" class="btn btn-primary">
                    <i class="fa fa-sync"></i> Update Cart
                </button>
                <a href="checkout.jsp" class="btn btn-success">
                    <i class="fa fa-credit-card"></i> Proceed to Checkout
                </a>
            </div>
        </div>
    </form>

    <%
        } else {
    %>
        <div class="alert alert-warning">Your cart is empty!</div>
        <a href="products.jsp" class="btn btn-secondary mt-3">
            <i class="fa fa-arrow-left"></i> Continue Shopping
        </a>
    <%
        }
    %>
</div>
</body>
</html>
