class Student {
  final String id;
  final String name;
  final String classId;

  const Student({required this.id, required this.name, required this.classId});

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'classId': classId};
  }

  // Create from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      name: json['name'] as String,
      classId: json['classId'] as String,
    );
  }
}
