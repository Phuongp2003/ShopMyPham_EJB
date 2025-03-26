package com.ptithcm.servlet;

import com.ptithcm.ejb.ProductService;
import com.ptithcm.ejb.ReviewService;
import com.ptithcm.entity.Product;
import com.ptithcm.entity.Review;
import java.io.IOException;
import java.util.List;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ProductServlet", urlPatterns = { "/products/*" })
public class ProductServlet extends HttpServlet {

    @EJB
    private ProductService productService;

    @EJB
    private ReviewService reviewService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Show product list
                handleProductList(request, response);
            } else {
                // Show product details
                handleProductDetails(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    private void handleProductList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get search parameter
        String search = request.getParameter("search");

        // Get products
        List<Product> products;
        if (search != null && !search.trim().isEmpty()) {
            products = productService.searchProducts(search.trim());
            request.setAttribute("search", search);
        } else {
            products = productService.getAllProducts();
        }

        request.setAttribute("products", products);
        request.getRequestDispatcher("/WEB-INF/products.jsp").forward(request, response);
    }

    private void handleProductDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Extract product ID from path
        String pathInfo = request.getPathInfo();
        String[] pathParts = pathInfo.split("/");

        if (pathParts.length != 2) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try {
            Long productId = Long.parseLong(pathParts[1]);
            Product product = productService.findById(productId);

            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Get product reviews
            List<Review> reviews = reviewService.getProductReviews(productId);

            request.setAttribute("product", product);
            request.setAttribute("reviews", reviews);
            request.getRequestDispatcher("/WEB-INF/product-details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Product listing only handles GET requests
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}
