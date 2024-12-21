import 'package:qldt/data/model/assignment.dart';
import 'package:qldt/data/model/survey.dart';
import 'package:qldt/data/remote/api_service_it5023e.dart';

import '../request/survey_request.dart';

abstract class AssignmentRepo {
  Future<List<Assignment>> getStudentAssignments(String token, String type, String classId);
  Future<List<Survey>> getAllSurveys(String token, String classId);
  Future<List<GetSurveyResponse>> getSurveyResponse(String token, String surveyId, String? score, String? submissionId);
  Future<Map<String, dynamic>> createSurvey(SurveyRequest surveyRequest);
  Future<Map<String, dynamic>> editSurvey(SurveyRequest surveyRequest);
  Future<Map<String, dynamic>> submitSurvey(SubmitSurveyRequest submitSurveyRequest);
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

  @override
  Future<Map<String, dynamic>> createSurvey(SurveyRequest surveyRequest) {
    return api.createSurvey(surveyRequest);
  }

  @override
  Future<Map<String, dynamic>> editSurvey(SurveyRequest surveyRequest) {
    return api.editSurvey(surveyRequest);
  }

  @override
  Future<Map<String, dynamic>> submitSurvey(SubmitSurveyRequest submitSurveyRequest) {
    return api.submitSurvey(submitSurveyRequest);
  }
}