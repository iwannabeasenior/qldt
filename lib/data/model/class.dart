class Class {

  Class(this.id, this.name, this.lecturerName, this.studentCount,
      this.startDate, this.endDate, this.status);

  String id;
  String name;
  String lecturerName;
  int studentCount;
  DateTime startDate;
  DateTime endDate;
  String status;

  factory Class.fromJson(Map<String, dynamic> response) =>
      Class(response['id'], response['class_name'], response['lecturer_name'], response['student_count'], response['start_date'], response['end_date'], response['status']);
}
