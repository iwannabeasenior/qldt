import 'dart:io';

class AbsenceRequest {

  String? token;
  String? classId;
  String? date;
  String? reason;
  String? title;
  File? file;
  AbsenceRequest({
    required this.token,
    required this.classId,
    required this.date,
    required this.reason,
    required this.title,
    required this.file,
  });

}