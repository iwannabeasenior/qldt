

import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/assignment.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/model/survey.dart';
import 'package:qldt/data/remote/api_service_it4788.dart';
import 'package:qldt/data/request/get_class_list_request.dart';
import 'package:qldt/data/request/survey_request.dart';
import 'package:qldt/helper/constant.dart';
import 'package:qldt/helper/failure.dart';
import 'package:http/http.dart' as http;



abstract class ApiServiceIT5023E {
  // class
  Future<Either<Failure, List<Class>>> getAllClass(GetClassListRequest request);
  // material
  Future<List<Materials>> getAllMaterials(String token, String classID);
  Future<String> deleteMaterial(String token, String materialID);
  // Future<String> uploadMaterial()
  // assignments
  Future<List<Assignment>> getStudentAssignments (String token, String type, String classId);
  Future<List<Survey>> getAllSurveys (String token, String classId);
  Future<List<GetSurveyResponse>> getSurveyResponse (String token, String surveyId, String? score, String? submissionId);
  Future<Map<String, dynamic>> createSurvey(SurveyRequest surveyRequest);
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
        return Right(
            (body['data']['page_content'] as List<dynamic>).map((value) =>
                Class.fromJson(value)).toList());
      } else {
        return Left(Failure(message: body['message'], code: body['code']));
      }
    } on SocketException {
      return Left(Failure(message: 'No Internet connection', code: "0"));
    } on FormatException {
      return Left(Failure(message: 'Bad response format', code: "0"));
    }
    catch (e) {
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
        return (data['data'] as List)
            .map((e) => Materials.fromJson(e))
            .toList();
      } else {
        throw Exception("Error: ${data['message']}");
      }
    } else {
      throw Exception("Failed to fetch materials");
    }
  }

  @override
  Future<String> deleteMaterial(String token, String materialID) async {
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
        return data['message'];
      } else {
        throw Exception("Error: ${data['message']}");
      }
    } else {
      throw Exception("Failed to fetch materials");
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
      throw Exception("Failed to fetch surveys");
    }
  }

  @override
  Future<Map<String, dynamic>> createSurvey(SurveyRequest surveyRequest) async {
    const url = '${Constant.BASEURL}/it5023e/create_survey';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    //form-data
    request.fields['token'] = surveyRequest.token;
    request.fields['classId'] = surveyRequest.classId;
    request.fields['deadline'] = surveyRequest.deadline;
    request.fields['title'] = surveyRequest.title;
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
      throw Exception("Failed to request absence + ${jsonResponse['meta']['message']}");
    }
  }

}
