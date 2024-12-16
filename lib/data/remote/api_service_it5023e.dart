

import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path/path.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/remote/api_service_it4788.dart';
import 'package:qldt/data/request/get_class_list_request.dart';
import 'package:qldt/data/request/material_request.dart';
import 'package:qldt/helper/constant.dart';
import 'package:qldt/helper/failure.dart';
import 'package:http/http.dart' as http;



abstract class ApiServiceIT5023E {
  // class
  Future<Either<Failure, List<Class>>> getAllClass(GetClassListRequest request);

  // material
  Future<List<Materials>> getAllMaterials(String token, String classID);
  Future<void> deleteMaterial(String token, String materialID);
  Future<Materials> uploadMaterial(UploadMaterialRequest request);
  Future<Materials> editMaterial(EditMaterialRequest request);
  Future<Materials> getMaterialInfo(String token, String materialId);
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
    request.fields['title'] = materialRequest.title;
    request.fields['description'] = materialRequest.description;
    request.fields['materialType'] = materialRequest.materialType;
    request.fields['token'] = materialRequest.token;

    var fileStream = http.MultipartFile(
      'file',
      materialRequest.file.openRead(),
      await materialRequest.file.length(),
      filename: basename(materialRequest.file.path),
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
    request.fields['title'] = materialRequest.title;
    request.fields['description'] = materialRequest.description;
    request.fields['materialType'] = materialRequest.materialType;
    request.fields['token'] = materialRequest.token;

    var fileStream = http.MultipartFile(
        'file',
        materialRequest.file.openRead(),
        await materialRequest.file.length(),
        filename: basename(materialRequest.file.path),
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
}


