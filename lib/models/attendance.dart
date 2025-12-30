class Attendance {
  final String id;
  final String studentId;
  final DateTime date;
  final AttendanceStatus status;

  Attendance({
    required this.id,
    required this.studentId,
    required this.date,
    required this.status,
  });
}

enum AttendanceStatus { present, absent }
