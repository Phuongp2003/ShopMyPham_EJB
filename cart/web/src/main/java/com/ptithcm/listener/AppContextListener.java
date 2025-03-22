package com.ptithcm.listener;

import com.ptithcm.util.LogConfig;
import javax.servlet.ServletContextListener;
import javax.servlet.ServletContextEvent;
import javax.servlet.annotation.WebListener;
import java.util.logging.Logger;

@WebListener
public class AppContextListener implements ServletContextListener {
    private static final Logger LOGGER = Logger.getLogger(AppContextListener.class.getName());
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("Initializing application context...");
        try {
            // Setup logging
            LogConfig.setup();
            LOGGER.info("Logging system initialized");
            
            // Log application startup info
            LOGGER.info("Application context initialized successfully");
            LOGGER.info("Java version: " + System.getProperty("java.version"));
            LOGGER.info("Server info: " + sce.getServletContext().getServerInfo());
            LOGGER.info("Context path: " + sce.getServletContext().getContextPath());
            
        } catch (Exception e) {
            LOGGER.severe("Failed to initialize application context: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("Application context destroyed");
    }
}
