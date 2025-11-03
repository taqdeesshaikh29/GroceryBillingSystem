package servlet;

import java.io.IOException;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<Integer, Map<String, Object>> cart =
                (Map<Integer, Map<String, Object>>) session.getAttribute("cart");

        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        if ("add".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String name = request.getParameter("name");
            double price = Double.parseDouble(request.getParameter("price"));
            int qty = Integer.parseInt(request.getParameter("qty"));
            String unitType = request.getParameter("unitType") != null ? request.getParameter("unitType") : "unit";
            String unitQuantity = request.getParameter("unitQuantity") != null ? request.getParameter("unitQuantity") : "1";

            if (cart.containsKey(productId)) {
                Map<String, Object> item = cart.get(productId);
                int currentQty = (int) item.get("qty");
                item.put("qty", currentQty + qty);
            } else {
                Map<String, Object> item = new HashMap<>();
                item.put("id", productId);
                item.put("name", name);
                item.put("price", price);
                item.put("qty", qty);
                item.put("unitType", unitType);
                item.put("unitQuantity", unitQuantity);
                cart.put(productId, item);
            }

            session.setAttribute("cartCount", cart.size());

            if (isAjax) {
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(cart.size()));
            } else {
                response.sendRedirect("products.jsp");
            }

        } else if ("remove".equals(action) || request.getParameter("remove") != null) {
            int productId = request.getParameter("remove") != null
                    ? Integer.parseInt(request.getParameter("remove"))
                    : Integer.parseInt(request.getParameter("productId"));
            cart.remove(productId);
            session.setAttribute("cartCount", cart.size());

            if (isAjax) {
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(cart.size()));
            } else {
                response.sendRedirect("cart.jsp");
            }

        } else if ("update".equals(action)) {
            for (Map.Entry<Integer, Map<String, Object>> entry : cart.entrySet()) {
                int productId = entry.getKey();
                Map<String, Object> item = entry.getValue();
                String qtyParam = request.getParameter("qty_" + productId);
                if (qtyParam != null) {
                    int newQty = Integer.parseInt(qtyParam);
                    if (newQty > 0) {
                        item.put("qty", newQty);
                    } else {
                        cart.remove(productId);
                    }
                }
            }
            session.setAttribute("cartCount", cart.size());

            if (isAjax) {
                response.setContentType("text/plain");
                response.getWriter().write(String.valueOf(cart.size()));
            } else {
                response.sendRedirect("cart.jsp");
            }

        } else {
            response.sendRedirect("products.jsp");
        }
    }
}
