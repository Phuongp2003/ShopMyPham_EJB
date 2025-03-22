package com.ptithcm.servlet;

import com.ptithcm.ejb.UserService;
import com.ptithcm.entity.User;
import java.io.IOException;
import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AuthServlet extends HttpServlet {
    
    @EJB
    private UserService userService;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/logout".equals(path)) {
            // Handle logout
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Forward to appropriate JSP
        String jspPath = "/login".equals(path) ? "/WEB-INF/login.jsp" : "/WEB-INF/register.jsp";
        request.getRequestDispatcher(jspPath).forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        try {
            if ("/login".equals(path)) {
                handleLogin(request, response);
            } else if ("/register".equals(path)) {
                handleRegister(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            String jspPath = "/login".equals(path) ? "/WEB-INF/login.jsp" : "/WEB-INF/register.jsp";
            request.getRequestDispatcher(jspPath).forward(request, response);
        }
    }
    
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws Exception, ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validate input
        if (username == null || password == null || 
            username.trim().isEmpty() || password.trim().isEmpty()) {
            throw new Exception("Username and password are required");
        }
        
        // Attempt login
        User user = userService.login(username, password);
        
        // Create session and store user
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        
        // Redirect to home page
        response.sendRedirect(request.getContextPath() + "/home");
    }
    
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws Exception, ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        // Validate input
        if (username == null || password == null || confirmPassword == null || 
            fullName == null || email == null || phone == null || address == null ||
            username.trim().isEmpty() || password.trim().isEmpty() || 
            confirmPassword.trim().isEmpty() || fullName.trim().isEmpty() || 
            email.trim().isEmpty() || phone.trim().isEmpty() || address.trim().isEmpty()) {
            throw new Exception("All fields are required");
        }
        
        if (!password.equals(confirmPassword)) {
            throw new Exception("Passwords do not match");
        }
        
        // Register user
        User user = userService.register(username, password, fullName, email, phone, address);
        
        // Create session and store user
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        
        // Redirect to home page
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
