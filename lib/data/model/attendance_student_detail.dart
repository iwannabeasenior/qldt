class AttendanceStudentDetail {
  final String attendanceId;
  final String studentId;
  String status;
  String? name;

  AttendanceStudentDetail({
    required this.attendanceId,
    required this.studentId,
    required this.status,
    this.name,
  });

  factory AttendanceStudentDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceStudentDetail(
      attendanceId: json['attendance_id'],
      studentId: json['student_id'],
      status: json['status'],
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

class GetAttendanceListResponse {
  final List<AttendanceStudentDetail> attendanceStudentDetails;
  final PageInfo pageInfo;

  GetAttendanceListResponse({
    required this.attendanceStudentDetails,
    required this.pageInfo,
  });

  factory GetAttendanceListResponse.fromJson(Map<String, dynamic> json) {
    return GetAttendanceListResponse(
      attendanceStudentDetails: (json['attendance_student_details'] as List<dynamic>)
          .map((e) => AttendanceStudentDetail.fromJson(e))
          .toList(),
      pageInfo: PageInfo.fromJson(json['page_info']),
    );
  }
}
