package com.ptithcm.ejb;

import com.ptithcm.entity.CartItem;
import com.ptithcm.entity.Product;
import com.ptithcm.entity.User;
import java.util.List;
import javax.ejb.EJB;
import javax.ejb.Stateful;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateful
public class CartServiceBean implements CartService {
    
    @PersistenceContext(unitName = "cosmeticsPU")
    private EntityManager em;
    
    @EJB
    private UserService userService;
    
    @EJB
    private ProductService productService;
    
    @Override
    public void addToCart(Long userId, Long productId, int quantity) throws Exception {
        User user = userService.findById(userId);
        Product product = productService.findById(productId);
        
        if (user == null || product == null) {
            throw new Exception("Invalid user or product");
        }
        
        if (quantity <= 0) {
            throw new Exception("Quantity must be positive");
        }
        
        // Check if product is already in cart
        CartItem existingItem = findCartItem(userId, productId);
        if (existingItem != null) {
            // Update quantity instead
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
            em.merge(existingItem);
        } else {
            // Create new cart item
            CartItem cartItem = new CartItem();
            cartItem.setUser(user);
            cartItem.setProduct(product);
            cartItem.setQuantity(quantity);
            em.persist(cartItem);
        }
    }
    
    @Override
    public void updateQuantity(Long userId, Long productId, int quantity) throws Exception {
        CartItem cartItem = findCartItem(userId, productId);
        if (cartItem == null) {
            throw new Exception("Item not found in cart");
        }
        
        if (quantity <= 0) {
            removeFromCart(userId, productId);
        } else {
            cartItem.setQuantity(quantity);
            em.merge(cartItem);
        }
    }
    
    @Override
    public void removeFromCart(Long userId, Long productId) throws Exception {
        CartItem cartItem = findCartItem(userId, productId);
        if (cartItem == null) {
            throw new Exception("Item not found in cart");
        }
        em.remove(cartItem);
    }
    
    @Override
    public void clearCart(Long userId) throws Exception {
        TypedQuery<CartItem> query = em.createQuery(
            "DELETE FROM CartItem c WHERE c.user.id = :userId", 
            CartItem.class);
        query.setParameter("userId", userId);
        query.executeUpdate();
    }
    
    @Override
    public List<CartItem> getCartItems(Long userId) {
        TypedQuery<CartItem> query = em.createQuery(
            "SELECT c FROM CartItem c WHERE c.user.id = :userId", 
            CartItem.class);
        query.setParameter("userId", userId);
        return query.getResultList();
    }
    
    @Override
    public int getCartItemCount(Long userId) {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(c) FROM CartItem c WHERE c.user.id = :userId", 
            Long.class);
        query.setParameter("userId", userId);
        return query.getSingleResult().intValue();
    }
    
    @Override
    public boolean isProductInCart(Long userId, Long productId) {
        return findCartItem(userId, productId) != null;
    }
    
    @Override
    public CartItem findCartItem(Long userId, Long productId) {
        TypedQuery<CartItem> query = em.createQuery(
            "SELECT c FROM CartItem c WHERE c.user.id = :userId AND c.product.id = :productId", 
            CartItem.class);
        query.setParameter("userId", userId);
        query.setParameter("productId", productId);
        List<CartItem> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }
}
