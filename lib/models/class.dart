
class Class {
  final String id;
  final String name;
  final List<String> studentIds;

  const Class({
    required this.id,
    required this.name,
    this.studentIds = const [],
  });

  int get totalStudents => studentIds.length;

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'studentIds': studentIds};
  }

  // Create from JSON
  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['id'] as String,
      name: json['name'] as String,
      studentIds: List<String>.from(json['studentIds'] ?? []),
    );
  }
}
