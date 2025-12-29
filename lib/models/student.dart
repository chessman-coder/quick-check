import 'package:flutter_project/models/attendance.dart';

class Student {
  final String id;
  final String name;
  final AttendanceStatus attendanceStatus;
  
  const Student({
    required this.id,
    required this.name,
    required this.attendanceStatus,
  });
}
