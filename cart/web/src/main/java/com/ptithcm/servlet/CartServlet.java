package com.ptithcm.servlet;

import com.ptithcm.ejb.CartService;
import com.ptithcm.entity.CartItem;
import com.ptithcm.entity.User;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CartServlet", urlPatterns = { "/cart/*" })
public class CartServlet extends HttpServlet {

    @EJB
    private CartService cartService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        try {
            // Get cart items
            List<CartItem> cartItems = cartService.getCartItems(user.getId());
            request.setAttribute("cartItems", cartItems);

            // Update cart count in session
            session.setAttribute("cartCount", cartItems.size());

            // Forward to cart page
            request.getRequestDispatcher("/WEB-INF/cart.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                handleAddToCart(request, user);
            } else if ("update".equals(action)) {
                handleUpdateCart(request, user);
            } else if ("remove".equals(action)) {
                handleRemoveFromCart(request, user);
            } else if ("clear".equals(action)) {
                handleClearCart(request, user);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            // Redirect back to cart or product page
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.isEmpty()) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }

    private void handleAddToCart(HttpServletRequest request, User user) throws Exception {
        Long productId = Long.parseLong(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        cartService.addToCart(user.getId(), productId, quantity);

        // Update cart count in session
        List<CartItem> cartItems = cartService.getCartItems(user.getId());
        request.getSession().setAttribute("cartCount", cartItems.size());
    }

    private void handleUpdateCart(HttpServletRequest request, User user) throws Exception {
        Long productId = Long.parseLong(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        cartService.updateQuantity(user.getId(), productId, quantity);

        // Update cart count in session
        List<CartItem> cartItems = cartService.getCartItems(user.getId());
        request.getSession().setAttribute("cartCount", cartItems.size());
    }

    private void handleRemoveFromCart(HttpServletRequest request, User user) throws Exception {
        Long productId = Long.parseLong(request.getParameter("productId"));
        cartService.removeFromCart(user.getId(), productId);

        // Update cart count in session
        List<CartItem> cartItems = cartService.getCartItems(user.getId());
        request.getSession().setAttribute("cartCount", cartItems.size());
    }

    private void handleClearCart(HttpServletRequest request, User user) throws Exception {
        cartService.clearCart(user.getId());
        // Set cart count to 0
        request.getSession().setAttribute("cartCount", 0);
    }
}
