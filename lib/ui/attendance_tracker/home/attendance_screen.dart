import 'package:flutter/material.dart';
import 'package:flutter_project/data/student_data_testing.dart';
import 'package:flutter_project/models/student.dart';

class AttendanceScreen extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onSelectDate;
  final String classId;
  final String className;

  const AttendanceScreen({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
    required this.classId,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    final List<Student> students = getStudentsByClassId(classId);
    Widget content = ListView.separated(
      itemCount: students.length,
      separatorBuilder: (context, index) =>
          const Divider(color: Color(0xFF5597FF), thickness: 2, height: 1),
      itemBuilder: (context, index) {
        return StudentTile(index: index + 1, student: students[index]);
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
                        '$className Attendance',
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
                    onPressed: onSelectDate,
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
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
            const Divider(color: Color(0xFF5597FF), thickness: 2, height: 1,),
          ],
        ),
      ),
    );
  }
}

class StudentTile extends StatefulWidget {
  final int index;
  final Student student;

  const StudentTile({super.key, required this.index, required this.student});

  @override
  State<StudentTile> createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  String? _selectedStatus;

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
          Row(
            children: [
              _buildStatusButton(
                status: 'present',
                color: const Color(0xFF4CAF50),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),
              _buildStatusButton(
                status: 'absent',
                color: const Color(0xFFF44336),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
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
        ],
      ),
    );
  }

  Widget _buildStatusButton({
    required String status,
    required Color color,
    required Widget child,
  }) {
    final isSelected = _selectedStatus == status;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status;
        });
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
        ),
        child: Center(child: child),
      ),
    );
  }
}
