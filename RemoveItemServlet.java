package servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RemoveItemServlet")
public class RemoveItemServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        
        // Initialize cart if null
        Map<Integer, Map<String, Object>> cart = 
            (Map<Integer, Map<String, Object>>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        // Remove item safely
        String pid = request.getParameter("productId");
        if(pid != null) {
            try {
                int productId = Integer.parseInt(pid);
                cart.remove(productId);
            } catch(NumberFormatException e) {
                e.printStackTrace(); // optional: log error
            }
        }

        // Redirect back to cart page
        response.sendRedirect("cart.jsp");
    }
}
