
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:qldt/helper/failure.dart';
import 'package:http/http.dart' as http;

final options = BaseOptions(
  baseUrl: 'http://160.30.168.228:8080',
  connectTimeout: Duration(seconds: 5),
  receiveTimeout: Duration(seconds: 3),
  headers: {
    'Content-Type': 'application/json'
  },
  method: 'POST'
);

final dio = Dio(options);


const BASEURL = 'http://160.30.168.228:8080';

abstract class ApiService {
  Future<Either<Failure, String>> signUp(String firstName, String lastName, String email, String password, String uuid, String role);
}

class ApiServiceImpl extends ApiService {
  @override
  Future<Either<Failure, String>> signUp(String firstName, String lastName, String email, String password, String uuid, String role) async {
    try {
      final String endpoint = '/it4788/signup';

      final Uri url = Uri.parse(BASEURL + endpoint);

      final Map<String, dynamic> data = {
        "ho": firstName,
        "ten": lastName,
        "email": email,
        "password": password,
        "uuid": int.parse(uuid),
        "role": role
      };

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data)
      );
      Logger().d(response.body);
      var body = jsonDecode(response.body);

      if (response.statusCode == 200) {

        return Right(body['verify_code']);

      } else {

        return Left(Failure(message: body['message'], code: body['status_code']));

      }
    } catch (e) {

      return Left(Failure(code: 0, message: e.toString()));

    }
  }
}