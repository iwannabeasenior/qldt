import 'package:flutter/cupertino.dart';
import 'package:qldt/data/model/survey.dart';
import 'package:qldt/data/repo/assignment_repository.dart';

class LecturerAssignmentProvider with ChangeNotifier {
  final AssignmentRepo _repo;

  LecturerAssignmentProvider(this._repo);

  List<Survey> _surveys = [];
  List<GetSurveyResponse> _surveyRespones = [];
  bool _isLoading = false;

  List<Survey> get surveys => _surveys;
  bool get isLoading => _isLoading;

  List<GetSurveyResponse> get surveyResponses => _surveyRespones;

  Future<void> fetchLecturerAssignments(String token, String classId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _surveys = await _repo.getAllSurveys(token, classId);
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
      _surveyRespones = await _repo.getSurveyResponse(token, surveyId, null, null);
    } catch(e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}