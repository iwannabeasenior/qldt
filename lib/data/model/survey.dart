class StudentAccount {
  final String accountId;
  final String lastName;
  final String firstName;
  final String email;
  final String studentId;

  StudentAccount({
    required this.accountId,
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.studentId,
  });

  factory StudentAccount.fromJson(Map<String, dynamic> json) {
    return StudentAccount(
      accountId: json['account_id'] as String,
      lastName: json['last_name'] as String,
      firstName: json['first_name'] as String,
      email: json['email'] as String,
      studentId: json['student_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'last_name': lastName,
      'first_name': firstName,
      'email': email,
      'student_id': studentId,
    };
  }
}

class GetSurveyResponse {
  final int id;
  final int assignmentId;
  final String submissionTime;
  double? grade;
  final String fileUrl;
  final String textResponse;
  final StudentAccount studentAccount;

  GetSurveyResponse({
    required this.id,
    required this.assignmentId,
    required this.submissionTime,
    required this.grade,
    required this.fileUrl,
    required this.textResponse,
    required this.studentAccount,
  });

  factory GetSurveyResponse.fromJson(Map<String, dynamic> json) {
    return GetSurveyResponse(
      id: json['id'],
      assignmentId: json['assignment_id'],
      submissionTime: json['submission_time'],
      grade: json['grade'].toDouble(),
      fileUrl: json['file_url'],
      textResponse: json['text_response'],
      studentAccount: StudentAccount.fromJson(
          json['student_account'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignment_id': assignmentId,
      'submission_time': submissionTime,
      'grade': grade,
      'file_url': fileUrl,
      'text_response': textResponse,
      'student_account': studentAccount.toJson(),
    };
  }
}

class Survey {
  final int id;
  final String title;
  final String description;
  final int lecturerId;
  final String classId;
  final DateTime deadline;
  final String? fileUrl;

  Survey({
    required this.id,
    required this.title,
    required this.description,
    required this.lecturerId,
    required this.classId,
    required this.deadline,
    this.fileUrl,
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