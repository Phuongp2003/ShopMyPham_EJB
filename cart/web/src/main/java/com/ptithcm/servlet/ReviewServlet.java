package com.ptithcm.servlet;

import com.ptithcm.ejb.ReviewService;
import com.ptithcm.ejb.OrderService;
import com.ptithcm.entity.User;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ReviewServlet extends HttpServlet {

    @EJB
    private ReviewService reviewService;

    @EJB
    private OrderService orderService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        try {
            // Get parameters
            Long productId = Long.parseLong(request.getParameter("productId"));
            Long orderId = Long.parseLong(request.getParameter("orderId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            // Validate rating
            if (rating < 1 || rating > 5) {
                throw new Exception("Rating must be between 1 and 5");
            }

            // Check if user can review
            if (!orderService.canReview(user.getId(), productId)) {
                throw new Exception("You can only review products from delivered orders that haven't been reviewed");
            }

            // Check if already reviewed
            if (reviewService.hasUserReviewed(user.getId(), productId, orderId)) {
                throw new Exception("You have already reviewed this product for this order");
            }

            // Add review
            reviewService.addReview(user.getId(), productId, orderId, rating, comment);

            // Redirect back to product page
            response.sendRedirect(request.getContextPath() + "/product/" + productId);

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.isEmpty()) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Reviews are submitted via POST only
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}
