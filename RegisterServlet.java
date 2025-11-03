package servlets;

import dao.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// ✅ add bcrypt dependency in pom.xml or lib
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/RegisterServlet")   // ✅ URL mapping for Tomcat
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("RegisterServlet called");
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        System.out.println("Name: " + name + ", Email: " + email + ", Password: " + password);  // ✅ paste here

        try {
            // ✅ Password complexity check
            String pwdRegex = "^(?=.{12,64}$)(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[^A-Za-z0-9]).*$";
            if (password == null || !Pattern.matches(pwdRegex, password)) {
                request.setAttribute("error", 
                    "Password must be 12–64 chars, include uppercase, lowercase, number, and special char.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // ✅ Hash password with BCrypt
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));
            System.out.println("Hashed password: " + hashedPassword);   // ✅ paste here

            // get connection from your DBConnection class
            Connection con = DBConnection.getConnection();
            
            // insert query (store hashed password)
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users(name, email, password_hash) VALUES(?, ?, ?)"
            );
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);

            int rows = ps.executeUpdate();
            System.out.println("Rows inserted: " + rows);   // ✅ paste here
            if (rows > 0) {
                // Registration successful → go to login page
                response.sendRedirect("login.jsp");
            } else {
                // Registration failed → stay on register page
                response.sendRedirect("register.jsp");
            }

            ps.close();
            con.close();

        } catch (Exception e) {
    e.printStackTrace();  // ✅ already here
    response.sendRedirect("register.jsp?error=1");
}

    }
}
