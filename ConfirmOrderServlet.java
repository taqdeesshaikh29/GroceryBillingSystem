package servlet;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.DBConnection;

@WebServlet("/ConfirmOrderServlet")
public class ConfirmOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<Integer, Map<String, Object>> cart =
                (Map<Integer, Map<String, Object>>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp"); // cart empty
            return;
        }

        String fullname = request.getParameter("fullname");
        String address = request.getParameter("address");
        String payment = request.getParameter("payment");

        // ✅ Get logged-in user's ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            // if user not logged in, redirect
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            // --- Insert orders ---
            String sql = "INSERT INTO orders(user_id, product_id, quantity, total, order_date, fullname, address, payment, status) "
                       + "VALUES(?,?,?,?,NOW(),?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);

            double grandTotal = 0.0; // ✅ to track total cart amount

            for (Map.Entry<Integer, Map<String, Object>> entry : cart.entrySet()) {
                int productId = entry.getKey();
                Map<String, Object> item = entry.getValue();
                int qty = (int) item.get("qty");
                double total = (double) item.get("price") * qty;

                ps.setInt(1, userId);
                ps.setInt(2, productId);
                ps.setInt(3, qty);
                ps.setDouble(4, total);
                ps.setString(5, fullname);
                ps.setString(6, address);
                ps.setString(7, payment);
                ps.setString(8, "Dispatched"); // ✅ default status
                ps.addBatch();

                grandTotal += total; // ✅ accumulate
            }

            ps.executeBatch();

            // --- Insert into transactions ---
            String txSql = "INSERT INTO transactions(order_id, user_id, amount, payment_method, status) "
                         + "VALUES(NULL, ?, ?, ?, ?)";
            PreparedStatement psTx = con.prepareStatement(txSql);
            psTx.setInt(1, userId);
            psTx.setDouble(2, grandTotal);
            psTx.setString(3, payment);
            psTx.setString(4, "SUCCESS"); // ✅ can change later if failed
            psTx.executeUpdate();

            // clear cart after saving
            session.removeAttribute("cart");

            // success page
            request.setAttribute("message", "Order Confirmed! Your items will be dispatched soon.");
            request.getRequestDispatcher("orderSuccess.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("checkout.jsp");
        }
    }
}
