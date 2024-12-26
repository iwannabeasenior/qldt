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
      {required this.token,
      this.classId,
      this.title,
      required this.deadline,
      required this.description,
      required this.files,
      this.assignmentId});
}

class SubmitSurveyRequest {
  String token;
  String assignmentId;
  String textResponse;
  List<FileRequest> files;

  SubmitSurveyRequest(
      {
        required this.token,
        required this.assignmentId,
        required this.textResponse,
        required this.files
      }
    );
}
