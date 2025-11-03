package servlet;

import dao.DBConnection;
import java.io.IOException;
import java.sql.*;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        Integer userId = (Integer) session.getAttribute("userId"); // make sure you set this at login

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            for (Map.Entry<String, Integer> entry : cart.entrySet()) {
                int productId = Integer.parseInt(entry.getKey());
                int qty = entry.getValue();

                PreparedStatement ps = con.prepareStatement(
                    "SELECT price FROM products WHERE id=?"
                );
                ps.setInt(1, productId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    double price = rs.getDouble("price");
                    double total = price * qty;

                    // Insert into orders table
                    PreparedStatement insert = con.prepareStatement(
                        "INSERT INTO orders(user_id, product_id, quantity, total) VALUES(?,?,?,?)"
                    );
                    insert.setInt(1, userId != null ? userId : 0); // if userId is not set
                    insert.setInt(2, productId);
                    insert.setInt(3, qty);
                    insert.setDouble(4, total);
                    insert.executeUpdate();

                    // Update stock
                    PreparedStatement update = con.prepareStatement(
                        "UPDATE products SET stock = stock - ? WHERE id=?"
                    );
                    update.setInt(1, qty);
                    update.setInt(2, productId);
                    update.executeUpdate();
                }
            }

            // Clear cart after order placed
            session.removeAttribute("cart");

            // Redirect to confirmation page
            response.sendRedirect("orderSuccess.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("checkout.jsp");
        }
    }
}
