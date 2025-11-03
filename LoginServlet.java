package servlets;

import dao.DBConnection;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import org.mindrot.jbcrypt.BCrypt;   // ✅ for password verification

@WebServlet("/LoginServlet")   // ✅ mapping URL
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        System.out.println("LoginServlet called for: " + email);

        try {
            Connection con = DBConnection.getConnection();

            // ✅ Fetch user by email only, get stored hash
            PreparedStatement ps = con.prepareStatement("SELECT id, name, password_hash FROM users WHERE email=?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password_hash");

                // ✅ Compare entered password with stored hash
                if (storedHash != null && BCrypt.checkpw(password, storedHash)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("userName", rs.getString("name"));

                    // ✅ Redirect to products page
                    response.sendRedirect("products.jsp");
                } else {
                    // wrong password
                    response.sendRedirect("login.jsp?error=1");
                }
            } else {
                // email not found
                response.sendRedirect("login.jsp?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=db");
        }
    }
}
