import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/absence_lecturer.dart';
import 'package:qldt/data/model/absence_response.dart';
import 'package:qldt/data/model/absence_student.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/repo/absence_repository.dart';
import 'package:qldt/data/repo/material_repository.dart';
import 'package:qldt/data/request/material_request.dart';

import '../../../../../../data/model/open_class_response.dart';
import '../../../../../../data/request/absence_request.dart';
import '../../../../../../data/request/get_student_absence.dart';

class AbsenceProvider with ChangeNotifier {
  final AbsenceRepo _repo;

  AbsenceProvider(this._repo);
  List<AbsenceStudent> _absenceStudents = [];
  AbsenceResponse absenceResponse = AbsenceResponse(absenceRequests: [] , pageInfo: PageInfo(totalRecords: "0", totalPage: "0", pageSize: "0", page: "0") );
  PageInfo pageInfo = PageInfo(
    totalRecords: '0',
    totalPage: '0',
    pageSize: '0',
    page: '0',
    nextPage: null,
    previousPage: null,
  );

  // Pagination support
  bool get hasMore => pageInfo.nextPage != null;
  List<AbsenceStudent> get absenceStudents => _absenceStudents;

  List<AbsenceLecturer> _absenceLecturers = [];

  List<AbsenceLecturer> get absenceLecturer => _absenceLecturers;


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

  // Future<void> getStudentAbsenceRequests(GetStudentAbsence getStudentAbsence) async {
  //   // Thông báo UI bắt đầu tải dữ liệu
  //   notifyListeners();
  //
  //   try {
  //     _isLoading = true;
  //     // Gửi yêu cầu thông qua repository
  //     _absenceStudents = await _repo.getStudentAbsenceRequests(getStudentAbsence);
  //   } catch (e) {
  //     // Log lỗi nếu có
  //     Logger().e("Error requesting absence: $e");
  //   } finally {
  //     // Đảm bảo luôn gọi notifyListeners sau khi xử lý xong
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> getStudentAbsenceRequests(GetStudentAbsence getStudentAbsence) async {
  //   if (_isLoading) return;
  //
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   try {
  //     _absenceStudents = await _repo.getStudentAbsenceRequests(getStudentAbsence);
  //
  //     // Update pageInfo from the response
  //     pageInfo = getStudentAbsence.pageInfo; // Assuming the repo returns this info.
  //
  //   } catch (e) {
  //     Logger().e("Error requesting absence: $e");
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> getStudentAbsenceRequests(GetStudentAbsence getStudentAbsence) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Fetch the AbsenceResponse from the repository
      final response = await _repo.getStudentAbsenceRequests(getStudentAbsence);

      // Assuming the repository returns an AbsenceResponse or JSON response
      // If it's a raw JSON, you can do something like:
      // final jsonResponse = jsonDecode(response.body);
      // _absenceResponse = AbsenceResponse.fromJson(jsonResponse);

      // Directly assign the response to your AbsenceResponse variable
      absenceResponse = response; // Assuming response is already an AbsenceResponse

      // Update the pageInfo from the response
      pageInfo = absenceResponse.pageInfo;

    } catch (e) {
      Logger().e("Error requesting absence: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> getAllAbsenceRequests(GetStudentAbsence getStudentAbsence) async {
    // Thông báo UI bắt đầu tải dữ liệu
    notifyListeners();

    try {
      _isLoading = true;
      // Gửi yêu cầu thông qua repository
      _absenceLecturers = await _repo.getAllAbsenceRequests(getStudentAbsence);
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