package com.ptithcm.servlet;

import com.ptithcm.ejb.OrderService;
import com.ptithcm.entity.Order;
import com.ptithcm.entity.User;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class OrderServlet extends HttpServlet {
    
    @EJB
    private OrderService orderService;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Show order list
                List<Order> orders = user.isAdmin() ? 
                    orderService.getAllOrders() : 
                    orderService.getUserOrders(user.getId());
                request.setAttribute("orders", orders);
                request.getRequestDispatcher("/WEB-INF/orders.jsp").forward(request, response);
                
            } else if (pathInfo.startsWith("/view/")) {
                // Show order details
                String orderId = pathInfo.substring(6);
                Order order = orderService.getOrderById(Long.parseLong(orderId));
                
                if (order == null || (!user.isAdmin() && !order.getUser().getId().equals(user.getId()))) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                
                request.setAttribute("order", order);
                request.getRequestDispatcher("/WEB-INF/order-details.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
            
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
            if ("create".equals(action)) {
                // Create new order from cart
                handleCreateOrder(request, user);
                response.sendRedirect(request.getContextPath() + "/order");
                
            } else if ("simulate-delivery".equals(action) && user.isAdmin()) {
                // Admin simulating delivery
                Long orderId = Long.parseLong(request.getParameter("orderId"));
                orderService.simulateDelivery(orderId);
                response.sendRedirect(request.getHeader("Referer"));
                
            } else if ("confirm-delivery".equals(action)) {
                // User confirming delivery
                Long orderId = Long.parseLong(request.getParameter("orderId"));
                Order order = orderService.getOrderById(orderId);
                
                if (order == null || !order.getUser().getId().equals(user.getId())) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                
                orderService.confirmDelivery(orderId);
                response.sendRedirect(request.getHeader("Referer"));
                
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }
    
    private void handleCreateOrder(HttpServletRequest request, User user) throws Exception {
        Order order = orderService.createOrder(user.getId());
        request.setAttribute("message", "Order created successfully!");
    }
}
