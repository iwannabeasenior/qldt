import 'package:qldt/data/request/files_request.dart';

class SurveyRequest {
  String token;
  String? classId;
  String? title;
  String deadline;
  String description;
  String? assignmentId;
  List<FileRequest> files;

  SurveyRequest(
      {
      required this.token,
      this.classId,
      this.title,
      required this.deadline,
      required this.description,
      required this.files,
      this.assignmentId
      });
}