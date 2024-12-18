import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/repo/auth_repository.dart';

class SettingsProvider extends ChangeNotifier {

  bool _isSuccess = false;
  get isSuccess => _isSuccess;
  set setState(bool state) {
    _isSuccess = state;
    notifyListeners();
  }

  AuthRepository repo;
  SettingsProvider(this.repo);

  Future<void> changePassword(String token, String oldPassword, String newPassword) async {
    var response = await repo.changePassword(token, oldPassword, newPassword);
    response.fold(
        (left) {
          Logger().d(left.message);
          setState = false;
          notifyListeners();
        },
        (right) {
          setState = true;
          notifyListeners();
        }
    );
  }
}