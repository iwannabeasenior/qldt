import 'package:qldt/data/model/assignment.dart';
import 'package:qldt/data/remote/api_service_it5023e.dart';

abstract class AssignmentRepo {
  Future<List<Assignment>> getStudentAssignments(String token, String type, String classId);
}

class AssignmentRepoImpl extends AssignmentRepo {
  ApiServiceIT5023E api;

  AssignmentRepoImpl({required this.api});
  //Get Student Assignments
  @override
  Future<List<Assignment>> getStudentAssignments(String token, String type, String classId) {
    return api.getStudentAssignments(token, type, classId);
  }
}