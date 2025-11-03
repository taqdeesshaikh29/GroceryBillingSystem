<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<html>
<head>
    <meta charset="UTF-8">

    <title>Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow p-4">
            <h2 class="mb-4 text-center">💬 Feedback</h2>
            
            <div class="text-end mb-3">
                <a href="products.jsp" class="btn btn-primary">🏠 Return to Home</a>
            </div>
            
            <form action="SubmitFeedbackServlet" method="post">
                <div class="mb-3">
                    <label class="form-label">Your Name</label>
                    <input type="text" name="username" class="form-control" 
                           value="<%= session.getAttribute("userName") %>" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label">Message</label>
                    <textarea name="message" class="form-control" rows="4" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary w-100">Submit Feedback</button>
            </form>
        </div>
    </div>
</body>
</html>
