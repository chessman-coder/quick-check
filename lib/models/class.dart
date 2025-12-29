import 'package:flutter_project/models/student.dart';

class Class {
  final String id;
  final String name;
  final List<Student> students;

  const Class({
    required this.id,
    required this.name,
    required this.students
  });
}
