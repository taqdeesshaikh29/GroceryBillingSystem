<%@ page session="true" %>
<html>
<head>
    <title>Order Status</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow p-4">
            <h2 class="mb-4 text-success">Order Status</h2>
            <p>
                <%= session.getAttribute("orderStatus") != null ? session.getAttribute("orderStatus") : "No order found." %>
            </p>
            <a href="products.jsp" class="btn btn-primary">Continue Shopping</a>
        </div>
    </div>
</body>
</html>
