package com.ptithcm.ejb;

import com.ptithcm.entity.User;
import javax.ejb.Remote;

@Remote
public interface UserService {
    User register(String username, String password, String fullName, String email, String phone, String address) throws Exception;
    User login(String username, String password) throws Exception;
    User findById(Long id);
    User findByUsername(String username);
    void updateUser(User user) throws Exception;
}
