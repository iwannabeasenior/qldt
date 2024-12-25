

import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:qldt/data/model/absence_student.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/remote/api_service_it4788.dart';
import 'package:qldt/data/request/get_class_list_request.dart';
import 'package:qldt/data/request/get_student_absence.dart';
import 'package:qldt/data/request/material_request.dart';
import 'package:qldt/helper/constant.dart';
import 'package:qldt/helper/failure.dart';
import 'package:http/http.dart' as http;

import '../model/absence_lecturer.dart';
import '../model/attendance_student_detail.dart';
import '../model/class_info.dart';
import '../request/absence_request.dart';
import '../request/get_attendance_list_request.dart';



abstract class ApiServiceIT5023E {
  // class
  Future<Either<Failure, List<Class>>> getAllClass(GetClassListRequest request);
  Future<ClassInfo> getClassInfo(String token, String role, String accountId,String classId);

  // material
  Future<List<Materials>> getAllMaterials(String token, String classID);
  Future<void> deleteMaterial(String token, String materialID);
  Future<Materials> uploadMaterial(UploadMaterialRequest request);
  Future<Materials> editMaterial(EditMaterialRequest request);
  Future<Materials> getMaterialInfo(String token, String materialId);

  Future<Map<String, dynamic>> requestAbsence(AbsenceRequest absenceRequest);
  Future<List<AbsenceStudent>> getStudentAbsenceRequests(GetStudentAbsence getStudentAbsence);
  Future<List<AbsenceLecturer>> getAllAbsenceRequests(GetStudentAbsence getStudentAbsence);
  Future<Map<String, dynamic>> reviewAbsenceRequest(String token, String requestId, String status);

  Future<List<String>> getAttendanceDates(String token, String classId);
  Future<List<String>> getAttendanceRecord(String token, String classId);
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
  // Chat api
  Future<void> getListConversations(String token, int index, int count);
  
  Future<void> getConverstaion(String token, int index, int count, int converstationId, bool markAsRead);
  
  Future<void> deleteMessage(String token, int messageId, int conversationId);
  // Noti Api
}


