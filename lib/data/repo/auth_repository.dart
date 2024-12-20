import 'package:dartz/dartz.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/model/user.dart';
import 'package:qldt/data/remote/api_service_it4788.dart';
import 'package:qldt/data/request/login_request.dart';
import 'package:qldt/data/request/signup_request.dart';
import 'package:qldt/helper/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> signUp(SignUpRequest request);
  Future<Either<Failure, ({User user , String token, List<Class> classes})>> login(LoginRequest request);
  Future<Either<Failure, String>> getVerifyCode(String email, String password);
  Future<Either<Failure, String>> checkVerifyCode(String email, String verifyCode);
  Future<Either<Failure, void>> changePassword(String token, String oldPassword, String newPassword);
  Future<Either<Failure, void>> changeInfoAfterSignUp();
  Future<User> getUserInfo(String token, String userId);
}

class AuthRepositoryImpl extends AuthRepository {

  final ApiServiceIT4788 api;

  AuthRepositoryImpl(this.api);

  @override
  Future<Either<Failure, String>> signUp(SignUpRequest request) {
    return api.signUp(request);
  }

  @override
  Future<Either<Failure, ({User user , String token, List<Class> classes})>> login(LoginRequest request) {
    return api.login(request);
  }

  @override
  Future<Either<Failure, void>> changeInfoAfterSignUp() {
    return api.changeInfoAfterSignUp();
  }

  @override
  Future<Either<Failure, void>> changePassword(String token, String oldPassword, String newPassword) {
    return api.changePassword(token, oldPassword, newPassword);
  }

  @override
  Future<Either<Failure, String>> checkVerifyCode(String email, String verifyCode) {
    return api.checkVerifyCode(email, verifyCode);
  }

  @override
  Future<User> getUserInfo(String token, String userId) {
    return api.getUserInfo(token, userId);
  }

  @override
  Future<Either<Failure, String>> getVerifyCode(String email, String password) {
    return api.getVerifyCode(email, password);
  }


}