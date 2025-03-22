package com.ptithcm.servlet;

import com.ptithcm.ejb.UserService;
import com.ptithcm.entity.User;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    @EJB
    private UserService userService;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        System.out.println("Username: " + username);
        System.out.println("Password: " + password);
        
        try {
            User user = userService.login(username, password);
            
            if (user != null) {
                // Đăng nhập thành công
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                // Redirect về trang trước đó hoặc trang chủ
                String redirectURL = request.getHeader("Referer");
                if (redirectURL != null && !redirectURL.contains("/login")) {
                    response.sendRedirect(redirectURL);
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            } else {
                // Đăng nhập thất bại
                request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
                request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi đăng nhập: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
        }
    }
}
