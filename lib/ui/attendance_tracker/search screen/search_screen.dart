import 'package:flutter/material.dart';
import 'package:flutter_project/data/class_service.dart';
import 'package:flutter_project/models/class.dart';
import 'package:flutter_project/models/student.dart';
import 'package:flutter_project/ui/attendance_tracker/home/attendance_screen.dart';

class SearchScreen extends StatefulWidget {
  final DateTime selectedDate;
  final VoidCallback onSelectDate;
  const SearchScreen({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        _searchQuery = searchController.text.toLowerCase().trim();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Class> _getFilteredClasses() {
    if (_searchQuery.isEmpty) return [];
    return ClassService.classes
        .where((c) => c.name.toLowerCase().contains(_searchQuery))
        .toList();
  }

  List<Student> _getFilteredStudents() {
    if (_searchQuery.isEmpty) return [];
    return ClassService.students
        .where((s) => s.name.toLowerCase().contains(_searchQuery))
        .toList();
  }

  String _getClassNameForStudent(Student student) {
    final classroom = ClassService.getClassById(student.classId);
    return classroom?.name ?? 'Unknown Class';
  }

  @override
  Widget build(BuildContext context) {
    final filteredClasses = _getFilteredClasses();
    final filteredStudents = _getFilteredStudents();
    final hasResults =
        filteredClasses.isNotEmpty || filteredStudents.isNotEmpty;

    return Scaffold(
      body: Column(
        children: [
          // data picker
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

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search class or student name',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Search Results
          Expanded(
            child: _searchQuery.isEmpty
                ? Center(
                    child: Text(
                      'Enter a name to search',
                      style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    ),
                  )
                : !hasResults
                ? Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    ),
                  )
                : ListView(
                    children: [
                      // Class Results
                      if (filteredClasses.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Text(
                            'Classes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5597FF),
                            ),
                          ),
                        ),
                        ...filteredClasses.map(
                          (classroom) => _ClassResultTile(
                            classroom: classroom,
                            selectedDate: widget.selectedDate,
                          ),
                        ),
                      ],

                      // Student Results
                      if (filteredStudents.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Text(
                            'Students',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5597FF),
                            ),
                          ),
                        ),
                        ...filteredStudents.map(
                          (student) => _StudentResultTile(
                            student: student,
                            className: _getClassNameForStudent(student),
                            selectedDate: widget.selectedDate,
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ClassResultTile extends StatelessWidget {
  final Class classroom;
  final DateTime selectedDate;

  const _ClassResultTile({required this.classroom, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final studentCount = ClassService.getStudentsByClassId(classroom.id).length;

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
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF5597FF), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.class_, color: Color(0xFF5597FF)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                classroom.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '$studentCount students',
              style: const TextStyle(fontSize: 12, color: Color(0xFF858585)),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentResultTile extends StatelessWidget {
  final Student student;
  final String className;
  final DateTime selectedDate;

  const _StudentResultTile({
    required this.student,
    required this.className,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttendanceScreen(
              selectedDate: selectedDate,
              classId: student.classId,
              className: className,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFFF9800), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.person, color: Color(0xFFFF9800)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Class: $className',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF858585),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
