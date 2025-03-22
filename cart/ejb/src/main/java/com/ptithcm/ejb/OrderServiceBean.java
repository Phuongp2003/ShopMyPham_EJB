package com.ptithcm.ejb;

import com.ptithcm.entity.Order;
import com.ptithcm.entity.OrderItem;
import com.ptithcm.entity.CartItem;
import com.ptithcm.entity.User;
import java.math.BigDecimal;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class OrderServiceBean implements OrderService {
    
    @PersistenceContext(unitName = "cosmeticsPU")
    private EntityManager em;
    
    @EJB
    private CartService cartService;
    
    @EJB
    private ProductService productService;
    
    @EJB
    private UserService userService;
    
    private static final Timer DELIVERY_TIMER = new Timer(true);
    
    @Override
    public Order createOrder(Long userId) throws Exception {
        User user = userService.findById(userId);
        if (user == null) {
            throw new Exception("User not found");
        }
        
        List<CartItem> cartItems = cartService.getCartItems(userId);
        if (cartItems.isEmpty()) {
            throw new Exception("Cart is empty");
        }
        
        // Create new order
        Order order = new Order();
        order.setUser(user);
        
        // Calculate total and create order items
        BigDecimal total = BigDecimal.ZERO;
        for (CartItem cartItem : cartItems) {
            // Check stock availability and update
            if (!productService.isInStock(cartItem.getProduct().getId(), cartItem.getQuantity())) {
                throw new Exception("Not enough stock for product: " + cartItem.getProduct().getName());
            }
            
            // Update stock
            productService.updateStock(cartItem.getProduct().getId(), -cartItem.getQuantity());
            
            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(order);
            orderItem.setProduct(cartItem.getProduct());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setPrice(cartItem.getProduct().getPrice());
            
            total = total.add(orderItem.getSubtotal());
        }
        
        order.setTotalAmount(total);
        em.persist(order);
        
        // Clear cart after successful order
        cartService.clearCart(userId);
        
        return order;
    }
    
    @Override
    public List<Order> getUserOrders(Long userId) {
        TypedQuery<Order> query = em.createQuery(
            "SELECT o FROM Order o WHERE o.user.id = :userId ORDER BY o.orderDate DESC", 
            Order.class);
        query.setParameter("userId", userId);
        return query.getResultList();
    }
    
    @Override
    public List<Order> getAllOrders() {
        TypedQuery<Order> query = em.createQuery(
            "SELECT o FROM Order o ORDER BY o.orderDate DESC", 
            Order.class);
        return query.getResultList();
    }
    
    @Override
    public Order getOrderById(Long orderId) {
        return em.find(Order.class, orderId);
    }
    
    @Override
    public void updateOrderStatus(Long orderId, Order.OrderStatus status) throws Exception {
        Order order = getOrderById(orderId);
        if (order == null) {
            throw new Exception("Order not found");
        }
        order.setStatus(status);
        em.merge(order);
    }
    
    @Override
    public void confirmDelivery(Long orderId) throws Exception {
        Order order = getOrderById(orderId);
        if (order == null) {
            throw new Exception("Order not found");
        }
        
        if (order.getStatus() != Order.OrderStatus.DELIVERING) {
            throw new Exception("Order is not in delivering status");
        }
        
        order.setStatus(Order.OrderStatus.DELIVERED);
        em.merge(order);
    }
    
    @Override
    public void simulateDelivery(Long orderId) throws Exception {
        Order order = getOrderById(orderId);
        if (order == null) {
            throw new Exception("Order not found");
        }
        
        // Change status to delivering
        order.setStatus(Order.OrderStatus.DELIVERING);
        em.merge(order);
        
        // Schedule status change to delivered after 3 minutes
        DELIVERY_TIMER.schedule(new TimerTask() {
            @Override
            public void run() {
                try {
                    updateOrderStatus(orderId, Order.OrderStatus.DELIVERED);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }, 3 * 60 * 1000); // 3 minutes
    }
    
    @Override
    public boolean canReview(Long userId, Long productId) {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(o) FROM Order o JOIN o.items i " +
            "WHERE o.user.id = :userId AND i.product.id = :productId " +
            "AND o.status = :status AND o.isReviewed = false",
            Long.class);
        query.setParameter("userId", userId);
        query.setParameter("productId", productId);
        query.setParameter("status", Order.OrderStatus.DELIVERED);
        return query.getSingleResult() > 0;
    }
    
    @Override
    public List<Order> getOrdersByStatus(Order.OrderStatus status) {
        TypedQuery<Order> query = em.createQuery(
            "SELECT o FROM Order o WHERE o.status = :status ORDER BY o.orderDate DESC",
            Order.class);
        query.setParameter("status", status);
        return query.getResultList();
    }
}
