class StudentAccount {
  String accountId;
  String lastName;
  String firstName;
  String email;
  String studentId;

  // Constructor
  StudentAccount({
    required this.accountId,
    required this.lastName,
    required this.firstName,
    required this.email,
    required this.studentId,
  });

  // Phương thức để chuyển đổi đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'last_name': lastName,
      'first_name': firstName,
      'email': email,
      'student_id': studentId,
    };
  }

  // Phương thức để tạo đối tượng từ JSON
  factory StudentAccount.fromJson(Map<String, dynamic> json) {
    return StudentAccount(
      accountId: json['account_id'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      email: json['email'],
      studentId: json['student_id'],
    );
  }
}

// Lớp AbsenceStudent dùng để chứa thông tin về sinh viên nghỉ học
class AbsenceStudent {
  String id;
  StudentAccount studentAccount;
  String absenceDate;
  String title;
  String reason;
  String status;
  String fileUrl;
  String classId;

  // Constructor
  AbsenceStudent({
    required this.id,
    required this.studentAccount,
    required this.absenceDate,
    required this.title,
    required this.reason,
    required this.status,
    required this.fileUrl,
    required this.classId,
  });

  // Phương thức để chuyển đổi đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_account': studentAccount.toJson(),
      'absence_date': absenceDate,
      'title': title,
      'reason': reason,
      'status': status,
      'file_url': fileUrl,
      'class_id': classId,
    };
  }

  // Phương thức để tạo đối tượng từ JSON
  factory AbsenceStudent.fromJson(Map<String, dynamic> json) {
    return AbsenceStudent(
      id: json['id'],
      studentAccount: StudentAccount.fromJson(json['student_account']),
      absenceDate: json['absence_date'],
      title: json['title'],
      reason: json['reason'],
      status: json['status'],
      fileUrl: json['file_url'],
      classId: json['class_id'],
    );
  }
}