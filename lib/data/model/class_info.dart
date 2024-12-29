class Student {
  final String accountId;
  final String firstName;
  final String lastName;
  final String email;
  final String studentId;

  Student({
    required this.accountId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.studentId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      accountId: json['account_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      studentId: json['student_id'],
    );
  }
}

class ClassInfo {
  final String classId;
  late final String className;
  final String? attachedCode;
  final String classType;
  final String lecturerName;
  final String lecturerAccountId;
  final int studentCount;
  late final String startDate;
  late final String endDate;
  late final String status;
  final List<Student> studentAccounts;

  ClassInfo({
    required this.classId,
    required this.className,
    this.attachedCode,
    required this.classType,
    required this.lecturerName,
    required this.lecturerAccountId,
    required this.studentCount,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.studentAccounts,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      classId: json['class_id'],
      className: json['class_name'],
      attachedCode: json['attached_code'],
      classType: json['class_type'],
      lecturerName: json['lecturer_name'],
      lecturerAccountId: json['lecturer_account_id'],
      studentCount: int.parse(json['student_count']),
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
      studentAccounts: (json['student_accounts'] as List)
          .map((studentJson) => Student.fromJson(studentJson))
          .toList(),
    );
  }
}
