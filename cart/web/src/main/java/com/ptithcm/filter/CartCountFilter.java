package com.ptithcm.filter;

import com.ptithcm.ejb.CartService;
import com.ptithcm.entity.CartItem;
import com.ptithcm.entity.User;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@WebFilter(filterName = "CartCountFilter", urlPatterns = { "/*" })
public class CartCountFilter implements Filter {

    @EJB
    private CartService cartService;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");

            // Only update cart count if it's not already set
            if (session.getAttribute("cartCount") == null) {
                try {
                    List<CartItem> cartItems = cartService.getCartItems(user.getId());
                    session.setAttribute("cartCount", cartItems.size());
                } catch (Exception e) {
                    // Log error but continue processing the request
                    e.printStackTrace();
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
