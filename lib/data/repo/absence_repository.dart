import 'package:dartz/dartz.dart';
import 'package:qldt/data/model/absence_student.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/remote/api_service_it5023e.dart';
import 'package:qldt/data/request/material_request.dart';
import 'package:qldt/helper/failure.dart';

import '../request/absence_request.dart';
import '../request/get_student_absence.dart';

abstract class AbsenceRepo {
  Future<Map<String, dynamic>> requestAbsence(AbsenceRequest absenceRequest);
  Future<List<AbsenceStudent>> getStudentAbsenceRequests(GetStudentAbsence absenceRequest);


}

class AbsenceRepoImpl extends AbsenceRepo {
  ApiServiceIT5023E api;

  AbsenceRepoImpl({required this.api});

  @override
  Future<Map<String, dynamic>> requestAbsence(AbsenceRequest absenceRequest) {
    return api.requestAbsence(absenceRequest);
  }

  @override
  Future<List<AbsenceStudent>> getStudentAbsenceRequests(GetStudentAbsence getStudentAbsence) {
    return api.getStudentAbsenceRequests(getStudentAbsence);

  }



}