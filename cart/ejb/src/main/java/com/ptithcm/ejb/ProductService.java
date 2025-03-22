package com.ptithcm.ejb;

import com.ptithcm.entity.Product;
import java.util.List;
import javax.ejb.Local;

@Local
public interface ProductService {
    List<Product> getAllProducts();
    List<Product> getFeaturedProducts();
    List<Product> searchProducts(String keyword);
    Product findById(Long id);
    void addProduct(Product product);
    void updateProduct(Product product);
    void deleteProduct(Long id);
    boolean isInStock(Long id, int quantity);
    void updateStock(Long id, int change);
}
