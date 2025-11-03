package servlet;

import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdateCartServlet")
public class UpdateCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<Integer, Map<String, Object>> cart =
            (Map<Integer, Map<String, Object>>) session.getAttribute("cart");

        if (cart != null) {
            // ✅ If Remove button was clicked
            String removeId = request.getParameter("removeId");
            if (removeId != null) {
                try {
                    int id = Integer.parseInt(removeId);
                    cart.remove(id); // remove item
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            } else {
                // ✅ Otherwise, Update quantities
                for (Integer productId : cart.keySet()) {
                    String qtyParam = request.getParameter("qty_" + productId);
                    if (qtyParam != null && !qtyParam.isEmpty()) {
                        try {
                            int qty = Integer.parseInt(qtyParam);
                            if (qty > 0) {
                                cart.get(productId).put("qty", qty); // update qty
                            } else {
                                cart.remove(productId); // remove if qty = 0
                            }
                        } catch (NumberFormatException e) {
                            e.printStackTrace(); // ignore invalid inputs
                        }
                    }
                }
            }

            // ✅ Save updated cart back to session
            session.setAttribute("cart", cart);
        }

        // ✅ Redirect back to cart page
        response.sendRedirect("cart.jsp");
    }
}
