class Assignment {
  int id;
  String title;
  String description;
  bool? isSubmitted;
  String deadline;
  String lecturerId;
  String fileUrl;
  String classId;

  Assignment({
    required this.id, required this.title, required this.description,
    this.isSubmitted, required this.deadline, required this.lecturerId,
    required this.fileUrl, required this.classId
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isSubmitted: json['is_submitted'] ?? false,
      deadline: json['deadline'] ?? '',
      lecturerId: json['lecturer_id'] ?? '',
      fileUrl: json['file_url'] ?? '',
      classId: json['class_id'] ?? '',
    );
  }
}