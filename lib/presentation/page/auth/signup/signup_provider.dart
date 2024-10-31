import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/repo/auth_repository.dart';

class SignUpProvider extends ChangeNotifier {
  AuthRepository repo;

  SignUpProvider(this.repo);

  String verifyCode = "";

  void requestSignUp(String firstName, String lastName, String email, String password, String uuid, String role) async {

    var response = await repo.signUp(firstName, lastName, email, password, uuid, role);

    response.fold(
      (left) {
        Logger().d("error is: " + left.code.toString() + left.message);
      },
      (right) {
        verifyCode = right;
        Logger().d("verify code is: $verifyCode");
      },
    );
  }
}