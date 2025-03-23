package com.example.institutional_management.service;

import com.example.institutional_management.model.AuthRequest;
import com.example.institutional_management.model.AuthResponse;

public interface AuthService {
    AuthResponse login(AuthRequest request);
}
