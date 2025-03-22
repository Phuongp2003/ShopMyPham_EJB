package com.ptithcm.servlet;

import com.ptithcm.ejb.OrderService;
import com.ptithcm.ejb.ProductService;
import com.ptithcm.entity.Order;
import com.ptithcm.entity.Product;
import com.ptithcm.entity.User;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AdminServlet extends HttpServlet {
    
    @EJB
    private OrderService orderService;
    
    @EJB
    private ProductService productService;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (!user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String path = request.getPathInfo();
        
        try {
            if (path == null || path.equals("/")) {
                // Show admin dashboard
                showDashboard(request, response);
            } else if (path.equals("/products")) {
                // Show product management
                showProductManagement(request, response);
            } else if (path.equals("/orders")) {
                // Show order management
                showOrderManagement(request, response);
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
        
        if (!user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("add-product".equals(action)) {
                handleAddProduct(request);
            } else if ("update-product".equals(action)) {
                handleUpdateProduct(request);
            } else if ("delete-product".equals(action)) {
                handleDeleteProduct(request);
            } else if ("update-order".equals(action)) {
                handleUpdateOrder(request);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            
            // Redirect back
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.isEmpty()) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get pending and delivering orders
        List<Order> pendingOrders = orderService.getOrdersByStatus(Order.OrderStatus.PENDING);
        List<Order> deliveringOrders = orderService.getOrdersByStatus(Order.OrderStatus.DELIVERING);
        
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("deliveringOrders", deliveringOrders);
        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
    }
    
    private void showProductManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productService.getAllProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/WEB-INF/admin/products.jsp").forward(request, response);
    }
    
    private void showOrderManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Order> orders = orderService.getAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/WEB-INF/admin/orders.jsp").forward(request, response);
    }
    
    private void handleAddProduct(HttpServletRequest request) throws Exception {
        Product product = new Product();
        product.setName(request.getParameter("name"));
        product.setDescription(request.getParameter("description"));
        product.setPrice(new BigDecimal(request.getParameter("price")));
        product.setImage(request.getParameter("image"));
        product.setStock(Integer.parseInt(request.getParameter("stock")));
        
        productService.addProduct(product);
    }
    
    private void handleUpdateProduct(HttpServletRequest request) throws Exception {
        Long productId = Long.parseLong(request.getParameter("productId"));
        Product product = productService.findById(productId);
        
        if (product == null) {
            throw new Exception("Product not found");
        }
        
        product.setName(request.getParameter("name"));
        product.setDescription(request.getParameter("description"));
        product.setPrice(new BigDecimal(request.getParameter("price")));
        product.setImage(request.getParameter("image"));
        product.setStock(Integer.parseInt(request.getParameter("stock")));
        
        productService.updateProduct(product);
    }
    
    private void handleDeleteProduct(HttpServletRequest request) throws Exception {
        Long productId = Long.parseLong(request.getParameter("productId"));
        productService.deleteProduct(productId);
    }
    
    private void handleUpdateOrder(HttpServletRequest request) throws Exception {
        Long orderId = Long.parseLong(request.getParameter("orderId"));
        String status = request.getParameter("status");
        
        if ("simulate".equals(status)) {
            orderService.simulateDelivery(orderId);
        } else {
            Order.OrderStatus orderStatus = Order.OrderStatus.valueOf(status.toUpperCase());
            orderService.updateOrderStatus(orderId, orderStatus);
        }
    }
}
