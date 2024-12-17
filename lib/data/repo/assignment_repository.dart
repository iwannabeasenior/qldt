import 'package:qldt/data/model/assignment.dart';
import 'package:qldt/data/model/survey.dart';
import 'package:qldt/data/remote/api_service_it5023e.dart';

abstract class AssignmentRepo {
  Future<List<Assignment>> getStudentAssignments(String token, String type, String classId);
  Future<List<Survey>> getAllSurveys(String token, String classId);
  Future<List<GetSurveyResponse>> getSurveyResponse(String token, String surveyId, String? score, String? submissionId);
}

class AssignmentRepoImpl extends AssignmentRepo {
  ApiServiceIT5023E api;

  AssignmentRepoImpl({required this.api});
  //Get Student Assignments
  @override
  Future<List<Assignment>> getStudentAssignments(String token, String type, String classId) {
    return api.getStudentAssignments(token, type, classId);
  }

  @override
  Future<List<Survey>> getAllSurveys(String token, String classId) {
    return api.getAllSurveys(token, classId);
  }

  @override
  Future<List<GetSurveyResponse>> getSurveyResponse(String token, String surveyId, String? score, String? submissionId) {
    return api.getSurveyResponse(token, surveyId, score, submissionId);
  }
}