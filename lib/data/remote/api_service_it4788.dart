
import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/model/user.dart';
import 'package:qldt/data/remote/api_service_it4788.dart';
import 'package:qldt/data/request/files_request.dart';
import 'package:qldt/data/request/login_request.dart';
import 'package:qldt/data/request/signup_request.dart';
import 'package:qldt/helper/constant.dart';
import 'package:qldt/helper/failure.dart';
import 'package:http/http.dart' as http;




abstract class ApiServiceIT4788 {
  Future<Either<Failure, String>> signUp(SignUpRequest request);
  Future<Either<Failure, ({User user, String token, List<Class> classes})>> login(LoginRequest request);
  Future<Either<Failure, String>> getVerifyCode(String email, String password);
  Future<Either<Failure, String>> checkVerifyCode(String email, String verifyCode);
  Future<Either<Failure, void>> changePassword(String token, String oldPassword, String newPassword);
  Future<User> changeInfoAfterSignUp(String token, FileRequest request);
  Future<User> getUserInfo(String token, String userId);
}

class ApiServiceIT4788Impl extends ApiServiceIT4788 {
    @override
    Future<Either<Failure, String>> signUp(SignUpRequest request) async {
      try {
        final String endpoint = '/it4788/signup';

        final Uri url = Uri.parse(Constant.BASEURL + endpoint);

        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(request.toJson())
        );
        var body = jsonDecode(response.body);

        if (response.statusCode == 200) {

          return Right(body['verify_code']);

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
  Future<Either<Failure, ({User user , String token, List<Class> classes})>> login(LoginRequest request) async {
    try {
      final String endpoint = '/it4788/login';
      Logger().d(request.fcmToken);
      final Uri url = Uri.parse(Constant.BASEURL + endpoint);

      var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(request.toJson())
      );
      var body;
      try {
        body = jsonDecode(response.body);
      } catch(e) {
        return Left(Failure(code: "0", message: response.body));
      }
      if (response.statusCode == 200) {
        return Right(
            (
              user: User.fromJson(body['data']),
              token: body['data']['token'],
              classes: (body['data']['class_list'] as List<dynamic>).map((it) => Class.fromJson(it)).toList()
            )
        );

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
  Future<User> changeInfoAfterSignUp(String token, FileRequest fileRequest) async {
    const url = '${Constant.BASEURL}/it4788/change_info_after_signup';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['token'] = token;

    request.files.add(
      http.MultipartFile.fromBytes(
          'file',
          fileRequest.fileData as List<int>,
          filename: fileRequest.file?.name,
          contentType: MediaType.parse("multipart/form-data")
      )
    );
    request.files.add;

    var response = await request.send();

    if(response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      if (jsonResponse['code'] == "1000") {
        return User.fromJson(jsonResponse['data']);
      } else {
        throw Exception(jsonResponse['data']);
      }
    } else {
      throw Exception("Failed to change avatar");
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(String token, String oldPassword, String newPassword) async {
    try {
      final String endpoint = '/it4788/change_password';
      final Uri url = Uri.parse(Constant.BASEURL + endpoint);
      final Map<String, dynamic> data = {
        'token': token,
        'old_password': oldPassword,
        'new_password': newPassword,
      };
      final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data)
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Right(null);
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
  Future<Either<Failure, String>> checkVerifyCode(String email, String verifyCode) async {
    try {
      final String endpoint = '/it4788/check_verify_code';
      final Uri url = Uri.parse(Constant.BASEURL + endpoint);
      final Map<String, dynamic> data = {
        'email': email,
        'verify_code': verifyCode
      };
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data)
      );
      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Right(body['userId']);
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
  Future<User> getUserInfo(String token, String userId) async {
    const url = '${Constant.BASEURL}/it4788/get_user_info';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "token": token,
        "user_id": int.parse(userId),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data['code'] == '1000') {
        return User.fromJson(data['data']);
      } else {
        throw Exception("Error: ${data['message']}");
      }
    } else {
      throw Exception("Failed to fetch materials");
    }
  }

  @override
  Future<Either<Failure, String>> getVerifyCode(String email, String password) async {
    try {
      final String endpoint = '/it4788/get_verify_code/';
      final Uri url = Uri.parse(Constant.BASEURL + endpoint);
      final Map<String, dynamic> data = {
        'email': email,
        'password': password
      };
      final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data)
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Right(body['data']);
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
}