class ApiServiceIT5023EImpl extends ApiServiceIT5023E {
  @override
  Future<Either<Failure, List<Class>>> getAllClass(GetClassListRequest request) async {
    try {
      final String endpoint = '/it5023e/get_class_list';

      final Uri url = Uri.parse(Constant.BASEURL + endpoint);

      var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(request.toJson())
      );
      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {

        return Right((body['data']['page_content'] as List<dynamic>).map((value) => Class.fromJson(value)).toList());

      } else {

        return Left(Failure(message: body['message'], code: body['code']));

      }
    } on SocketException {
      return Left(Failure(message: 'No Internet connection', code: "0"));
    } on FormatException {
      return Left(Failure(message: 'Bad response format', code: "0"));
    }
    catch(e) {
      return Left(Failure(code: "0", message: e.toString()));
    }

  }

  Future<List<Materials>> getAllMaterials(String token, String classId) async {

    const url = '${Constant.BASEURL}/it5023e/get_material_list';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "token": token,
        "class_id": classId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['code'] == '1000') {
        return (data['data'] as List).map((e) => Materials.fromJson(e)).toList();
      } else {
        throw Exception("Error: ${data['message']}");
      }
    } else {
      throw Exception("Failed to fetch materials");
    }
  }

  @override
  Future<void> deleteMaterial(String token, String materialID) async {
    const url = '${Constant.BASEURL}/it5023e/delete_material';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "token": token,
        "material_id": int.parse(materialID),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['code'] == '1000') {
        return;
      } else {
        throw Exception("Error: ${data['message']}");
      }
    } else {
      throw Exception("Failed to delete materials");
    }
  }

  @override
  Future<Materials> uploadMaterial(UploadMaterialRequest materialRequest) async {
    const url = '${Constant.BASEURL}/it5023e/upload_material';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['classID'] = materialRequest.classID;
    request.fields['title'] = materialRequest.title ?? "";
    request.fields['description'] = materialRequest.description ?? "";
    request.fields['materialType'] = materialRequest.materialType ?? "";
    request.fields['token'] = materialRequest.token;

    var fileStream = http.MultipartFile(
      'file',
      materialRequest.files.first.openRead(),
      await materialRequest.files.first.length(),
      filename: basename(materialRequest.files.first.path),
    );

    request.files.add(fileStream);

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      if (jsonResponse['code'] == 1000) {
        return Materials.fromJson(jsonResponse['data']); // response without url
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception("Failed to upload material");
    }
  }

  @override
  Future<Materials> editMaterial(EditMaterialRequest materialRequest) async {
    const url = '${Constant.BASEURL}/it5023e/edit_material';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['materialId'] = materialRequest.materialId;
    request.fields['title'] = materialRequest.title ?? "";
    request.fields['description'] = materialRequest.description ?? "";
    request.fields['materialType'] = materialRequest.materialType ?? "";
    request.fields['token'] = materialRequest.token;

    var fileStream = http.MultipartFile(
        'file',
        materialRequest.files.first.openRead(),
        await materialRequest.files.first.length(),
        filename: basename(materialRequest.files.first.path),
    );

    request.files.add(fileStream);

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      if (jsonResponse['code'] == 1000) {
        return Materials.fromJson(jsonResponse['data']); // response without url
      } else {
        throw Exception(jsonResponse['message']);
      }
    } else {
      throw Exception("Failed to edit material");
    }
  }

  @override
  Future<Materials> getMaterialInfo(String token, String materialId) async {
    const url = '${Constant.BASEURL}/it5023e/get_material_info';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "token": token,
        "material_id": materialId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['code'] == '1000') {
        return Materials.fromJson(data['data']);
      } else {
        throw Exception("Error: ${data['message']}");
      }
    } else {
      throw Exception("Failed to get material info");
    }
  }

  @override
  Future<Map<String, dynamic>> requestAbsence(AbsenceRequest absenceRequest) async {
    const url = '${Constant.BASEURL}/it5023e/request_absence'; // URL của API

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Thêm các trường form-data
    request.fields['token'] = absenceRequest.token!;
    request.fields['classId'] = absenceRequest.classId!;
    request.fields['date'] = "2024-11-28";
    request.fields['reason'] = absenceRequest.reason!;
    request.fields['title'] = absenceRequest.title!;

    // Tạo MultipartFile từ file

    // Thêm file vào request
    for (var i = 0; i < absenceRequest.files!.length; i++) {
      request.files.add(
          http.MultipartFile.fromBytes(
              'file',
              absenceRequest.files?[i].fileData as List<int>,
              filename: absenceRequest.files?[i].file?.name,
              contentType: MediaType.parse("multipart/form-data")
          )
      );
    }
    request.files.add;

    // Gửi yêu cầu và nhận phản hồi
    var response = await request.send();
    if (response.statusCode == 200) {
      Logger().d("andj");
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      // Kiểm tra mã code từ response
      if (jsonResponse['meta']['code'] == "1000") {
        // Trả về dữ liệu thành công
        return jsonResponse['data'];
      } else {
        throw Exception(jsonResponse['meta']['message']);
      }
    } else {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      throw Exception("Failed to request absence + ${jsonResponse['meta']['message']}");
    }
  }

  @override
  Future<List<AbsenceStudent>> getStudentAbsenceRequests(GetStudentAbsence getStudentAbsence) async {
    const String url = '${Constant.BASEURL}/it5023e/get_student_absence_requests';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(getStudentAbsence.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['meta']['code'] == "1000") {
        // Chuyển đổi danh sách JSON thành danh sách AbsenceStudent
        final List<dynamic> pageContent = jsonResponse['data']['page_content'];
        return pageContent.map((json) => AbsenceStudent.fromJson(json)).toList();
      } else {
        throw Exception("Error: ${jsonResponse['meta']['message']}");
      }
    } else {
      throw Exception("Failed to fetch student absence requests. Status code: ${response.statusCode}");
    }
  }

  @override
  Future<List<AbsenceLecturer>> getAllAbsenceRequests(GetStudentAbsence getStudentAbsence) async {
    const String url = '${Constant.BASEURL}/it5023e/get_absence_requests';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(getStudentAbsence.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['meta']['code'] == "1000") {
        Logger().d('testtt ${jsonResponse}');
        // Chuyển đổi danh sách JSON thành danh sách AbsenceStudent
        final List<dynamic> pageContent = jsonResponse['data']['page_content'];
        return pageContent.map((json) => AbsenceLecturer.fromJson(json)).toList();
      } else {
        throw Exception("Error: ${jsonResponse['meta']['message']}");
      }
    } else {
      throw Exception("Failed to fetch student absence requests. Status code: ${response.statusCode}");
    }
  }

  @override
  Future<Map<String, dynamic>> reviewAbsenceRequest(String token, String requestId, String status) async {
    const url = '${Constant.BASEURL}/it5023e/review_absence_request'; // URL của API

    // Tạo yêu cầu POST
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "token": token,
        "request_id": requestId,
        "status": status,  // ACCEPTED, PENDING, REJECTED
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);


      // Kiểm tra mã code từ response
      if (jsonResponse['meta']['code'] == "1000") {
        // Trả về dữ liệu thành công
        return jsonResponse['data'];  // Dữ liệu trả về khi yêu cầu thành công
      } else {
        throw Exception("Error: ${jsonResponse['meta']['message']}");
      }
    } else {
      throw Exception("Failed to review absence request");
    }
  }

  @override
  Future<List<String>> getAttendanceDates(String token, String classId) async {
    const url = '${Constant.BASEURL}/it5023e/get_attendance_dates';  // Replace with the correct endpoint

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "token": token,
        "class_id": classId,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Check if the response code is "1000", indicating success
      if (jsonResponse['meta']['code'] == "1000") {
        // Extract the attendance dates from the "data" key
        final List<dynamic> data = jsonResponse['data'];
        // Return the list of dates as strings
        return data.map((date) => date.toString()).toList();
      } else {
        throw Exception("Error: ${jsonResponse['meta']['message']}");
      }
    } else {
      throw Exception("Failed to fetch attendance dates. Status code: ${response.statusCode}");
    }
  }

  @override
  Future<List<String>> getAttendanceRecord(String token, String classId) async {
    const url = '${Constant.BASEURL}/it5023e/get_attendance_record';  // Replace with the correct endpoint

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "token": token,
        "class_id": classId,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Check if the response code is "1000", indicating success
      if (jsonResponse['meta']['code'] == "1000") {
        // Check if the "absent_dates" key exists and is not null
        final List<dynamic>? data = jsonResponse['data']['absent_dates'];

        if (data != null) {
          // Return the list of dates as strings
          return data.map((date) => date.toString()).toList();
        } else {
          throw Exception("No absent dates available in the response.");
        }
      } else {
        throw Exception("Error: ${jsonResponse['meta']['message']}");
      }
    } else {
      throw Exception("Failed to fetch attendance dates. Status code: ${response.statusCode}");
    }

  }

  @override
  Future<ClassInfo> getClassInfo(String token, String role, String accountId, String classId,) async {
    const url = '${Constant.BASEURL}/it5023e/get_class_info';  // Replace with the correct endpoint

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'token': token,
        'role': role,
        'account_id': accountId, // Replace with actual account_id if needed
        'class_id': classId,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Check if the response code is "1000", indicating success
      if (jsonResponse['meta']['code'] == '1000') {
        // Extract the data and return it as a ClassInfo object
        return ClassInfo.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Error: ${jsonResponse['meta']['message']}');
      }
    } else {
      throw Exception('Failed to fetch class info. Status code: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> takeAttendance({
    required String token,
    required String classId,
    required String date,
    required List<String> attendanceList,
  }) async {
    const url = '${Constant.BASEURL}/it5023e/take_attendance';  // Thay đổi endpoint nếu cần

    // Tạo dữ liệu gửi lên API
    final body = jsonEncode({
      'token': token,
      'class_id': classId,
      'date': date,
      'attendance_list': attendanceList,
    });

    try {
      // Gửi yêu cầu POST đến API
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Đọc dữ liệu phản hồi từ API
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Kiểm tra mã code từ phản hồi
        if (jsonResponse['meta']['code'] == '1000') {
          // Thành công
          return jsonResponse;
        } else {
          // Lỗi từ API
          throw Exception("Error: ${jsonResponse['meta']['message']}");
        }
      } else {
        // Lỗi từ server
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        throw Exception("Failed to take attendance: ${jsonResponse['meta']['message']}");
      }
    } catch (e) {
      // Lỗi kết nối hoặc bất kỳ lỗi nào khác
      throw Exception("Error: $e");
    }
  }

  @override
  Future<GetAttendanceListResponse> getAttendanceList(GetAttendanceListRequest request) async {
    try {
      final String endpoint = '/it5023e/get_attendance_list';
      final Uri url = Uri.parse(Constant.BASEURL + endpoint);

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (body['meta']['code'] == '1000') {
          return GetAttendanceListResponse.fromJson(body['data']);
        } else {
          throw Exception("Error: ${body['meta']['message']}");
        }
      } else {
        throw Exception("Failed to get attendance list: ${body['meta']['message']}");
      }
    } catch (e) {
      // Ensure that the exception is thrown or handled properly
      throw Exception("Error: $e");
    }
  }

  @override
  Future<Map<String, dynamic>> setAttendanceStatus({required String token, required String attendanceId, required String status}) async {
    const url = '${Constant.BASEURL}/it5023e/set_attendance_status';  // Replace with correct endpoint

    // Create the body of the request
    final body = jsonEncode({
      'token': token,
      'attendance_id': attendanceId,
      'status': status,  // "PRESENT", "EXCUSED_ABSENCE", "UNEXCUSED_ABSENCE"
    });

    try {
      // Make a POST request to the API
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Check if the response code is "1000", indicating success
        if (jsonResponse['meta']['code'] == '1000') {
          // Success
          return jsonResponse['data'];
        } else {
          // Handle API error
          throw Exception("Error: ${jsonResponse['meta']['message']}");
        }
      } else {
        // Handle server errors
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        throw Exception("Failed to set attendance status: ${jsonResponse['meta']['message']}");
      }
    } catch (e) {
      // Handle connection or any other errors
      throw Exception("Error: $e");
    }

  }

  @override
  Future<void> deleteMessage(String token, int messageId, int conversationId) {
    // TODO: implement deleteMessage
    throw UnimplementedError();
  }

  @override
  Future<void> getConverstaion(String token, int index, int count, int converstationId, bool markAsRead) {
    // TODO: implement getConverstaion
    throw UnimplementedError();
  }

  @override
  Future<void> getListConversations(String token, int index, int count) {
    // TODO: implement getListConversations
    throw UnimplementedError();
  }




}


