<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Special Discounts</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .discount-card {
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 20px;
            margin: 15px;
            transition: 0.3s;
        }
        .discount-card:hover {
            transform: translateY(-5px);
        }
        .flash {
            background: red;
            color: #fff;
            padding: 5px 10px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 10px;
        }
    </style>
</head>
<body class="bg-light">

<div class="container mt-4">
    <h2 class="mb-4 text-center">🔥 Special Discounts & Flash Sales 🔥</h2>

    <div class="row">
        <!-- Example Offer 1 -->
        <div class="col-md-4">
            <div class="discount-card bg-white">
                <div class="flash">Buy 1 Get 1 Free</div>
                <h4>Milk Pack</h4>
                <p>Buy 1 Liter Milk and Get 1 Free</p>
                <button class="btn btn-success">Shop Now</button>
            </div>
        </div>

        <!-- Example Offer 2 -->
        <div class="col-md-4">
            <div class="discount-card bg-white">
                <div class="flash">20% OFF</div>
                <h4>Bread Loaf</h4>
                <p>Get 20% Off on Freshly Baked Bread</p>
                <button class="btn btn-success">Shop Now</button>
            </div>
        </div>

        <!-- Example Offer 3 -->
        <div class="col-md-4">
            <div class="discount-card bg-white">
                <div class="flash">Flash Sale</div>
                <h4>Cooking Oil</h4>
                <p>Limited Time: Flat ₹50 OFF</p>
                <button class="btn btn-success">Shop Now</button>
            </div>
        </div>
    </div>
</div>

</body>
</html>
