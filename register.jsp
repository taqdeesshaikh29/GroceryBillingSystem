<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Registration - Grocery Billing System</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #ffecd2, #fcb69f);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .register-container {
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

        input[type="text"], input[type="email"], input[type="password"] {
            padding: 12px 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 1em;
            transition: 0.3s;
        }

        input[type="text"]:focus, input[type="email"]:focus, input[type="password"]:focus {
            border-color: #fcb69f;
            outline: none;
            box-shadow: 0 0 5px rgba(252, 182, 159, 0.5);
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

        .login-link {
            margin-top: 20px;
            display: block;
            color: #555;
            text-decoration: none;
            font-size: 0.95em;
        }

        .login-link:hover {
            color: #333;
        }

        .password-wrapper {
            position: relative;
            width: 100%;
        }

        .password-wrapper input {
            width: 100%;
            padding: 12px 40px 12px 15px; /* space for the eye icon */
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 1em;
            box-sizing: border-box;
        }

        .toggle-eye {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            font-size: 1.1em;
            color: #555;
            user-select: none;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h2>User Registration</h2>

        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div style="color:red; font-size:0.9em; margin-bottom:10px;"><%= error %></div>
        <% } %>

        <form action="RegisterServlet" method="post">
            <input type="text" name="name" placeholder="Full Name" required>
            <input type="email" name="email" placeholder="Email" required>

            <!-- Password field with eye icon inside the box -->
            <div class="password-wrapper">
                <input id="password" type="password" name="password" placeholder="Password" required aria-describedby="pwdHelp">
                <span id="togglePwd" class="toggle-eye">👁</span>
            </div>

            <div id="pwdHelp" style="font-size:0.9em; color:#555; margin-top:-10px;">
                Password must be 12–64 characters and include uppercase, lowercase, number, and special character.
            </div>
            <div id="pwdError" style="color:crimson; display:none; font-size:0.9em;"></div>

            <input type="submit" value="Register">
        </form>

        <a class="login-link" href="login.jsp">Already have an account? Login</a>
    </div>

    <!-- JS for password validation and toggle -->
    <script>
        // Password complexity check
        const pwdRegex = /^(?=.{12,64}$)(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9]).*$/;

        document.querySelector("form").addEventListener("submit", function(e){
            const pwd = document.getElementById("password").value;
            const errEl = document.getElementById("pwdError");

            if(!pwdRegex.test(pwd)){
                e.preventDefault();
                errEl.style.display = "block";
                errEl.textContent = "Password must be 12–64 characters and include uppercase, lowercase, number, and special character.";
            }
        });

        // Toggle password visibility
        const pwdInput = document.getElementById("password");
        const toggle = document.getElementById("togglePwd");

        toggle.addEventListener("click", function() {
            if (pwdInput.type === "password") {
                pwdInput.type = "text";
                toggle.textContent = "🙈";
            } else {
                pwdInput.type = "password";
                toggle.textContent = "👁";
            }
        });
    </script>
</body>
</html>
