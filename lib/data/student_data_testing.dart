import 'package:flutter_project/models/student.dart';

final studentDataTesting = [
  // Group 1 students
  const Student(id: 's1', name: 'Alice Johnson', classId: 'a1'),
  const Student(id: 's2', name: 'Bob Smith', classId: 'a1'),
  const Student(id: 's3', name: 'Carol White', classId: 'a1'),
  const Student(id: 's4', name: 'David Brown', classId: 'a1'),
  const Student(id: 's5', name: 'Emma Davis', classId: 'a1'),
  // Group 2 students
  const Student(id: 's6', name: 'Frank Miller', classId: 'a2'),
  const Student(id: 's7', name: 'Grace Lee', classId: 'a2'),
  const Student(id: 's8', name: 'Henry Wilson', classId: 'a2'),
  // Group 3 students
  const Student(id: 's9', name: 'Ivy Chen', classId: 'a3'),
  const Student(id: 's10', name: 'Jack Taylor', classId: 'a3'),
  // Group 4 students
  const Student(id: 's11', name: 'Karen Martinez', classId: 'a4'),
  const Student(id: 's12', name: 'Leo Anderson', classId: 'a4'),
  const Student(id: 's13', name: 'Mia Thomas', classId: 'a4'),
  const Student(id: 's14', name: 'Noah Garcia', classId: 'a4'),
];

List<Student> getStudentsByClassId(String classId) {
  return studentDataTesting.where((s) => s.classId == classId).toList();
}

Map<String, int> getStudentCountByClass() {
  final Map<String, int> classCount = {};
  for (var student in studentDataTesting) {
    classCount[student.classId] = (classCount[student.classId] ?? 0) + 1;
  }
  return classCount;
}