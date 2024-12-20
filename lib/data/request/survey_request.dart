import 'package:qldt/data/request/files_request.dart';

class SurveyRequest {
  String token;
  String classId;
  String title;
  String deadline;
  String description;
  List<FileRequest> files;

  SurveyRequest(
      {
      required this.token,
      required this.classId,
      required this.title,
      required this.deadline,
      required this.description,
      required this.files
      });
}