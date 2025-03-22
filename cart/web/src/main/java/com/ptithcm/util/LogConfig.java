package com.ptithcm.util;

import java.io.IOException;
import java.util.logging.ConsoleHandler;
import java.util.logging.FileHandler;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

public class LogConfig {
    private static FileHandler fileHandler;
    private static final String LOG_FILE = "%t/shopmypham_%g.log"; // Use temp directory with generation number
    private static final int MAX_LOG_SIZE = 10 * 1024 * 1024; // 10MB
    private static final int MAX_LOG_FILES = 5;
    
    public static void setup() {
        try {
            // Create file handler with rotation
            fileHandler = new FileHandler(LOG_FILE, MAX_LOG_SIZE, MAX_LOG_FILES, true);
            fileHandler.setFormatter(new SimpleFormatter());
            fileHandler.setLevel(Level.INFO); // Set to INFO level for file logging
            
            // Configure specific loggers without removing existing handlers
            configureLogger("com.ptithcm.servlet", Level.INFO);
            configureLogger("com.ptithcm.ejb", Level.INFO);
            configureLogger("com.ptithcm.filter", Level.INFO);
            
            Logger.getLogger("LogConfig").info("Custom file logging configured successfully");
            
        } catch (IOException e) {
            Logger.getLogger("LogConfig").severe("Failed to configure custom file logging: " + e.getMessage());
        }
    }
    
    private static void configureLogger(String name, Level level) {
        Logger logger = Logger.getLogger(name);
        logger.setLevel(level);
        
        // Only add file handler if it hasn't been added yet
        boolean hasFileHandler = false;
        for (Handler handler : logger.getHandlers()) {
            if (handler instanceof FileHandler) {
                hasFileHandler = true;
                break;
            }
        }
        
        if (!hasFileHandler) {
            logger.addHandler(fileHandler);
        }
    }
}
