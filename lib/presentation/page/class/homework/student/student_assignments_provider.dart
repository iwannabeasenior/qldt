import 'package:flutter/widgets.dart';
import 'package:qldt/data/model/assignment.dart';
import 'package:qldt/data/model/survey.dart';
import 'package:qldt/data/repo/assignment_repository.dart';

import '../../../../../data/request/survey_request.dart';

class StudentAssignmentProvider with ChangeNotifier {
  final AssignmentRepo _repo;

  StudentAssignmentProvider(this._repo);

  List<Assignment> _assignments = [];
  bool _isLoading = false;

  List<Assignment> get assignments => _assignments;
  bool get isLoading => _isLoading;

  GetSurveyResponse? _submission = GetSurveyResponse(
      id: 0,
      assignmentId: 0,
      submissionTime: '',
      textResponse: '',
      studentAccount: StudentAccount(
          accountId: '',
          lastName: '',
          firstName: '',
          email: '',
          studentId: ''
      )
  );
  GetSurveyResponse? get submission => _submission;

  //type of response
  Map<String, dynamic>? res;

  Future<void> fetchStudentAssignments(String token, String type, String classId) async {
    _isLoading = true;
    notifyListeners();

    try{
      _assignments = await _repo.getStudentAssignments(token, type, classId);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitSurvey(SubmitSurveyRequest submitSurveyRequest) async {
    notifyListeners();
    try {
      _isLoading = true;
      res = await _repo.submitSurvey(submitSurveyRequest);
    } catch(e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSubmission(String token, String assignmentId) async {
    notifyListeners();
    try {
      _isLoading = true;
      _submission = await _repo.getSubmission(token, assignmentId);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

