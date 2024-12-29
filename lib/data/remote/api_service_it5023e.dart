import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/absence_student.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/request/class_create_request.dart';
import 'package:qldt/data/request/edit_class_request.dart';
import 'package:qldt/data/request/get_class_list_request.dart';
import 'package:qldt/data/request/get_student_absence.dart';
import 'package:qldt/data/request/material_request.dart';
import 'package:qldt/helper/constant.dart';
import 'package:qldt/helper/failure.dart';
import 'package:http/http.dart' as http;
import '../model/absence_lecturer.dart';
import '../model/attendance_student_detail.dart';
import '../model/class_info.dart';
import '../model/open_class_response.dart';
import '../request/absence_request.dart';
import '../request/get_attendance_list_request.dart';
import '../model/assignment.dart';
import '../model/survey.dart';
import '../request/survey_request.dart';



abstract class ApiServiceIT5023E {
  // class
  Future<Either<Failure, List<Class>>> getAllClass(GetClassListRequest request);
  Future<ClassInfo> getClassInfo(String token, String role, String accountId,String classId);
  Future<Map<String, dynamic>> editClass(EditClassRequest editClassRequest);
  Future<void> addStudent(String token, String classId, String accountId);
  // material
  Future<List<Materials>> getAllMaterials(String token, String classID);
  Future<void> deleteMaterial(String token, String materialID);
  Future<Materials> uploadMaterial(UploadMaterialRequest request);
  Future<Materials> editMaterial(EditMaterialRequest request);
  Future<Materials> getMaterialInfo(String token, String materialId);
  //absence
  Future<Map<String, dynamic>> requestAbsence(AbsenceRequest absenceRequest);
  Future<List<AbsenceStudent>> getStudentAbsenceRequests(GetStudentAbsence getStudentAbsence);
  Future<List<AbsenceLecturer>> getAllAbsenceRequests(GetStudentAbsence getStudentAbsence);
  Future<Map<String, dynamic>> reviewAbsenceRequest(String token, String requestId, String status);
  //attendance
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
  //manage_class
  Future<Map<String, dynamic>> createClass(ClassCreateRequest classCreateRequest);
  Future<OpenClassResponse> getOpenClass(String token, String page, String pageSize);
  Future<Map<String, dynamic>> registerClass(String token, List<String> classIds);
  // assignments
  Future<List<Assignment>> getStudentAssignments (String token, String type, String classId);
  Future<List<Survey>> getAllSurveys (String token, String classId);
  Future<List<GetSurveyResponse>> getSurveyResponse (String token, String surveyId, String? score, String? submissionId);
  Future<Map<String, dynamic>> createSurvey(SurveyRequest surveyRequest);
  Future<Map<String, dynamic>> editSurvey(SurveyRequest surveyRequest);
  Future<Map<String, dynamic>> submitSurvey(SubmitSurveyRequest submitSurveyRequest);
  Future<GetSurveyResponse> getSubmission (String token, String assignmentId);
  Future<String> deleteSurvey(String token, String surveyId);
  }

