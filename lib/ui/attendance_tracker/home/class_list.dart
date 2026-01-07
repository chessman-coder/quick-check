import 'package:flutter/material.dart';
import 'package:flutter_project/data/class_service.dart';
import 'package:flutter_project/models/class.dart';
import 'package:flutter_project/ui/attendance_tracker/home/attendance_screen.dart';

class ClassList extends StatefulWidget {
  final DateTime selectedDate;
  final VoidCallback onSelectDate;

  const ClassList({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
  });

  @override
  State<ClassList> createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  Future<void> _deleteClass(String classId) async {
    await ClassService.deleteClass(classId);
    setState(() {});
  }

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
    if (ClassService.classes.isNotEmpty) {
      content = ListView.builder(
        itemCount: ClassService.classes.length,
        itemBuilder: (context, index) {
          final classroom = ClassService.classes[index];
          return Dismissible(
            key: ValueKey(classroom.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Class'),
                      content: Text(
                        'Are you sure you want to delete "${classroom.name}"?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ) ??
                  false;
            },
            onDismissed: (direction) {
              _deleteClass(classroom.id);
            },
            background: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 32),
            ),
            child: ClassTile(
              classroom: classroom,
              selectedDate: widget.selectedDate,
            ),
          );
        },
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
                onPressed: widget.onSelectDate,
                icon: const Icon(Icons.calendar_today, size: 18),
                label: Text(
                  '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
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
  });

  final Class classroom;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    // Get student count for this specific class
    final int studentCount = ClassService.getStudentsByClassId(
      classroom.id,
    ).length;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttendanceScreen(
              selectedDate: selectedDate,
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
