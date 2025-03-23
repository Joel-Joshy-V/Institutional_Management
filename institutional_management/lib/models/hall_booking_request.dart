class HallBookingRequest {
  final int hallId;
  final String date;
  final String timeSlot;
  final String purpose;

  HallBookingRequest({
    required this.hallId,
    required this.date,
    required this.timeSlot,
    required this.purpose,
  });

  Map<String, dynamic> toJson() {
    return {
      'hallId': hallId,
      'date': date,
      'timeSlot': timeSlot,
      'purpose': purpose,
    };
  }
}

class HallBooking {
  final int id;
  final int hallId;
  final String date;
  final String timeSlot;
  final String status;

  HallBooking({
    required this.id,
    required this.hallId,
    required this.date,
    required this.timeSlot,
    required this.status,
  });

  factory HallBooking.fromJson(Map<String, dynamic> json) {
    return HallBooking(
      id: json['id'],
      hallId: json['hallId'],
      date: json['date'],
      timeSlot: json['timeSlot'],
      status: json['status'],
    );
  }
} 