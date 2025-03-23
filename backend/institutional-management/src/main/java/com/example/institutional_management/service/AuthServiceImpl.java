package com.example.institutional_management.service;

import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.institutional_management.config.JwtUtil;
import com.example.institutional_management.model.AuthRequest;
import com.example.institutional_management.model.AuthResponse;
import com.example.institutional_management.model.User;
import com.example.institutional_management.repository.UserRepository;

@Service
public class AuthServiceImpl implements AuthService {

    private static final Logger logger = LoggerFactory.getLogger(AuthServiceImpl.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Override
    public AuthResponse login(AuthRequest request) {
        logger.debug("Attempting login for email: {}", request.getEmail());
        
        // TEMPORARY TEST CASE: Allow a hardcoded test user to log in for testing purposes
        if ("test@example.com".equals(request.getEmail()) && "password".equals(request.getPassword())) {
            logger.debug("Using test account with plain password");
            
            // Create a test user or fetch from database
            Optional<User> optionalUser = userRepository.findByEmail(request.getEmail());
            User user;
            
            if (optionalUser.isPresent()) {
                user = optionalUser.get();
                logger.debug("Test user found in database: {}", user);
            } else {
                // Create a dummy user for testing if not in DB
                user = new User();
                user.setId(1L);
                user.setName("Test User");
                user.setEmail("test@example.com");
                user.setRole("ADMIN");
                logger.debug("Created dummy test user: {}", user);
            }
            
            String token = jwtUtil.generateToken(user.getEmail());
            logger.debug("Generated token for test user");
            
            return new AuthResponse(
                    user.getId(),
                    user.getName(),
                    user.getEmail(),
                    user.getRole(),
                    token
            );
        }
        
        // Normal authentication flow
        logger.debug("Proceeding with normal authentication");
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("User not found with email: " + request.getEmail()));

        logger.debug("User found: {}", user);
        
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            logger.error("Password doesn't match for user: {}", request.getEmail());
            throw new RuntimeException("Invalid credentials - password doesn't match");
        }

        String token = jwtUtil.generateToken(user.getEmail());
        logger.debug("Authentication successful, token generated");

        return new AuthResponse(
                user.getId(),
                user.getName(),
                user.getEmail(),
                user.getRole(),
                token
        );
    }
} 