package com.ptithcm.ejb;

import com.ptithcm.entity.User;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

@Stateless
public class UserServiceBean implements UserService {
    
    @PersistenceContext
    private EntityManager em;
    
    @Override
    public User register(String username, String password, String fullName, 
            String email, String phone, String address) throws Exception {
        // Check if username exists
        if (findByUsername(username) != null) {
            throw new Exception("Username already exists");
        }
        
        User user = new User();
        user.setUsername(username);
        user.setPassword(hashPassword(password));
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);
        
        em.persist(user);
        return user;
    }

    @Override
    public User login(String username, String password) throws Exception {
        try {
            TypedQuery<User> query = em.createQuery(
                "SELECT u FROM User u WHERE u.username = :username AND u.password = :password", 
                User.class);
            query.setParameter("username", username);
            query.setParameter("password", hashPassword(password));
            
            return query.getSingleResult();
        } catch (NoResultException e) {
            throw new Exception("Invalid username or password");
        }
    }

    @Override
    public User findById(Long id) {
        return em.find(User.class, id);
    }

    @Override
    public User findByUsername(String username) {
        try {
            TypedQuery<User> query = em.createQuery(
                "SELECT u FROM User u WHERE u.username = :username", 
                User.class);
            query.setParameter("username", username);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    @Override
    public void updateUser(User user) throws Exception {
        User existingUser = findById(user.getId());
        if (existingUser == null) {
            throw new Exception("User not found");
        }
        
        // If password is empty, keep the old password
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            user.setPassword(existingUser.getPassword());
        } else {
            user.setPassword(hashPassword(user.getPassword()));
        }
        
        em.merge(user);
    }
    
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
}
