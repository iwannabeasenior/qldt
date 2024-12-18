import 'package:dartz/dartz.dart';
import 'package:qldt/data/model/absence_student.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/remote/api_service_it5023e.dart';
import 'package:qldt/data/request/material_request.dart';
import 'package:qldt/helper/failure.dart';

import '../model/absence_lecturer.dart';
import '../model/attendance_student_detail.dart';
import '../model/class_info.dart';
import '../request/absence_request.dart';
import '../request/get_attendance_list_request.dart';
import '../request/get_student_absence.dart';

abstract class AttendanceRepo {
  Future<List<String>> getAttendanceDates(String token, String classId);
  Future<List<String>> getAttendanceRecord(String token, String classId);
  Future<ClassInfo> getClassInfo(String token, String classId, String role, String accountId);
  Future<Map<String, dynamic>> takeAttendance({
    required String token,
    required String classId,
    required String date,
    required List<String> attendanceList,
  });
  Future<GetAttendanceListResponse> getAttendanceList(GetAttendanceListRequest request);
  Future<Map<String, dynamic>> setAttendanceStatus({
    required String token,
    required String attendanceId,
    required String status,
  });

}

class AttendanceRepoImpl extends AttendanceRepo {
  ApiServiceIT5023E api;

  AttendanceRepoImpl({required this.api});

  @override
  Future<List<String>> getAttendanceDates(String token, String classId) {
    return api.getAttendanceDates(token, classId);
  }

  @override
  Future<List<String>> getAttendanceRecord(String token, String classId) {
    return api.getAttendanceRecord(token, classId);
  }

  @override
  Future<ClassInfo> getClassInfo(String token,  String role, String accountId,String classId,) {
    return api.getClassInfo(token, role, accountId, classId, );
  }

  @override
  Future<Map<String, dynamic>> takeAttendance({required String token, required String classId, required String date, required List<String> attendanceList}) {
    return api.takeAttendance(token: token, classId: classId, date: date, attendanceList: attendanceList );
  }

  @override
  Future<GetAttendanceListResponse> getAttendanceList(GetAttendanceListRequest request  ) {
    return api.getAttendanceList(request);
  }

  @override
  Future<Map<String, dynamic>> setAttendanceStatus({required String token, required String attendanceId, required String status}) {
   return api.setAttendanceStatus(token: token, attendanceId: attendanceId, status: status);
  }








}