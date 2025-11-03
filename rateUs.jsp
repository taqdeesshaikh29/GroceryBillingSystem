<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Rate Us</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            text-align: center;
            padding: 30px;
        }
        h2 {
            color: #333;
        }
        .stars {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin: 20px 0;
            flex-direction: row-reverse;
        }
        .stars input {
            display: none;
        }
        .stars label {
            font-size: 40px;
            color: #ccc;
            cursor: pointer;
            transition: color 0.3s;
        }
        .stars input:checked ~ label,
        .stars label:hover,
        .stars label:hover ~ label {
            color: gold;
        }
        textarea {
            width: 80%;
            max-width: 500px;
            height: 100px;
            margin-top: 15px;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            resize: none;
        }
        button {
            margin-top: 15px;
            padding: 10px 20px;
            background: #28a745;
            border: none;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background: #218838;
        }
    </style>
</head>
<body>
    <h2>⭐ Rate Your Experience</h2>
    
    
    
    <form action="SaveFeedbackServlet" method="post">
        <div class="stars">
            <input type="radio" id="star5" name="rating" value="5"><label for="star5">★</label>
            <input type="radio" id="star4" name="rating" value="4"><label for="star4">★</label>
            <input type="radio" id="star3" name="rating" value="3"><label for="star3">★</label>
            <input type="radio" id="star2" name="rating" value="2"><label for="star2">★</label>
            <input type="radio" id="star1" name="rating" value="1"><label for="star1">★</label>
        </div>

        <textarea name="feedback" placeholder="Write your feedback here..."></textarea><br>
        <button type="submit">Submit</button>
    </form>
    
    <div class="text-end mb-3">
                <a href="products.jsp" class="btn btn-primary">🏠 Return to Home</a>
            </div>
</body>
</html>
