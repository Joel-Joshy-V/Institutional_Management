import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../config/api_config.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._apiService);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.post(
        ApiConfig.login,
        {'email': email, 'password': password},
        (json) {
          // Handle the AuthResponse format from the backend
          final token = json['token'] as String;

          // Store the token in the API service for future requests
          _apiService.setAuthToken(token);

          // Convert the response to a User object
          return User(
            id: json['id'] is String ? int.parse(json['id']) : json['id'],
            name: json['name'],
            email: json['email'],
            role: json['role'],
            token: token,
          );
        },
      );

      _currentUser = response;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to login: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _apiService.setAuthToken(''); // Clear the token
    _currentUser = null;
    notifyListeners();
  }
}
