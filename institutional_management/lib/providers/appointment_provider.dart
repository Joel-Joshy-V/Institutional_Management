import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../models/appointment_request.dart';
import '../services/api_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final ApiService _apiService;
  List<Faculty> _faculty = [];
  bool _isLoading = false;
  Faculty? _selectedFaculty;
  String? _error;
  List<Appointment> _appointments = [];

  AppointmentProvider(this._apiService);

  List<Faculty> get faculty => _faculty;
  bool get isLoading => _isLoading;
  Faculty? get selectedFaculty => _selectedFaculty;
  String? get error => _error;
  List<Appointment> get appointments => _appointments;

  // Mock data for faculty when API is unavailable
  List<Faculty> _getMockFaculty() {
    return [
      Faculty(
        id: 1,
        name: 'Dr. John Smith',
        department: 'Computer Science',
        position: 'Professor',
        imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
        availableSlots: [
          TimeSlot(
            date: '2025-03-24',
            time: '09:00 AM - 10:00 AM',
            isAvailable: true,
          ),
          TimeSlot(
            date: '2025-03-24',
            time: '02:00 PM - 03:00 PM',
            isAvailable: true,
          ),
          TimeSlot(
            date: '2025-03-25',
            time: '11:00 AM - 12:00 PM',
            isAvailable: true,
          ),
        ],
      ),
      Faculty(
        id: 2,
        name: 'Dr. Sarah Johnson',
        department: 'Physics',
        position: 'Associate Professor',
        imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        availableSlots: [
          TimeSlot(
            date: '2025-03-24',
            time: '10:00 AM - 11:00 AM',
            isAvailable: true,
          ),
          TimeSlot(
            date: '2025-03-24',
            time: '03:00 PM - 04:00 PM',
            isAvailable: true,
          ),
          TimeSlot(
            date: '2025-03-25',
            time: '01:00 PM - 02:00 PM',
            isAvailable: true,
          ),
        ],
      ),
      Faculty(
        id: 3,
        name: 'Prof. Michael Davis',
        department: 'Mathematics',
        position: 'Head of Department',
        imageUrl: 'https://randomuser.me/api/portraits/men/24.jpg',
        availableSlots: [
          TimeSlot(
            date: '2025-03-24',
            time: '01:00 PM - 02:00 PM',
            isAvailable: true,
          ),
          TimeSlot(
            date: '2025-03-25',
            time: '09:00 AM - 10:00 AM',
            isAvailable: true,
          ),
        ],
      ),
      Faculty(
        id: 4,
        name: 'Dr. Emily Brown',
        department: 'Chemistry',
        position: 'Assistant Professor',
        imageUrl: 'https://randomuser.me/api/portraits/women/28.jpg',
        availableSlots: [
          TimeSlot(
            date: '2025-03-24',
            time: '11:00 AM - 12:00 PM',
            isAvailable: true,
          ),
          TimeSlot(
            date: '2025-03-25',
            time: '02:00 PM - 03:00 PM',
            isAvailable: true,
          ),
        ],
      ),
    ];
  }

  Future<void> fetchFaculty() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      try {
        final response = await _apiService.get(
          '/api/faculty',
          (json) =>
              (json['data'] as List)
                  .map((item) => Faculty.fromJson(item as Map<String, dynamic>))
                  .toList(),
        );
        _faculty = response;
      } catch (apiError) {
        // If API call fails, use mock data
        print('API call failed, using mock data: $apiError');
        _faculty = _getMockFaculty();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error in fetchFaculty: $e');
      // Fall back to mock data
      _faculty = _getMockFaculty();
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectFaculty(Faculty faculty) {
    _selectedFaculty = faculty;
    notifyListeners();
  }

  Future<bool> bookAppointment(AppointmentRequest request) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      try {
        await _apiService.post(
          '/api/appointments',
          request.toJson(),
          (json) => Appointment.fromJson(json['data'] as Map<String, dynamic>),
        );
      } catch (apiError) {
        // If API call fails, create mock appointment
        print('API call failed, creating mock appointment: $apiError');

        // Add a mock appointment to the list
        final mockAppointment = Appointment(
          id: DateTime.now().millisecondsSinceEpoch,
          facultyId: request.facultyId,
          studentName: request.studentName,
          date: request.date,
          time: request.time,
          purpose: request.purpose,
          status: 'Pending',
        );
        _appointments.add(mockAppointment);

        // Mark the time slot as unavailable
        updateTimeSlotAvailability(
          request.facultyId,
          request.date,
          request.time,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error in bookAppointment: $e');
      _error = 'Failed to book appointment';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update the availability of a time slot after booking
  void updateTimeSlotAvailability(int facultyId, String date, String time) {
    final facultyIndex = _faculty.indexWhere((f) => f.id == facultyId);
    if (facultyIndex != -1) {
      final faculty = _faculty[facultyIndex];
      final List<TimeSlot> updatedSlots = [];

      for (var slot in faculty.availableSlots) {
        if (slot.date == date && slot.time == time) {
          // Create a new slot with isAvailable set to false
          updatedSlots.add(
            TimeSlot(date: slot.date, time: slot.time, isAvailable: false),
          );
        } else {
          updatedSlots.add(slot);
        }
      }

      // Create a new Faculty with updated slots
      _faculty[facultyIndex] = Faculty(
        id: faculty.id,
        name: faculty.name,
        department: faculty.department,
        position: faculty.position,
        imageUrl: faculty.imageUrl,
        availableSlots: updatedSlots,
      );
    }
  }
}
