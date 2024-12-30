import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/absence_lecturer.dart';
import 'package:qldt/data/model/absence_response.dart';
import 'package:qldt/data/model/absence_student.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/repo/absence_repository.dart';
import 'package:qldt/data/repo/material_repository.dart';
import 'package:qldt/data/request/material_request.dart';

import '../../../../../../data/model/absence_response2.dart';
import '../../../../../../data/request/absence_request.dart';
import '../../../../../../data/request/get_student_absence.dart';

class AbsenceProvider with ChangeNotifier {
  final AbsenceRepo _repo;
  AbsenceProvider(this._repo);

  AbsenceResponse absenceResponse = AbsenceResponse(absenceRequests: [], pageInfo: PageInfo(totalRecords: "0", totalPage: "0", pageSize: "0", page: "0"));
  List<AbsenceRequest1> absenceRequest1 = [];

  AbsenceResponse2 absenceResponse2 = AbsenceResponse2(absenceRequests: [], pageInfo: PageInfo2(totalRecords: "0", totalPage: "0", pageSize: "0", page: "0"));
  List<AbsenceRequest2> absenceRequest2 = [];

  List<AbsenceStudent> _absenceStudents = [];

  List<AbsenceStudent> get absenceStudents => _absenceStudents;

  List<AbsenceLecturer> _absenceLecturers = [];

  List<AbsenceLecturer> get absenceLecturer => _absenceLecturers;

  PageInfo pageInfo = PageInfo(totalRecords: "0", totalPage: "0", pageSize: "0", page: "0");
  PageInfo2 pageInfo2 = PageInfo2(totalRecords: "0", totalPage: "0", pageSize: "0", page: "0");


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? res; // Tạo kiểu cho `res`

  // Phương thức requestAbsence cần phải khai báo là `async`
  Future<void> requestAbsence(AbsenceRequest absenceRequest) async {
    // Thông báo UI bắt đầu tải dữ liệu
    notifyListeners();

    try {
      _isLoading = true;
      // Gửi yêu cầu thông qua repository
      res = await _repo.requestAbsence(absenceRequest);
    } catch (e) {
      // Log lỗi nếu có
      Logger().e("Error requesting absence: $e");
    } finally {
      // Đảm bảo luôn gọi notifyListeners sau khi xử lý xong
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getStudentAbsenceRequests(GetStudentAbsence getStudentAbsence, {bool replace = false}) async {
    // Thông báo UI bắt đầu tải dữ liệu
    notifyListeners();

    try {
      _isLoading = true;
      // Gửi yêu cầu thông qua repository
      absenceResponse = await _repo.getStudentAbsenceRequests(getStudentAbsence);

      if (replace) {
        absenceRequest1 = absenceResponse.absenceRequests;
      } else {
        absenceRequest1.addAll(absenceResponse.absenceRequests) ;
      }

      pageInfo = absenceResponse.pageInfo;
    } catch (e) {
      // Log lỗi nếu có
      Logger().e("Error requesting absence: $e");
    } finally {
      // Đảm bảo luôn gọi notifyListeners sau khi xử lý xong
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllAbsenceRequests(GetStudentAbsence getStudentAbsence, {bool replace = false}) async {
    // Thông báo UI bắt đầu tải dữ liệu
    notifyListeners();

    try {
      _isLoading = true;
      // Gửi yêu cầu thông qua repository
      absenceResponse2 = await _repo.getAllAbsenceRequests(getStudentAbsence);
      if (replace) {
        absenceRequest2 = absenceResponse2.absenceRequests;
      } else {
        absenceRequest2.addAll(absenceResponse2.absenceRequests) ;
      }

      pageInfo2 = absenceResponse2.pageInfo;
    } catch (e) {
      // Log lỗi nếu có
      Logger().e("Error requesting absence: $e");
    } finally {
      // Đảm bảo luôn gọi notifyListeners sau khi xử lý xong
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reviewAbsenceRequest(String token, String requestId, String status) async {
    // Thông báo UI bắt đầu tải dữ liệu
    notifyListeners();

    try {
      _isLoading = true;
      // Gửi yêu cầu thông qua repository và nhận kết quả
      res = await _repo.reviewAbsenceRequest(token, requestId, status);
      // Handle the result if needed, e.g., process res for updating state
    } catch (e) {
      // Log lỗi nếu có
      Logger().e("Error reviewing absence request: $e");
    } finally {
      // Đảm bảo luôn gọi notifyListeners sau khi xử lý xong
      _isLoading = false;
      notifyListeners();
    }
  }





}