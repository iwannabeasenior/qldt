class AbsenceResponse {
  final List<AbsenceRequest1> absenceRequests;
  final PageInfo pageInfo;

  AbsenceResponse({
    required this.absenceRequests,
    required this.pageInfo,
  });

  factory AbsenceResponse.fromJson(Map<String, dynamic> json) {
    return AbsenceResponse(
      absenceRequests: (json['data']['page_content'] as List)
          .map((item) => AbsenceRequest1.fromJson(item))
          .toList(),
      pageInfo: PageInfo.fromJson(json['data']['page_info']),
    );
  }
}

class AbsenceRequest1 {
  final String id;
  final StudentAccount studentAccount;
  final String absenceDate;
  final String title;
  final String reason;
  final String status;
  final String? fileUrl;
  final String classId;

  AbsenceRequest1({
    required this.id,
    required this.studentAccount,
    required this.absenceDate,
    required this.title,
    required this.reason,
    required this.status,
    this.fileUrl,
    required this.classId,
  });

  factory AbsenceRequest1.fromJson(Map<String, dynamic> json) {
    return AbsenceRequest1(
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
      accountId: json['account_id'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      email: json['email'],
      studentId: json['student_id'],
    );
  }
}

class PageInfo {
  final String totalRecords;
  final String totalPage;
  final String pageSize;
  final String page;
  final String? nextPage;
  final String? previousPage;

  PageInfo({
    required this.totalRecords,
    required this.totalPage,
    required this.pageSize,
    required this.page,
    this.nextPage,
    this.previousPage,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      totalRecords: json['total_records'],
      totalPage: json['total_page'],
      pageSize: json['page_size'],
      page: json['page'],
      nextPage: json['next_page'],
      previousPage: json['previous_page'],
    );
  }
}
