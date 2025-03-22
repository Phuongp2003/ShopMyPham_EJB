package com.ptithcm.ejb;

import com.ptithcm.entity.Review;
import java.util.List;
import javax.ejb.Remote;

@Remote
public interface ReviewService {
    void addReview(Long userId, Long productId, Long orderId, int rating, String comment) throws Exception;
    List<Review> getProductReviews(Long productId);
    List<Review> getUserReviews(Long userId);
    boolean hasUserReviewed(Long userId, Long productId, Long orderId);
    void updateProductRating(Long productId);
}
