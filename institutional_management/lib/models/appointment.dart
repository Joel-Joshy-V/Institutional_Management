class Faculty {
  final int id;
  final String name;
  final String department;
  final String position;
  final String imageUrl;
  final List<TimeSlot> availableSlots;

  Faculty({
    required this.id,
    required this.name,
    required this.department,
    required this.position,
    required this.imageUrl,
    required this.availableSlots,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['id'],
      name: json['name'],
      department: json['department'],
      position: json['position'],
      imageUrl: json['imageUrl'],
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

class Appointment {
  final int id;
  final int facultyId;
  final String studentName;
  final String date;
  final String time;
  final String purpose;
  final String status;

  Appointment({
    required this.id,
    required this.facultyId,
    required this.studentName,
    required this.date,
    required this.time,
    required this.purpose,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      facultyId: json['facultyId'],
      studentName: json['studentName'],
      date: json['date'],
      time: json['time'],
      purpose: json['purpose'],
      status: json['status'],
    );
  }
}
