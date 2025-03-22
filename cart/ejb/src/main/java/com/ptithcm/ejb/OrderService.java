package com.ptithcm.ejb;

import com.ptithcm.entity.Order;
import java.util.List;
import javax.ejb.Remote;

@Remote
public interface OrderService {
    Order createOrder(Long userId) throws Exception;
    List<Order> getUserOrders(Long userId);
    List<Order> getAllOrders(); // For admin
    Order getOrderById(Long orderId);
    void updateOrderStatus(Long orderId, Order.OrderStatus status) throws Exception;
    void confirmDelivery(Long orderId) throws Exception;
    void simulateDelivery(Long orderId) throws Exception;
    boolean canReview(Long userId, Long productId);
    List<Order> getOrdersByStatus(Order.OrderStatus status);
}