class ApiServiceIT5023EImpl extends ApiServiceIT5023E {
  @override
  Future<Either<Failure, List<Class>>> getAllClass(GetClassListRequest request) async {
    try {
      const String endpoint = '/it5023e/get_class_list';

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

  @override
  Future<Map<String, dynamic>> editClass(EditClassRequest editClassRequest) async {
    const url = '${Constant.BASEURL}/it5023e/edit_class'; // URL của API

    final Map<String, dynamic> requestBody = {
      'token': editClassRequest.token,
      'class_id': editClassRequest.classId,
      'class_name': editClassRequest.className,
      'status': editClassRequest.status,
      'start_date': editClassRequest.startDate,
      'end_date': editClassRequest.endDate,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // Kiểm tra mã code từ response
      if (jsonResponse['meta']['code'] == "1000") {
        // Trả về dữ liệu thành công
        return jsonResponse['data'];
      } else {
        throw Exception(jsonResponse['meta']['message']);
      }
    } else {
      final jsonResponse = jsonDecode(response.body);
      throw Exception("Failed to request absence + ${jsonResponse['meta']['message']}");
    }
  }

  @override
  Future<void> addStudent(String token, String classId, String accountId) async {
    const url = '${Constant.BASEURL}/it5023e/add_student';

    try {
      final Map<String, dynamic> requestBody = {
        'token': token,
        'class_id': classId,
        'account_id': accountId
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      final jsonResponse = jsonDecode(response.body);

      // Kiểm tra code từ response meta
      if (jsonResponse['meta']['code'] != "1000") {
        throw Exception(jsonResponse['meta']['message']);
      }

      return jsonResponse['data'];

    } catch (e) {
      print('Error adding student: $e'); // Log lỗi
      throw e; // Throw lỗi để UI xử lý
    }
  }

  @override
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

    request.fields['classId'] = materialRequest.classID;
    request.fields['title'] = materialRequest.title ?? "";
    request.fields['description'] = materialRequest.description ?? "";
    request.fields['materialType'] = materialRequest.materialType ?? "";
    request.fields['token'] = materialRequest.token;

    request.files.add(
        http.MultipartFile.fromBytes(
            'file',
            materialRequest.file?.fileData as List<int>,
            filename: materialRequest.file?.file?.name,
            contentType: MediaType.parse("multipart/form-data")
        )
    );

    request.files.add;

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

    if (materialRequest.file?.fileData != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          materialRequest.file!.fileData as List<int>, // ! vì đã kiểm tra null ở trên
          filename: materialRequest.file?.file?.name,
          contentType: MediaType.parse("multipart/form-data"),
        ),
      );
    }

    request.files.add;

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
    request.fields['date'] = absenceRequest.date!;
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
        Logger().d('testtt ${jsonResponse['data']}');
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
    const url = '${Constant.BASEURL}/it5023e/get_class_info';

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
      const String endpoint = '/it5023e/get_attendance_list';
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
  Future<Map<String, dynamic>> createClass(ClassCreateRequest classCreateRequest) async {
    const url = '${Constant.BASEURL}/it5023e/create_class';

    try {
      Logger().d("tesssst ${classCreateRequest.toJson()}");
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(classCreateRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['meta']['code'] == '1000') {
          return jsonResponse['data'];
        } else {
          throw Exception("${jsonResponse['meta']['message']}");
        }
      } else {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        throw Exception("Failed to create class: ${jsonResponse['meta']['message']}");
      }
    } catch (e) {
      throw e;
    }
  }


  @override
  Future<OpenClassResponse> getOpenClass(String token, String page, String pageSize) async {
    const url = '${Constant.BASEURL}/it5023e/get_open_classes';

    // Tạo payload yêu cầu
    final requestPayload = {
      "token": token,
      "pageable_request": {
        "page": page,
        "page_size": pageSize,
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestPayload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        // Parse dữ liệu và trả về OpenClassResponse
        return OpenClassResponse.fromJson(jsonResponse);
      } else {
        throw Exception("Failed to load open classes: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }


  @override
  Future<Map<String, dynamic>> registerClass(String token, List<String> classIds) async {
    const url = '${Constant.BASEURL}/it5023e/register_class';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'class_ids': classIds,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        Logger().d('anxaxnnx: ${jsonResponse['data']}');
        return {
          'status': 'sucesss',
          'message': ' ${jsonResponse['data']}',
        };
      } else {
        return {
          'status': 'failure',
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      throw Exception("Error: $e");

    }
  }

  //assignments
  @override
  Future<List<Assignment>> getStudentAssignments(String token, String type, String classId) async {
    const url = '${Constant.BASEURL}/it5023e/get_student_assignments';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "token": token,
        "type": type,
        "class_id": classId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['meta']['code'] == '1000') {
        return (data['data'] as List)
            .map((e) => Assignment.fromJson(e))
            .toList();
      } else {
        throw Exception("Error: ${data['message']}");
      }
    } else {
      throw Exception("Failed to fetch assignments");
    }
  }

  @override
  Future<List<Survey>> getAllSurveys(String token, String classId) async {
    const url = '${Constant.BASEURL}/it5023e/get_all_surveys';

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
      if (data['meta']['code'] == '1000') {
        return (data['data'] as List)
            .map((e) => Survey.fromJson(e))
            .toList();
      } else {
        throw Exception("Error: ${data['message']}");
      }
    } else {
      throw Exception("Failed to fetch surveys");
    }
  }

  @override
  Future<List<GetSurveyResponse>> getSurveyResponse(String token, String surveyId, String? score, String? submissionId) async {
    const url = '${Constant.BASEURL}/it5023e/get_survey_response';

    // Tạo body cho request
    Map<String, dynamic> body = {
      "token": token,
      "survey_id": surveyId,
    };
    if (score != null && submissionId != null) {
      body['grade'] = {
        "score": score,
        "submission_id": submissionId,
      };
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['meta']['code'] == '1000') {
        return (data['data'] as List)
            .map((e) => GetSurveyResponse.fromJson(e))
            .toList();
      } else {
        throw Exception("Error: ${data['message']}");
      }
    } else {
      throw Exception("Failed to call survey responses");
    }
  }

