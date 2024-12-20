class GetAttendanceListRequest {
  final String token;
  final String classId;
  final String date;
  final PageableRequest? pageableRequest;

  GetAttendanceListRequest({
    required this.token,
    required this.classId,
    required this.date,
    this.pageableRequest,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'class_id': classId,
      'date': date,
      'pageable_request': pageableRequest?.toJson(),
    };
  }
}

class PageableRequest {
  final String? page;
  final String? pageSize;

  PageableRequest({this.page, this.pageSize});

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'page_size': pageSize,
    };
  }
}
