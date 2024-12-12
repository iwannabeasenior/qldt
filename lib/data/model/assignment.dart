class Assignment {
  int id;
  String title;
  String description;
  bool? isSubmitted;
  String deadline;
  int lecturerId;
  String fileUrl;
  String classId;

  Assignment({
    required this.id, required this.title, required this.description,
    this.isSubmitted, required this.deadline, required this.lecturerId,
    required this.fileUrl, required this.classId
  });
}