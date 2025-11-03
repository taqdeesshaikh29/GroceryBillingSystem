<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Login - Grocery Billing System</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #89f7fe, #66a6ff);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            background-color: rgba(255, 255, 255, 0.95);
            padding: 50px 60px;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            text-align: center;
            width: 400px;
        }

        h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 2em;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        input[type="email"], input[type="password"] {
            padding: 12px 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 1em;
            transition: 0.3s;
        }

        input[type="email"]:focus, input[type="password"]:focus {
            border-color: #66a6ff;
            outline: none;
            box-shadow: 0 0 5px rgba(102, 166, 255, 0.5);
        }

        input[type="submit"] {
            padding: 12px 15px;
            border: none;
            border-radius: 12px;
            background: linear-gradient(45deg, #ff7e5f, #feb47b);
            color: white;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }

        input[type="submit"]:hover {
            background: linear-gradient(45deg, #feb47b, #ff7e5f);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .register-link {
            margin-top: 20px;
            display: block;
            color: #555;
            text-decoration: none;
            font-size: 0.95em;
        }

        .register-link:hover {
            color: #333;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>User Login</h2>
        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="submit" value="Login">
        </form>
        <a class="register-link" href="register.jsp">New user? Register here</a>
    </div>
            
</body>
</html>
