import 'package:flutter/material.dart';
import '../models/hall.dart';
import '../models/hall_booking_request.dart';
import '../services/api_service.dart';

class HallProvider extends ChangeNotifier {
  final ApiService _apiService;
  List<Hall> _halls = [];
  bool _isLoading = false;
  Hall? _selectedHall;
  String? _error;

  HallProvider(this._apiService);

  List<Hall> get halls => _halls;
  bool get isLoading => _isLoading;
  Hall? get selectedHall => _selectedHall;
  String? get error => _error;

  Future<void> fetchHalls() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.get(
        '/api/halls',
        (json) =>
            (json['data'] as List)
                .map((item) => Hall.fromJson(item as Map<String, dynamic>))
                .toList(),
      );

      _halls = response;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch halls';
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectHall(Hall hall) {
    _selectedHall = hall;
    notifyListeners();
  }

  Future<bool> bookHall(HallBookingRequest request) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _apiService.post(
        '/api/halls/bookings',
        request.toJson(),
        (json) => HallBooking.fromJson(json['data'] as Map<String, dynamic>),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to book hall';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
