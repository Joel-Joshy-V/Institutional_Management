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
  List<HallBooking> _bookings = [];

  HallProvider(this._apiService);

  List<Hall> get halls => _halls;
  bool get isLoading => _isLoading;
  Hall? get selectedHall => _selectedHall;
  String? get error => _error;
  List<HallBooking> get bookings => _bookings;

  // Mock data for halls when API is unavailable
  List<Hall> _getMockHalls() {
    return [
      Hall(
        id: 1,
        name: 'Main Auditorium',
        capacity: '500 people',
        availableSlots: [
          TimeSlot(
            date: '2025-03-24',
            time: '09:00 AM - 12:00 PM',
            isAvailable: true,
          ),
          TimeSlot(
            date: '2025-03-24',
            time: '01:00 PM - 04:00 PM',
            isAvailable: true,
          ),
          TimeSlot(
            date: '2025-03-25',
            time: '09:00 AM - 12:00 PM',
            isAvailable: true,
          ),
        ],
      ),
      Hall(
        id: 2,
        name: 'Conference Room A',
        capacity: '50 people',
        availableSlots: [
          TimeSlot(
            date: '2025-03-24',
            time: '09:00 AM - 11:00 AM',
            isAvailable: true,
          ),
          TimeSlot(
            date: '2025-03-24',
            time: '01:00 PM - 03:00 PM',
            isAvailable: true,
          ),
          TimeSlot(
            date: '2025-03-25',
            time: '10:00 AM - 12:00 PM',
            isAvailable: true,
          ),
        ],
      ),
      Hall(
        id: 3,
        name: 'Seminar Hall',
        capacity: '150 people',
        availableSlots: [
          TimeSlot(
            date: '2025-03-24',
            time: '10:00 AM - 01:00 PM',
            isAvailable: true,
          ),
          TimeSlot(
            date: '2025-03-25',
            time: '02:00 PM - 05:00 PM',
            isAvailable: true,
          ),
        ],
      ),
    ];
  }

  Future<void> fetchHalls() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      try {
        final response = await _apiService.get(
          '/api/halls',
          (json) =>
              (json['data'] as List)
                  .map((item) => Hall.fromJson(item as Map<String, dynamic>))
                  .toList(),
        );
        _halls = response;
      } catch (apiError) {
        // If API call fails, use mock data
        print('API call failed, using mock data: $apiError');
        _halls = _getMockHalls();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error in fetchHalls: $e');
      // Fall back to mock data
      _halls = _getMockHalls();
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

      try {
        await _apiService.post(
          '/api/halls/bookings',
          request.toJson(),
          (json) => HallBooking.fromJson(json['data'] as Map<String, dynamic>),
        );
      } catch (apiError) {
        // If API call fails, create mock booking
        print('API call failed, creating mock booking: $apiError');

        // Add a mock booking to the list
        final mockBooking = HallBooking(
          id: DateTime.now().millisecondsSinceEpoch,
          hallId: request.hallId,
          date: request.date,
          timeSlot: request.timeSlot,
          status: 'Confirmed',
        );
        _bookings.add(mockBooking);

        // Mark the time slot as unavailable
        updateTimeSlotAvailability(
          request.hallId,
          request.date,
          request.timeSlot,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error in bookHall: $e');
      _error = 'Failed to book hall';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update the availability of a time slot after booking
  void updateTimeSlotAvailability(int hallId, String date, String timeSlot) {
    final hallIndex = _halls.indexWhere((hall) => hall.id == hallId);
    if (hallIndex != -1) {
      final hall = _halls[hallIndex];
      final List<TimeSlot> updatedSlots = [];

      for (var slot in hall.availableSlots) {
        if (slot.date == date && slot.time == timeSlot) {
          // Create a new slot with isAvailable set to false
          updatedSlots.add(
            TimeSlot(date: slot.date, time: slot.time, isAvailable: false),
          );
        } else {
          updatedSlots.add(slot);
        }
      }

      // Create a new Hall with updated slots
      _halls[hallIndex] = Hall(
        id: hall.id,
        name: hall.name,
        capacity: hall.capacity,
        availableSlots: updatedSlots,
      );
    }
  }
}
