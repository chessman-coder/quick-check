import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attendance.dart';
import '../models/class.dart';
import '../models/student.dart';

class ClassService {
  static const String _classesKey = 'classes';
  static const String _studentsKey = 'students';
  static const String _attendanceKey = 'attendance';

  static SharedPreferences? _prefs;
  static List<Class> _classes = [];
  static List<Student> _students = [];
  static List<Attendance> _attendanceRecords = [];

  static List<Class> get classes => _classes;
  static List<Student> get students => _students;
  static List<Attendance> get attendanceRecords => _attendanceRecords;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadClasses();
    await _loadStudents();
    await _loadAttendance();
  }

  // Load classes from SharedPreferences
  static Future<void> _loadClasses() async {
    final String? jsonString = _prefs?.getString(_classesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _classes = jsonList.map((json) => Class.fromJson(json)).toList();
    }
  }

  // Load students from SharedPreferences
  static Future<void> _loadStudents() async {
    final String? jsonString = _prefs?.getString(_studentsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _students = jsonList.map((json) => Student.fromJson(json)).toList();
    }
  }

  // Load attendance from SharedPreferences
  static Future<void> _loadAttendance() async {
    final String? jsonString = _prefs?.getString(_attendanceKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _attendanceRecords = jsonList
          .map((json) => Attendance.fromJson(json))
          .toList();
    }
  }

  // Save attendance to SharedPreferences
  static Future<void> _saveAttendance() async {
    final jsonList = _attendanceRecords.map((a) => a.toJson()).toList();
    await _prefs?.setString(_attendanceKey, jsonEncode(jsonList));
  }

  // Save classes to SharedPreferences
  static Future<void> _saveClasses() async {
    final jsonList = _classes.map((c) => c.toJson()).toList();
    await _prefs?.setString(_classesKey, jsonEncode(jsonList));
  }

  // Save students to SharedPreferences
  static Future<void> _saveStudents() async {
    final jsonList = _students.map((s) => s.toJson()).toList();
    await _prefs?.setString(_studentsKey, jsonEncode(jsonList));
  }

  // Generate unique ID
  static String generateId() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  // create class
  static Future<void> createClass(
    String className,
    List<String> studentNames,
  ) async {
    final classId = generateId();
    final List<String> studentIds = [];

    // Create students
    for (var name in studentNames) {
      if (name.isNotEmpty) {
        final studentId = generateId();
        _students.add(Student(id: studentId, name: name, classId: classId));
        studentIds.add(studentId);
      }
    }

    _classes.add(Class(id: classId, name: className, studentIds: studentIds));

    await _saveClasses();
    await _saveStudents();
  }

  // delete
  static Future<void> deleteClass(String classId) async {
    _classes.removeWhere((c) => c.id == classId);
    _students.removeWhere((s) => s.classId == classId);
    await _saveClasses();
    await _saveStudents();
  }

  static Future<void> deleteStudent(String studentId) async {
    _students.removeWhere((s) => s.id == studentId);
    await _saveStudents();
  }

  static List<Student> getStudentsByClassId(String classId) {
    return _students.where((s) => s.classId == classId).toList();
  }

  static Class? getClassById(String classId) {
    try {
      return _classes.firstWhere((c) => c.id == classId);
    } catch (e) {
      return null;
    }
  }

  // Mark or update attendance for a student on a specific date
  static Future<void> markAttendance(
    String studentId,
    DateTime date,
    AttendanceStatus status,
  ) async {
    // Normalize date to ignore time
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // Check if attendance already exists for this student on this date
    final existingIndex = _attendanceRecords.indexWhere(
      (a) =>
          a.studentId == studentId &&
          a.date.year == normalizedDate.year &&
          a.date.month == normalizedDate.month &&
          a.date.day == normalizedDate.day,
    );

    if (existingIndex != -1) {
      // Update existing attendance
      _attendanceRecords[existingIndex] = Attendance(
        id: _attendanceRecords[existingIndex].id,
        studentId: studentId,
        date: normalizedDate,
        status: status,
      );
    } else {
      // Create new attendance record
      _attendanceRecords.add(
        Attendance(
          id: generateId(),
          studentId: studentId,
          date: normalizedDate,
          status: status,
        ),
      );
    }

    await _saveAttendance();
  }

  // Get attendance for a student on a specific date
  static Attendance? getAttendance(String studentId, DateTime date) {
    try {
      return _attendanceRecords.firstWhere(
        (a) =>
            a.studentId == studentId &&
            a.date.year == date.year &&
            a.date.month == date.month &&
            a.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }

  // Get all attendance records for a specific date
  static List<Attendance> getAttendanceByDate(DateTime date) {
    return _attendanceRecords
        .where(
          (a) =>
              a.date.year == date.year &&
              a.date.month == date.month &&
              a.date.day == date.day,
        )
        .toList();
  }

  // Update class and its students
  static Future<void> updateClass(
    String classId,
    String className,
    List<Student> updatedStudents,
  ) async {
    // Update class name
    final classIndex = _classes.indexWhere((c) => c.id == classId);
    if (classIndex != -1) {
      _classes[classIndex] = Class(
        id: classId,
        name: className,
        studentIds: updatedStudents.map((s) => s.id).toList(),
      );
    }

    // Remove old students for this class
    _students.removeWhere((s) => s.classId == classId);

    // Add updated students
    _students.addAll(updatedStudents);

    await _saveClasses();
    await _saveStudents();
  }

  // Update a single student's name
  static Future<void> updateStudent(String studentId, String newName) async {
    final index = _students.indexWhere((s) => s.id == studentId);
    if (index != -1) {
      _students[index] = Student(
        id: studentId,
        name: newName,
        classId: _students[index].classId,
      );
      await _saveStudents();
    }
  }

  // Clear all data
  static Future<void> clearAll() async {
    _classes.clear();
    _students.clear();
    await _prefs?.remove(_classesKey);
    await _prefs?.remove(_studentsKey);
  }
}
