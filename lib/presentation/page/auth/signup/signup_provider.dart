import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/repo/auth_repository.dart';
import 'package:qldt/data/request/signup_request.dart';
import 'package:qldt/presentation/error/noti_error.dart';


class SignUpProvider extends ChangeNotifier {
  AuthRepository repo;

  SignUpProvider(this.repo);

  String verifyCode = "";

  bool _isSignupSuccess = false;

  bool get isSignupSuccess => _isSignupSuccess; // function get

  set setSignupState(bool state) {
    _isSignupSuccess = state;
    notifyListeners();
  }

  void requestSignUp(String firstName, String lastName, String email, String password, String uuid, String role) async {

    var response = await repo.signUp(SignUpRequest(firstName, lastName, email, password, uuid, role));

    response.fold(
      (left) {
        Logger().d('error: ${left.code} ${left.message} ');
        return;
      },
      (right) {

        verifyCode = right;

        repo.checkVerifyCode(email, verifyCode).then(
            (value) {
              value.fold(
                  (left) {
                    Logger().d('error: ${left.code} ${left.message} ');

                    return;
                  },
                  (right) {
                    setSignupState = true;
                  }
              );
            }
        );
      },
    );
  }
}
// sign up -> check verify code ->