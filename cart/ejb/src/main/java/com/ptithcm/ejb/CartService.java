package com.ptithcm.ejb;

import com.ptithcm.entity.CartItem;
import com.ptithcm.entity.User;
import java.util.List;
import javax.ejb.Remote;

@Remote
public interface CartService {
    void addToCart(Long userId, Long productId, int quantity) throws Exception;
    void updateQuantity(Long userId, Long productId, int quantity) throws Exception;
    void removeFromCart(Long userId, Long productId) throws Exception;
    void clearCart(Long userId) throws Exception;
    List<CartItem> getCartItems(Long userId);
    int getCartItemCount(Long userId);
    boolean isProductInCart(Long userId, Long productId);
    CartItem findCartItem(Long userId, Long productId);
}
