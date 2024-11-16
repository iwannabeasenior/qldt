
import 'dart:convert';
import 'dart:io';
import 'dart:js_interop';
import 'package:dartz/dartz.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/model/user.dart';
import 'package:qldt/data/request/login_request.dart';
import 'package:qldt/data/request/signup_request.dart';
import 'package:qldt/helper/failure.dart';
import 'package:http/http.dart' as http;


const BASEURL = 'http://160.30.168.228:8080';

abstract class ApiServiceIT4788 {
  Future<Either<Failure, String>> signUp(SignUpRequest request);
  Future<Either<Failure, ({User user, String token, List<Class> classes})>> login(LoginRequest request);
  Future<Either<Failure, String>> getVerifyCode(String email, String password);
  Future<Either<Failure, int>> checkVerifyCode(String email, String verifyCode);
  Future<Either<Failure, void>> changePassword(String token, String oldPassword, String newPassword);
  Future<Either<Failure, void>> changeInfoAfterSignUp();
  Future<Either<Failure, User>> getUserInfo(String token, int userId);
}

class ApiServiceIT4788Impl extends ApiServiceIT4788 {
    @override
    Future<Either<Failure, String>> signUp(SignUpRequest request) async {
      try {
        final String endpoint = '/it4788/signup';

        final Uri url = Uri.parse(BASEURL + endpoint);

        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(request.toJson())
        );
        var body = jsonDecode(response.body);

        if (response.statusCode == 200) {

          return Right(body['verify_code']);

        } else {

          return Left(Failure(message: body['message'], code: body['status_code']));

        }
      } on SocketException {
        return Left(Failure(message: 'No Internet connection', code: 0));
      } on FormatException {
        return Left(Failure(message: 'Bad response format', code: 0));
      }
      catch(e) {
        return Left(Failure(code: 0, message: e.toString()));
      }
    }

  @override
  Future<Either<Failure, ({User user , String token, List<Class> classes})>> login(LoginRequest request) async {
    try {
      final String endpoint = '/it4788/login';

      final Uri url = Uri.parse(BASEURL + endpoint);

      var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(request.toJson())
      );
      var body;
      try {
        body = jsonDecode(response.body);
      } catch(e) {
        return Left(Failure(code: 0, message: response.body));
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

        return Left(Failure(message: body['message'], code: body['status_code']));

      }
    } on SocketException {
      return Left(Failure(message: 'No Internet connection', code: 0));
    } on FormatException {
      return Left(Failure(message: 'Bad response format', code: 0));
    }
    catch(e) {
      return Left(Failure(code: 0, message: e.toString()));
    }

  }

  @override
  Future<Either<Failure, JSAny>> changeInfoAfterSignUp() {
    // TODO: implement changeInfoAfterSignUp
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> changePassword(String token, String oldPassword, String newPassword) async {
    try {
      final String endpoint = '/it4788/change_password/';
      final Uri url = Uri.parse(BASEURL + endpoint);
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
        return Left(Failure(message: body['message'], code: body['status_code']));
      }
    } on SocketException {
      return Left(Failure(message: 'No Internet connection', code: 0));
    } on FormatException {
      return Left(Failure(message: 'Bad response format', code: 0));
    }
    catch(e) {
      return Left(Failure(code: 0, message: e.toString()));
    }

  }

  @override
  Future<Either<Failure, int>> checkVerifyCode(String email, String verifyCode) async {
    try {
      final String endpoint = '/it4788/check_verify_code';
      final Uri url = Uri.parse(BASEURL + endpoint);
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
        return Left(Failure(message: body['message'], code: body['status_code']));
      }
    } on SocketException {
      return Left(Failure(message: 'No Internet connection', code: 0));
    } on FormatException {
      return Left(Failure(message: 'Bad response format', code: 0));
    }
    catch(e) {
      return Left(Failure(code: 0, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserInfo(String token, int userId) async {
      try {
        final String endpoint = '/it4788/get_user_info/';
        final Uri url = Uri.parse(BASEURL + endpoint);
        final Map<String, dynamic> data = {
          'token': token,
          'user_id': userId
        };
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data)
        );
        final body = jsonDecode(response.body);
        if (response.statusCode == 200) {
          return Right(User.fromJson(body));
        } else {
          return Left(Failure(code: body['status_code'], message: body['message']));
        }
      } on SocketException {
        return Left(Failure(message: 'No Internet connection', code: 0));
      } on FormatException {
        return Left(Failure(message: 'Bad response format', code: 0));
      }
      catch(e) {
        return Left(Failure(code: 0, message: e.toString()));
      }
  }

  @override
  Future<Either<Failure, String>> getVerifyCode(String email, String password) async {
    try {
      final String endpoint = '/it4788/get_verify_code/';
      final Uri url = Uri.parse(BASEURL + endpoint);
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
        return Left(Failure(message: body['message'], code: body['status_code']));
      }
    } on SocketException {
      return Left(Failure(message: 'No Internet connection', code: 0));
    } on FormatException {
      return Left(Failure(message: 'Bad response format', code: 0));
    }
    catch(e) {
      return Left(Failure(code: 0, message: e.toString()));
    }

  }
}