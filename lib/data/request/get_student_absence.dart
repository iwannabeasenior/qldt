import 'dart:core';

class GetStudentAbsence {

  String? token;
  String? classId;
  String? status;
  String? date;
  String? page;
  String? pageSize;
  GetStudentAbsence({
     this.token,
     this.classId,
    this.status,
    this.date,
    this.page,
    this.pageSize,
  });

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "class_id": classId,
      if (status != null) "status": status,
      if (date != null) "date": date,
      "pageable_request": {
        "page": page?.toString() ?? "0",
        "page_size": pageSize?.toString() ?? "10",
      }
    };
  }

}