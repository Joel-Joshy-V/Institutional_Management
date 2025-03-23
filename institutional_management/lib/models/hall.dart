class Hall {
  final int id;
  final String name;
  final String capacity;
  final List<TimeSlot> availableSlots;

  Hall({
    required this.id,
    required this.name,
    required this.capacity,
    required this.availableSlots,
  });

  factory Hall.fromJson(Map<String, dynamic> json) {
    return Hall(
      id: json['id'],
      name: json['name'],
      capacity: json['capacity'],
      availableSlots:
          (json['availableSlots'] as List)
              .map((slot) => TimeSlot.fromJson(slot))
              .toList(),
    );
  }
}

class TimeSlot {
  final String date;
  final String time;
  final bool isAvailable;

  TimeSlot({required this.date, required this.time, required this.isAvailable});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      date: json['date'],
      time: json['time'],
      isAvailable: json['isAvailable'],
    );
  }
}
