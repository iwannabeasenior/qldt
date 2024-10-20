
class Class {
  final id;
  final name;
  Class(this.id, this.name);
}

class ClassModel {
  final String classCode;
  final String semester;
  final String className;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final int maxStudents;

  ClassModel({
    required this.classCode,
    required this.semester,
    required this.className,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.maxStudents,
  });
}