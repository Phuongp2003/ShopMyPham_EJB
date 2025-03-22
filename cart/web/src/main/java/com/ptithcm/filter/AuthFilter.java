package com.ptithcm.filter;

import com.ptithcm.entity.User;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String loginURI = httpRequest.getContextPath() + "/login";
        boolean isLoginPage = httpRequest.getRequestURI().equals(loginURI);
        boolean isLoginRequest = httpRequest.getRequestURI().contains("login");
        boolean isRegisterRequest = httpRequest.getRequestURI().contains("register");
        
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        
        if (isLoggedIn && (isLoginPage || isLoginRequest || isRegisterRequest)) {
            // User is logged in and trying to access login/register page
            // Redirect to home
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home");
        } else if (isLoggedIn || isLoginRequest || isRegisterRequest) {
            // User is logged in or trying to log in/register
            // Allow the request
            chain.doFilter(request, response);
        } else {
            // User is not logged in and trying to access protected page
            // Redirect to login page
            httpResponse.sendRedirect(loginURI);
        }
    }
    
    @Override
    public void destroy() {
    }
}
