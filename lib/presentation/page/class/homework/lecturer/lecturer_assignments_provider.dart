import 'package:flutter/cupertino.dart';
import 'package:qldt/data/model/survey.dart';
import 'package:qldt/data/repo/assignment_repository.dart';

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
//error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

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
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> gradingSubmission(
      String token, String surveyId, String score, String submissionId) async {
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
}
