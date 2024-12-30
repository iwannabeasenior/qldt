import 'package:flutter/cupertino.dart';
import 'package:qldt/data/model/user.dart';
import 'package:qldt/data/repo/auth_repository.dart';
import 'package:qldt/data/request/files_request.dart';

class UserProvider with ChangeNotifier {
  final AuthRepository _repo;

  UserProvider(this._repo);

  User _user = User(
      id: '',
      status: '',
      name: '',
      role: '',
      firstName: '',
      lastName: '',
      avatar: '',
      email: '');

  bool _isLoading = false;

  User get user => _user;

  bool get isLoading => _isLoading;

  Future<void> getUserInfo(String token, String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _repo.getUserInfo(token, userId);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeInfoAfterSignup(String token, FileRequest fileRequest) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _repo.changeInfoAfterSignUp(token, fileRequest);
    } catch(e) {
      throw(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
