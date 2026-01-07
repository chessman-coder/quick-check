import 'package:flutter/material.dart';
import 'package:flutter_project/data/class_service.dart';
import 'package:flutter_project/models/attendance.dart';
import 'package:flutter_project/models/student.dart';

class AttendanceScreen extends StatefulWidget {
  final DateTime selectedDate;
  final String classId;
  final String className;

  const AttendanceScreen({
    super.key,
    required this.selectedDate,
    required this.classId,
    required this.className,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Student> students = ClassService.getStudentsByClassId(
      widget.classId,
    );
    Widget content = ListView.separated(
      itemCount: students.length,
      separatorBuilder: (context, index) =>
          const Divider(color: Color(0xFF5597FF), thickness: 2, height: 1),
      itemBuilder: (context, index) {
        return StudentTile(
          key: ValueKey(
            '${students[index].id}_${_selectedDate.toIso8601String()}',
          ),
          index: index + 1,
          student: students[index],
          selectedDate: _selectedDate,
        );
      },
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${widget.className} Attendance',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total Students: ${students.length}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF858585),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: const BorderSide(
                        color: Color(0xFF5597FF),
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Table header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                children: [
                  Text(
                    'Full Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    'Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  // const SizedBox(width: 30),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: Color(0xFF5597FF), thickness: 2, height: 1),
            Expanded(child: content),
            const Divider(color: Color(0xFF5597FF), thickness: 2, height: 1),
          ],
        ),
      ),
    );
  }
}

class StudentTile extends StatefulWidget {
  final int index;
  final Student student;
  final DateTime selectedDate;

  const StudentTile({
    super.key,
    required this.index,
    required this.student,
    required this.selectedDate,
  });

  @override
  State<StudentTile> createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  @override
  void didUpdateWidget(StudentTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload attendance if date changes
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadAttendance();
    }
  }

  void _loadAttendance() {
    final attendance = ClassService.getAttendance(
      widget.student.id,
      widget.selectedDate,
    );
    setState(() {
      _selectedStatus = attendance?.status.name;
    });
  }

  void _markAttendance(String status) async {
    final attendanceStatus = AttendanceStatus.values.firstWhere(
      (e) => e.name == status,
    );
    await ClassService.markAttendance(
      widget.student.id,
      widget.selectedDate,
      attendanceStatus,
    );
    setState(() {
      _selectedStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Text(
            '${widget.index}. ${widget.student.name}',
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),

          SizedBox(
            width: 120,
            child: _selectedStatus != null
                ? _buildStatusText()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildStatusButton(
                        status: 'present',
                        color: const Color(0xFF4CAF50),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusButton(
                        status: 'absent',
                        color: const Color(0xFFF44336),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusButton(
                        status: 'late',
                        color: const Color(0xFFFF9800),
                        child: const Text(
                          '!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton({
    required String status,
    required Color color,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: () {
        _markAttendance(status);
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildStatusText() {
    Color textColor = Colors.black;
    String displayText = '';

    switch (_selectedStatus) {
      case 'present':
        textColor = const Color(0xFF4CAF50);
        displayText = 'Present';
        break;
      case 'absent':
        textColor = const Color(0xFFF44336);
        displayText = 'Absent';
        break;
      case 'late':
        textColor = const Color(0xFFFF9800);
        displayText = 'Late';
        break;
    }

    return GestureDetector(
      onTap: () {
        // Reset to show buttons again (user can re-select)
        setState(() {
          _selectedStatus = null;
        });
      },
      child: Align(
        alignment: Alignment.center,
        child: Text(
          displayText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
