import 'package:dartz/dartz.dart';
import 'package:qldt/data/model/absence_student.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/remote/api_service_it5023e.dart';
import 'package:qldt/data/request/material_request.dart';
import 'package:qldt/helper/failure.dart';

import '../model/absence_lecturer.dart';
import '../model/absence_response.dart';
import '../request/absence_request.dart';
import '../request/get_student_absence.dart';

abstract class AbsenceRepo {
  Future<Map<String, dynamic>> requestAbsence(AbsenceRequest absenceRequest);
  Future<AbsenceResponse> getStudentAbsenceRequests(GetStudentAbsence getStudentAbsence);
  Future<List<AbsenceLecturer>> getAllAbsenceRequests(GetStudentAbsence getStudentAbsence);
  Future<Map<String, dynamic>> reviewAbsenceRequest(String token, String requestId, String status);


}

class AbsenceRepoImpl extends AbsenceRepo {
  ApiServiceIT5023E api;

  AbsenceRepoImpl({required this.api});

  @override
  Future<Map<String, dynamic>> requestAbsence(AbsenceRequest absenceRequest) {
    return api.requestAbsence(absenceRequest);
  }

  @override
  Future<AbsenceResponse> getStudentAbsenceRequests(GetStudentAbsence getStudentAbsence) {
    return api.getStudentAbsenceRequests(getStudentAbsence);

  }

  @override
  Future<List<AbsenceLecturer>> getAllAbsenceRequests(GetStudentAbsence getStudentAbsence) {
    return api.getAllAbsenceRequests(getStudentAbsence);
  }

  @override
  Future<Map<String, dynamic>> reviewAbsenceRequest(String token, String requestId, String status) {
    return api.reviewAbsenceRequest(token, requestId, status );
  }



}