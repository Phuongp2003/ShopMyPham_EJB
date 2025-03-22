package com.ptithcm.ejb;

import com.ptithcm.entity.Product;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class ProductServiceBean implements ProductService {
    private static final Logger LOGGER = Logger.getLogger(ProductServiceBean.class.getName());
    
    @PersistenceContext(unitName = "CosmeticsPU")
    private EntityManager em;
    
    @Override
    public List<Product> getAllProducts() {
        LOGGER.fine("Getting all products");
        try {
            TypedQuery<Product> query = em.createQuery("SELECT p FROM Product p ORDER BY p.id", Product.class);
            List<Product> products = query.getResultList();
            LOGGER.info("Found " + products.size() + " products");
            return products;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting all products", e);
            throw new RuntimeException("Failed to get products", e);
        }
    }
    
    @Override
    public List<Product> getFeaturedProducts() {
        LOGGER.fine("Getting featured products");
        try {
            TypedQuery<Product> query = em.createQuery(
                "SELECT p FROM Product p WHERE p.stock > 0 ORDER BY p.averageRating DESC",
                Product.class);
            query.setMaxResults(9);
            List<Product> products = query.getResultList();
            LOGGER.info("Found " + products.size() + " featured products");
            return products;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting featured products", e);
            throw new RuntimeException("Failed to get featured products", e);
        }
    }
    
    @Override
    public List<Product> searchProducts(String keyword) {
        LOGGER.fine("Searching for products with keyword: " + keyword);
        try {
            TypedQuery<Product> query = em.createQuery(
                "SELECT p FROM Product p WHERE LOWER(p.name) LIKE :keyword OR LOWER(p.description) LIKE :keyword",
                Product.class);
            query.setParameter("keyword", "%" + keyword.toLowerCase() + "%");
            List<Product> products = query.getResultList();
            LOGGER.info("Found " + products.size() + " products matching keyword: " + keyword);
            return products;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error searching products", e);
            throw new RuntimeException("Failed to search products", e);
        }
    }
    
    @Override
    public Product findById(Long id) {
        LOGGER.fine("Finding product by ID: " + id);
        try {
            Product product = em.find(Product.class, id);
            if (product == null) {
                LOGGER.warning("No product found with ID: " + id);
            } else {
                LOGGER.fine("Found product: " + product.getName());
            }
            return product;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding product by ID: " + id, e);
            throw new RuntimeException("Failed to find product", e);
        }
    }
    
    @Override
    public void addProduct(Product product) {
        LOGGER.fine("Adding new product: " + product.getName());
        try {
            em.persist(product);
            em.flush();
            LOGGER.info("Successfully added product with ID: " + product.getId());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding product", e);
            throw new RuntimeException("Failed to add product", e);
        }
    }
    
    @Override
    public void updateProduct(Product product) {
        LOGGER.fine("Updating product: " + product.getId());
        try {
            em.merge(product);
            em.flush();
            LOGGER.info("Successfully updated product: " + product.getName());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating product", e);
            throw new RuntimeException("Failed to update product", e);
        }
    }
    
    @Override
    public void deleteProduct(Long id) {
        LOGGER.fine("Deleting product with ID: " + id);
        try {
            Product product = findById(id);
            if (product != null) {
                em.remove(product);
                em.flush();
                LOGGER.info("Successfully deleted product: " + product.getName());
            } else {
                LOGGER.warning("Cannot delete - product not found with ID: " + id);
                throw new RuntimeException("Product not found");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting product", e);
            throw new RuntimeException("Failed to delete product", e);
        }
    }
    
    @Override
    public boolean isInStock(Long id, int quantity) {
        LOGGER.fine("Checking stock for product ID: " + id + ", requested quantity: " + quantity);
        try {
            Product product = findById(id);
            if (product == null) {
                LOGGER.warning("Product not found for stock check with ID: " + id);
                return false;
            }
            boolean inStock = product.getStock() >= quantity;
            LOGGER.fine("Stock check result: " + inStock + " (available: " + product.getStock() + ")");
            return inStock;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking stock", e);
            throw new RuntimeException("Failed to check stock", e);
        }
    }
    
    @Override
    public void updateStock(Long id, int change) {
        LOGGER.fine("Updating stock for product ID: " + id + ", change: " + change);
        try {
            Product product = findById(id);
            if (product == null) {
                LOGGER.severe("Cannot update stock - product not found with ID: " + id);
                throw new RuntimeException("Product not found");
            }
            
            int newStock = product.getStock() + change;
            if (newStock < 0) {
                LOGGER.severe("Stock update would result in negative quantity");
                throw new RuntimeException("Insufficient stock");
            }
            
            product.setStock(newStock);
            updateProduct(product);
            LOGGER.info("Successfully updated stock for product " + product.getName() + 
                       " (new stock: " + newStock + ")");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating stock", e);
            throw new RuntimeException("Failed to update stock", e);
        }
    }
}
