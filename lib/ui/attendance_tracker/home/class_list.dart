import 'package:flutter/material.dart';
import 'package:flutter_project/data/class_data_testing.dart';
import 'package:flutter_project/data/student_data_testing.dart';
import 'package:flutter_project/models/class.dart';
import 'package:flutter_project/ui/attendance_tracker/home/attendance_screen.dart';

class ClassList extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onSelectDate;

  const ClassList({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Opacity(opacity: 0.5, child: Image.asset('assets/logo2.png')),
          SizedBox(height: 10),
          Text(
            'No Classes',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA8A8A8),
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
    if (classDataList.isNotEmpty) {
      content = ListView.builder(
        itemCount: classDataList.length,
        itemBuilder: (context, index) => ClassTile(
          classroom: classDataList[index],
          selectedDate: selectedDate,
          onSelectDate: onSelectDate,
        ),
      );
    }

    return Column(
      children: [
        // Select Date Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: onSelectDate,
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: const BorderSide(color: Color(0xFF5597FF), width: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Class List Content
        Expanded(child: content),
      ],
    );
  }
}

class ClassTile extends StatelessWidget {
  const ClassTile({
    super.key,
    required this.classroom,
    required this.selectedDate,
    required this.onSelectDate,
  });

  final Class classroom;
  final DateTime selectedDate;
  final VoidCallback onSelectDate;

  @override
  Widget build(BuildContext context) {
    // Get student count for this specific class
    final int studentCount = getStudentsByClassId(classroom.id).length;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttendanceScreen(
              selectedDate: selectedDate,
              onSelectDate: onSelectDate,
              classId: classroom.id,
              className: classroom.name,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF5597FF), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            children: [
              Text(
                classroom.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Total Students: $studentCount',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF858585),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