  @override
  Future<Map<String, dynamic>> createSurvey(SurveyRequest surveyRequest) async {
    const url = '${Constant.BASEURL}/it5023e/create_survey';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    //form-data
    request.fields['token'] = surveyRequest.token;
    request.fields['classId'] = surveyRequest.classId!;
    request.fields['deadline'] = surveyRequest.deadline;
    request.fields['title'] = surveyRequest.title!;
    request.fields['description'] = surveyRequest.description;

    //add files to req
    for (var i = 0; i < surveyRequest.files.length; i++) {
      request.files.add(
          http.MultipartFile.fromBytes(
              'file',
              surveyRequest.files[i].fileData as List<int>,
              filename: surveyRequest.files[i].file?.name,
              contentType: MediaType.parse("multipart/form-data")
          )
      );
    }
    request.files.add;

    //req and res
    var response = await request.send();
    if (response.statusCode == 200) {
      Logger().d('OK');
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      //meta code message
      if (jsonResponse['meta']['code'] == "1000") {
        //get data successfully
        return jsonResponse['data'];
      } else {
        throw(jsonResponse['meta']['message']);
      }
    } else {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      throw Exception("Failed to create survey + ${jsonResponse['meta']['message']}");
    }
  }

  @override
  Future<Map<String, dynamic>> editSurvey(SurveyRequest surveyRequest) async {
    const url = '${Constant.BASEURL}/it5023e/edit_survey';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    //form-data
    request.fields['token'] = surveyRequest.token;
    request.fields['assignmentId'] = surveyRequest.assignmentId!;
    request.fields['deadline'] = surveyRequest.deadline;
    request.fields['description'] = surveyRequest.description;

    //add files to req
    for (var i = 0; i < surveyRequest.files.length; i++) {
      request.files.add(
          http.MultipartFile.fromBytes(
              'file',
              surveyRequest.files[i].fileData as List<int>,
              filename: surveyRequest.files[i].file?.name,
              contentType: MediaType.parse("multipart/form-data")
          )
      );
    }
    request.files.add;

    //req and res
    var response = await request.send();
    if (response.statusCode == 200) {
      Logger().d('OK');
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      //meta code message
      if (jsonResponse['meta']['code'] == "1000") {
        //get data successfully
        return jsonResponse['data'];
      } else {
        throw(jsonResponse['meta']['message']);
      }
    } else {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      throw Exception("${jsonResponse['data']}");
    }
  }

  @override
  Future<Map<String, dynamic>> submitSurvey(SubmitSurveyRequest submitSurveyRequest) async {
    const url = '${Constant.BASEURL}/it5023e/submit_survey';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    //form-data
    request.fields['token'] = submitSurveyRequest.token;
    request.fields['assignmentId'] = submitSurveyRequest.assignmentId;
    request.fields['textResponse'] = submitSurveyRequest.textResponse;

    //add files to req
    for (var i = 0; i < submitSurveyRequest.files.length; i++) {
      request.files.add(
          http.MultipartFile.fromBytes(
              'file',
              submitSurveyRequest.files[i].fileData as List<int>,
              filename: submitSurveyRequest.files[i].file?.name,
              contentType: MediaType.parse("multipart/form-data")
          )
      );
    }
    request.files.add;

    //req and res
    var response = await request.send();
    if (response.statusCode == 200) {
      Logger().d('OK');
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      //meta code message
      if (jsonResponse['meta']['code'] == "1000") {
        //get data successfully
        return jsonResponse['data'];
      } else {
        throw(jsonResponse['data']);
      }
    } else {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      throw Exception("Failed to submit + ${jsonResponse['meta']['message']}");
    }
  }

  @override
  Future<GetSurveyResponse> getSubmission(String token, String assignmentId) async {
    const url = '${Constant.BASEURL}/it5023e/get_submission';

    try {
      final Map<String, dynamic> requestBody = {
        'token': token,
        'assignment_id': assignmentId
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      final jsonResponse = jsonDecode(response.body);

      // Kiểm tra code từ response meta
      if (jsonResponse['meta']['code'] == "1000") {
        return GetSurveyResponse.fromJson(jsonResponse['data']);
      }
      throw Exception(jsonResponse['meta']['message']);
    } catch (e) {
      Logger().e('Error: $e'); // Log lỗi
      rethrow; // Throw lỗi để UI xử lý
    }
  }

  @override
  Future<String> deleteSurvey(String token, String surveyId) async {
    const url = '${Constant.BASEURL}/it5023e/delete_survey';

    try {
      final Map<String, dynamic> requestBody = {
        'token': token,
        'survey_id': surveyId
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      final jsonResponse = jsonDecode(response.body);

      // Kiểm tra code từ response meta
      if (jsonResponse['meta']['code'] != "1000") {
        throw Exception(jsonResponse['data']);
      }

      return jsonResponse['data'];

    } catch (e) {
      Logger().e('Error delete survey: $e'); // Log lỗi
      rethrow; // Throw lỗi để UI xử lý
    }
  }
}





