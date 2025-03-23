class AppointmentRequest {
  final int facultyId;
  final String studentName;
  final String date;
  final String time;
  final String purpose;

  AppointmentRequest({
    required this.facultyId,
    required this.studentName,
    required this.date,
    required this.time,
    required this.purpose,
  });

  Map<String, dynamic> toJson() {
    return {
      'facultyId': facultyId,
      'studentName': studentName,
      'date': date,
      'time': time,
      'purpose': purpose,
    };
  }
}
