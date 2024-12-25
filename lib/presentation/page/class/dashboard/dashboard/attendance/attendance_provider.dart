import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/absence_lecturer.dart';
import 'package:qldt/data/model/absence_student.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/repo/absence_repository.dart';
import 'package:qldt/data/repo/material_repository.dart';
import 'package:qldt/data/request/material_request.dart';
import 'package:qldt/helper/utils.dart';

import '../../../../../../data/model/attendance_student_detail.dart';
import '../../../../../../data/model/class_info.dart';
import '../../../../../../data/repo/attendance_repository.dart';
import '../../../../../../data/request/absence_request.dart';
import '../../../../../../data/request/get_attendance_list_request.dart';
import '../../../../../../data/request/get_student_absence.dart';

class AttendanceProvider with ChangeNotifier {
  final AttendanceRepo _repo;

  AttendanceProvider(this._repo);

  List<String> absenceDates = [];
  List<String> attendanceRecord = [];
  List<Student> studentLists = [];

  List<AttendanceStudentDetail> attendanceStudentDetail = [];


  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchAttendanceDates(String token, String classId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final dates = await _repo.getAttendanceDates(token, classId);
      absenceDates = dates; // Update the list of absence dates
    } catch (e) {
      debugPrint("Error fetching attendance dates: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAttendanceRecord(String token, String classId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final dates = await _repo.getAttendanceRecord(token, classId);
      attendanceRecord = dates; // Update the list of absence dates
    } catch (e) {
      debugPrint("Error fetching attendance dates: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool?> fetchStudentAccounts(String token,  String role,
      String accountId,String classId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Lấy thông tin lớp học từ repo
      final classInfo = await _repo.getClassInfo(
          token,  role, accountId,classId);

      // Chỉ lấy danh sách studentAccounts và gán vào studentLists
      studentLists = classInfo.studentAccounts;
      final endDate = Utils.stringToDateTime(classInfo.endDate);
      final now = DateTime.now();
      Logger().d("end: $endDate - now: $now");
      return DateTime.now().isAfter(endDate);
    } catch (e) {
      debugPrint("Error fetching student accounts: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> takeAttendance({
    required String token,
    required String classId,
    required String date,
    required List<String> attendanceList,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> response = await _repo.takeAttendance(
        token: token,
        classId: classId,
        date: date,
        attendanceList: attendanceList,
      );

      // Handle successful attendance mark
      if (response['meta']['code'] == '1000') {
        debugPrint("Attendance successfully taken!");
        // You can update any local state here, for example:
        // attendanceRecord.add(date);
      } else {
        throw Exception("Error: ${response['meta']['message']}");
      }
    } catch (e) {
      debugPrint("Error taking attendance: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAttendanceStudentDetail(GetAttendanceListRequest request  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _repo.getAttendanceList(request);
      attendanceStudentDetail = res.attendanceStudentDetails;
      Logger().d('data ${attendanceStudentDetail}');
    } catch (e) {
      debugPrint("Error fetching attendance dates: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setAttendanceStatus({
    required String token,
    required String attendanceId,
    required String status,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> response = await _repo.setAttendanceStatus(token: token, attendanceId: attendanceId, status: status);

      // Handle successful attendance mark
      if (response['meta']['code'] == '1000') {
        debugPrint("Attendance successfully taken!");
        // You can update any local state here, for example:
        // attendanceRecord.add(date);
      } else {
        throw Exception("Error: ${response['meta']['message']}");
      }
    } catch (e) {
      debugPrint("Error taking attendance: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }





}

