package com.ptithcm.ejb;

import com.ptithcm.entity.Review;
import com.ptithcm.entity.Product;
import com.ptithcm.entity.Order;
import com.ptithcm.entity.User;
import java.util.List;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class ReviewServiceBean implements ReviewService {
    @PersistenceContext(unitName = "cosmeticsPU")
    private EntityManager em;
    
    @EJB
    private UserService userService;
    
    @EJB
    private ProductService productService;
    
    @EJB
    private OrderService orderService;
    
    @Override
    public void addReview(Long userId, Long productId, Long orderId, int rating, String comment) 
            throws Exception {
        // Validate user, product and order
        User user = userService.findById(userId);
        Product product = productService.findById(productId);
        Order order = orderService.getOrderById(orderId);
        
        if (user == null || product == null || order == null) {
            throw new Exception("Invalid user, product or order");
        }
        
        // Check if order is delivered
        if (order.getStatus() != Order.OrderStatus.DELIVERED) {
            throw new Exception("Order must be delivered before review");
        }
        
        // Check if user has already reviewed this product in this order
        if (hasUserReviewed(userId, productId, orderId)) {
            throw new Exception("You have already reviewed this product for this order");
        }
        
        // Create and save review
        Review review = new Review();
        review.setUser(user);
        review.setProduct(product);
        review.setOrder(order);
        review.setRating(rating);
        review.setComment(comment);
        
        em.persist(review);
        
        // Mark order as reviewed
        order.setReviewed(true);
        em.merge(order);
        
        // Update product rating
        updateProductRating(productId);
    }
    
    @Override
    public List<Review> getProductReviews(Long productId) {
        TypedQuery<Review> query = em.createQuery(
            "SELECT r FROM Review r WHERE r.product.id = :productId ORDER BY r.reviewDate DESC",
            Review.class);
        query.setParameter("productId", productId);
        return query.getResultList();
    }
    
    @Override
    public List<Review> getUserReviews(Long userId) {
        TypedQuery<Review> query = em.createQuery(
            "SELECT r FROM Review r WHERE r.user.id = :userId ORDER BY r.reviewDate DESC",
            Review.class);
        query.setParameter("userId", userId);
        return query.getResultList();
    }
    
    @Override
    public boolean hasUserReviewed(Long userId, Long productId, Long orderId) {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(r) FROM Review r WHERE r.user.id = :userId " +
            "AND r.product.id = :productId AND r.order.id = :orderId",
            Long.class);
        query.setParameter("userId", userId);
        query.setParameter("productId", productId);
        query.setParameter("orderId", orderId);
        return query.getSingleResult() > 0;
    }
    
    @Override
    public void updateProductRating(Long productId) {
        // Calculate average rating
        TypedQuery<Double> avgQuery = em.createQuery(
            "SELECT AVG(r.rating) FROM Review r WHERE r.product.id = :productId",
            Double.class);
        avgQuery.setParameter("productId", productId);
        Double avgRating = avgQuery.getSingleResult();
        
        // Count total reviews
        TypedQuery<Long> countQuery = em.createQuery(
            "SELECT COUNT(r) FROM Review r WHERE r.product.id = :productId",
            Long.class);
        countQuery.setParameter("productId", productId);
        Long totalReviews = countQuery.getSingleResult();
        
        // Update product
        Product product = productService.findById(productId);
        if (product != null) {
            product.setAverageRating(avgRating != null ? avgRating : 0.0);
            product.setTotalReviews(totalReviews.intValue());
            em.merge(product);
        }
    }
}
