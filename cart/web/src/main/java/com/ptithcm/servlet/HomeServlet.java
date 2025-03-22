package com.ptithcm.servlet;

import com.ptithcm.ejb.ProductService;
import com.ptithcm.entity.Product;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.EJB;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "HomeServlet", urlPatterns = { "/home" }) // Make sure this is the only mapping
public class HomeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(HomeServlet.class.getName());

    @EJB
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        // Set logging level to FINE for more detailed logs
        LOGGER.setLevel(Level.FINE);
        LOGGER.info("Initializing HomeServlet");
        super.init();

        try {
            LOGGER.info("Checking ProductService injection");
            if (productService == null) {
                LOGGER.warning("ProductService was not injected, attempting manual JNDI lookup");
                InitialContext ctx = new InitialContext();
                productService = (ProductService) ctx.lookup("java:global/shopmypham-web-1.0/ProductServiceBean");

                if (productService != null) {
                    LOGGER.info("Manual JNDI lookup successful");
                } else {
                    LOGGER.severe("Failed to obtain ProductService through JNDI lookup");
                }
            } else {
                LOGGER.info("ProductService successfully injected");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during servlet initialization", e);
            throw new ServletException("Failed to initialize HomeServlet", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            if (productService == null) {
                throw new ServletException("Không thể kết nối đến dịch vụ sản phẩm. Vui lòng thử lại sau.");
            }

            List<Product> products = null;
            try {
                products = productService.getFeaturedProducts();
                if (products == null) {
                    throw new ServletException("Không thể tải danh sách sản phẩm");
                }
            } catch (Exception e) {
                LOGGER.severe("Error calling getFeaturedProducts: " + e.getMessage());
                throw new ServletException("Lỗi khi tải danh sách sản phẩm: " + e.getMessage());
            }

            request.setAttribute("products", products);
            request.getRequestDispatcher("/WEB-INF/home.jsp").forward(request, response);

        } catch (Exception e) {
            Throwable rootCause = e;
            while (rootCause.getCause() != null) {
                rootCause = rootCause.getCause();
            }

            String userMessage;
            if (rootCause.getMessage().contains("Table") && rootCause.getMessage().contains("doesn't exist")) {
                userMessage = "Lỗi cấu hình database: Bảng dữ liệu chưa được tạo";
            } else if (rootCause.getMessage().contains("Communications link failure")) {
                userMessage = "Không thể kết nối đến database. Vui lòng kiểm tra kết nối";
            } else {
                userMessage = "Lỗi hệ thống: " + rootCause.getMessage();
            }

            request.setAttribute("errorTitle", "Lỗi");
            request.setAttribute("errorMessage", userMessage);
            request.setAttribute("errorDetail", rootCause.getMessage());
            request.getRequestDispatcher("/WEB-INF/error.jsp").forward(request, response);
        }
    }
}
