import 'package:flutter/foundation.dart';
import '../../models/hall.dart';
import '../../models/hall_booking_request.dart';
import '../../services/api_service.dart';

class HallProvider extends ChangeNotifier {
  final ApiService _apiService;
  List<Hall> _halls = [];
  Hall? _selectedHall;
  bool _isLoading = false;

  HallProvider(this._apiService);

  Future<void> fetchHalls() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.get(
        '/api/halls',
        (json) => (json['data'] as List)
            .map((item) => Hall.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
      _halls = response;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> bookHall(HallBookingRequest request) async {
    try {
      final response = await _apiService.post(
        '/api/halls/bookings',
        request.toJson(),
        (json) => HallBooking.fromJson(json['data'] as Map<String, dynamic>),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
