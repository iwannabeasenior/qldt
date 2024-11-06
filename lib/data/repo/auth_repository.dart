import 'package:dartz/dartz.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/remote/api_service.dart';
import 'package:qldt/helper/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>>  signUp(String firstName, String lastName, String email, String password, String uuid, String role);
  void singIn();
  void getVerifyCode();
  void checkVerifyCode();
  void changePassword();
  void changeInfoAfterSignUp();
  void getUserInfo();
}

class AuthRepositoryImpl extends AuthRepository {

  final ApiService api;

  AuthRepositoryImpl(this.api);

  @override
  void changeInfoAfterSignUp() {
    // TODO: implement changeInfoAfterSignUp
  }

  @override
  void changePassword() {
    // TODO: implement changePassword
  }

  @override
  void checkVerifyCode() {
    // TODO: implement checkVerifyCode
  }

  @override
  void getUserInfo() {
    // TODO: implement getUserInfo
  }

  @override
  void getVerifyCode() {
    // TODO: implement getVerifyCode
  }

  @override
  Future<Either<Failure, String>> signUp(String firstName, String lastName, String email, String password, String uuid, String role) {
    return api.signUp(firstName, lastName, email, password, uuid, role);
  }

  @override
  void singIn() {
    // TODO: implement singIn
  }

}