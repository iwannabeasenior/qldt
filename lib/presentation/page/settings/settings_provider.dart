import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/repo/auth_repository.dart';

import '../../../helper/constant.dart';

class SettingsProvider extends ChangeNotifier {

  bool _isSuccess = false;
  get isSuccess => _isSuccess;
  set setState(bool state) {
    _isSuccess = state;
    notifyListeners();
  }

  AuthRepository repo;
  String? message;
  SettingsProvider(this.repo);

  Future<void> changePassword(String token, String oldPassword, String newPassword) async {
    var response = await repo.changePassword(token, oldPassword, newPassword);
    response.fold(
        (left) {
          Logger().d(left.message);
          message = left.message;
          setState = false;
          notifyListeners();
        },
        (right) {
          setState = true;
          notifyListeners();
        }
    );
  }

  Future<Map<String, dynamic>> logout(String token) async {
    final url = Uri.parse('${Constant.BASEURL}/it4788/logout');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"token": token}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Success response
      } else {
        return {"code": "1002", "message": "Something went wrong"};
      }
    } catch (e) {
      return {"code": "1003", "message": "Network error"};
    }
  }

}