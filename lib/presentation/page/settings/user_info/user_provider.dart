import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/user.dart';
import 'package:qldt/data/repo/auth_repository.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';

enum ApiState {
  Pending,
  Success,
  Fail,
}
class UserProvider extends ChangeNotifier {
  bool _isLoadUserData = false;

  bool get isLoadUserData => _isLoadUserData;
  set setLoadUserData(bool state) {
    _isLoadUserData = state;
    notifyListeners();
  }

  AuthRepository repo;
  User? user;
  String? token = UserPreferences.getToken();
  String? userId = UserPreferences.getId();

  UserProvider(this.repo);

  // Future<void> initialize() async {
  //   token = UserPreferences.getToken();
  //   userId = UserPreferences.getId();
  //   notifyListeners();
  // }

  Future<void> getUserInfo(String token, String userId) async {
    var response = await repo.getUserInfo(token, userId);
    response.fold(
        (left) {
          Logger().d(left.code + ":" + left.message);
        },
        (right) {
          user = right;
          Logger().d(user);
          setLoadUserData = true;
        },
    );
  }
}

