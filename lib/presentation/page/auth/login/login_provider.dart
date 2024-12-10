import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/model/user.dart';
import 'package:qldt/data/repo/auth_repository.dart';
import 'package:qldt/data/request/login_request.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';

class LoginProvider extends ChangeNotifier {

  bool _isLoginSuccess = false;
  get isLoginSuccess => _isLoginSuccess;
  set setLoginState(bool state) {
    _isLoginSuccess = state;
    notifyListeners();
  }
  AuthRepository repo;
  User? user;
  List<Class> classes = [];
  String? token;
  LoginProvider(this.repo);

  Future<void> login(String email, String password, int deviceId) async {
    var response = await repo.login(LoginRequest(email, password, deviceId));
    response.fold(
        (left) {
          Logger().d(left.message);
          },
        (right) {
          user = right.user;
          token = right.token;
          classes = right.classes;
          UserPreferences.setUserInfo(token ?? "", user?.role ?? "", user?.id ?? "");
          setLoginState = true;
        }
    );
  }
}
