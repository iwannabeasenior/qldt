class Class {

  String? id;
  String? name;
  String? attachedCode;
  String? lecturerName;
  int? studentCount;
  String? startDate;
  String? endDate;
  String? status;

  factory Class.fromJson(Map<String, dynamic> response) =>
      Class(
          id: response['class_id'],
          name: response['class_name'],
          attachedCode: response['attached_code'],
          lecturerName: response['lecturer_name'],
          studentCount: response['student_count'],
          startDate: response['start_date'],
          endDate: response['end_date'],
          status: response['status']
      );

  Class({
    required this.id,
    required this.name,
    required this.attachedCode,
    required this.lecturerName,
    required this.studentCount,
    required this.startDate,
    required this.endDate,
    required this.status
  });
}


  class GetSurveyResponse {
  final int id;
  final int assignmentId;
  final int studentId;
  final DateTime submissionTime;
   double? grade;
  final String fileUrl;
  final String textResponse;

  GetSurveyResponse({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.submissionTime,
    required this.grade,
    required this.fileUrl,
    required this.textResponse,
  });

  factory GetSurveyResponse.fromJson(Map<String, dynamic> json) {
    return GetSurveyResponse(
      id: json['id'],
      assignmentId: json['assignment_id'],
      studentId: json['student_id'],
      submissionTime: DateTime.parse(json['submission_time']),
      grade: json['grade'].toDouble(),
      fileUrl: json['file_url'],
      textResponse: json['text_response'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignment_id': assignmentId,
      'student_id': studentId,
      'submission_time': submissionTime.toIso8601String(),
      'grade': grade,
      'file_url': fileUrl,
      'text_response': textResponse,
    };
  }
}


class Survey {
  final int id;
  final String title;
  final String description;
  final int lecturerId;
  final int classId;
  final DateTime deadline;
  final String fileUrl;

  Survey({
    required this.id,
    required this.title,
    required this.description,
    required this.lecturerId,
    required this.classId,
    required this.deadline,
    required this.fileUrl,
  });

  // Factory constructor to create an instance of Survey from JSON
  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      lecturerId: json['lecturer_id'],
      classId: json['class_id'],
      deadline: DateTime.parse(json['deadline']),
      fileUrl: json['file_url'],
    );
  }

  // Method to convert a Survey instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'lecturer_id': lecturerId,
      'class_id': classId,
      'deadline': deadline.toIso8601String(),
      'file_url': fileUrl,
    };
  }
}

