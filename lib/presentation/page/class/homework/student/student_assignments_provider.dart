import 'package:flutter/widgets.dart';
import 'package:qldt/data/model/assignment.dart';
import 'package:qldt/data/repo/assignment_repository.dart';

class StudentAssignmentProvider with ChangeNotifier {
  final AssignmentRepo _repo;

  StudentAssignmentProvider(this._repo);

  List<Assignment> _assignments = [];
  bool _isLoading = false;

  List<Assignment> get assignments => _assignments;
  bool get isLoading => _isLoading;

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
}

