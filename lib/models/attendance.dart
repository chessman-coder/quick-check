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

  Map<String, dynamic> toJson() => {
    'id': id,
    'studentId': studentId,
    'date': date.toIso8601String(),
    'status': status.name,
  };

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    id: json['id'],
    studentId: json['studentId'],
    date: DateTime.parse(json['date']),
    status: AttendanceStatus.values.firstWhere((e) => e.name == json['status']),
  );
}

enum AttendanceStatus { present, absent, late }
