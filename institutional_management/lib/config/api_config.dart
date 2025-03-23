class ApiConfig {
  // Use 10.0.2.2 which is the special IP address to reach the host from Android emulator
  // If using a physical device, you'll need to use your computer's actual IP address on your network
  static const String baseUrl = 'http://10.0.2.2:8090/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // Canteen endpoints
  static const String foodItems = '/canteen/food-items';
  static const String orders = '/canteen/orders';
  static const String orderHistory = '/canteen/orders/history';

  // Accommodation endpoints
  static const String rooms = '/accommodation/rooms';
  static const String bookings = '/accommodation/bookings';
  static const String bookingHistory = '/accommodation/bookings/history';

  // User endpoints
  static const String userProfile = '/users/profile';
  static const String updateProfile = '/users/profile/update';
}
