import 'package:flutter/material.dart';
import 'package:flutter_project/models/student.dart';
import 'package:flutter_project/models/attendance.dart';
import 'package:flutter_project/data/class_service.dart';

class AttendanceHistory extends StatelessWidget {
  final Student student;
  final String className;

  const AttendanceHistory({
    super.key,
    required this.student,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    //get all attendance record from attandance screen of 1 stu
    final attendanceRecords = ClassService.attendanceRecords
        .where((a) => a.studentId == student.id)
        .toList();

    return Material(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, size: 32),
                  ),
                  const Expanded(
                    child: Text(
                      'Attendance History',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From Class: $className',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Student Name: ${student.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            child: _summaryCard(
                              'Present',
                              attendanceRecords
                                  .where(
                                    (a) => a.status == AttendanceStatus.present,
                                  )
                                  .length
                                  .toString(),
                              const Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(width: 40),
                          SizedBox(
                            width: 60,
                            child: _summaryCard(
                              'Absent',
                              attendanceRecords
                                  .where(
                                    (a) => a.status == AttendanceStatus.absent,
                                  )
                                  .length
                                  .toString(),
                              const Color(0xFFF44336),
                            ),
                          ),
                          const SizedBox(width: 40),
                          SizedBox(
                            width: 60,
                            child: _summaryCard(
                              'Late',
                              attendanceRecords
                                  .where(
                                    (a) => a.status == AttendanceStatus.late,
                                  )
                                  .length
                                  .toString(),
                              const Color(0xFFFF9800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Date',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Status',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      const Divider(
                        color: Color(0xFF5597FF),
                        thickness: 2,
                        height: 1,
                      ),

                      if (attendanceRecords.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'No attendance records found',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF858585),
                            ),
                          ),
                        )
                      else
                        ...attendanceRecords.map((record) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${record.date.day}/${record.date.month}/${record.date.year}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _getStatusText(record.status),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            color: _getStatusColor(
                                              record.status,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Color(0xFF858585),
                                thickness: 1,
                              ),
                            ],
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.late:
        return 'Late';
    }
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return const Color(0xFF4CAF50);
      case AttendanceStatus.absent:
        return const Color(0xFFF44336);
      case AttendanceStatus.late:
        return const Color(0xFFFF9800);
    }
  }
}

Widget _summaryCard(String label, String count, Color color) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Text(
        count,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );
}
