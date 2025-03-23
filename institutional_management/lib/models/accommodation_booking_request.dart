class AccommodationBookingRequest {
  final int accommodationId;
  final String checkIn;
  final String checkOut;
  final String purpose;

  AccommodationBookingRequest({
    required this.accommodationId,
    required this.checkIn,
    required this.checkOut,
    required this.purpose,
  });

  Map<String, dynamic> toJson() => {
    'accommodationId': accommodationId,
    'checkIn': checkIn,
    'checkOut': checkOut,
    'purpose': purpose,
  };
}

class AccommodationBooking {
  final int id;
  final int accommodationId;
  final String checkIn;
  final String checkOut;
  final String status;

  AccommodationBooking({
    required this.id,
    required this.accommodationId,
    required this.checkIn,
    required this.checkOut,
    required this.status,
  });

  factory AccommodationBooking.fromJson(Map<String, dynamic> json) {
    return AccommodationBooking(
      id: json['id'],
      accommodationId: json['accommodationId'],
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      status: json['status'],
    );
  }
} 