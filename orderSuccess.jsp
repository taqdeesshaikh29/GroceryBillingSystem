<html>
<head>
    <title>Order Success</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="alert alert-success shadow text-center">
            <h2> Order Placed Successfully!</h2>
            <p><%= (request.getAttribute("message") != null) ? request.getAttribute("message") : "Your order has been successfully placed!" %></p>

            
            <div class="d-flex justify-content-center gap-2">
    <a href="trackOrder.jsp" class="btn btn-info btn-lg">Track Your Order</a>
    <a href="receipt.jsp" class="btn btn-success btn-lg">View Receipt</a>
</div>

        </div>
    </div>
</body>
</html>
