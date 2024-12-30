import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/survey.dart';
import 'package:qldt/data/repo/assignment_repository.dart';
import 'package:qldt/data/request/survey_request.dart';

class LecturerAssignmentProvider with ChangeNotifier {
  final AssignmentRepo _repo;

  LecturerAssignmentProvider(this._repo);
// survey
  List<Survey> _surveys = [];
  List<Survey> get surveys => _surveys;
//survey response
  List<GetSurveyResponse> surveyResponses = [];
//loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
//delete
  bool _isLoadingDelete = false;
  bool get isLoadingDelete => _isLoadingDelete;
//error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

//type of response
  Map<String, dynamic>? res;

  Future<void> fetchLecturerAssignments(String token, String classId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _surveys = await _repo.getAllSurveys(token, classId);
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSubmissionList(String token, String surveyId) async {
    _isLoading = true;
    notifyListeners();

    try {
      surveyResponses =
          await _repo.getSurveyResponse(token, surveyId, null, null);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> gradingSubmission(String token, String surveyId, String score, String submissionId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      surveyResponses = await _repo.getSurveyResponse(token, surveyId, score, submissionId);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Không thể chấm điểm bài nộp: $e";
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createSurvey(SurveyRequest surveyRequest) async {
    notifyListeners();
    try {
      _isLoading = true;
      await _repo.createSurvey(surveyRequest);
    } catch(e) {
      throw(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editSurvey(SurveyRequest surveyRequest) async {
    notifyListeners();
    try {
      _isLoading = true;
      res = await _repo.editSurvey(surveyRequest);
    } catch(e) {
      _errorMessage = e.toString();
      throw e; //
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSurvey(String token, String surveyId) async {
    notifyListeners();
    try {
      _isLoadingDelete = true;
      final response = await _repo.deleteSurvey(token, surveyId);
      if (response != "delete assignment successful") {
        // Nếu response khác thành công, ném lỗi
        throw Exception("Failed to delete survey: $response");
      }
    } catch (e) {
      Logger().e(e); // Log lỗi
      rethrow; // Ném lỗi để UI xử lý
    } finally {
      _isLoadingDelete = false;
      notifyListeners();
    }
  }

}
