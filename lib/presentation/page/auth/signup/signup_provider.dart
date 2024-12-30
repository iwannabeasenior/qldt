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

  // void requestSignUp(String firstName, String lastName, String email, String password, String uuid, String role) async {
  //
  //   var response = await repo.signUp(SignUpRequest(firstName, lastName, email, password, uuid, role));
  //
  //   response.fold(
  //     (left) {
  //       Logger().d('error: ${left.code} ${left.message} ');
  //       return;
  //     },
  //     (right) {
  //
  //       verifyCode = right;
  //
  //       repo.checkVerifyCode(email, verifyCode).then(
  //           (value) {
  //             value.fold(
  //                 (left) {
  //                   Logger().d('error: ${left.code} ${left.message} ');
  //                   return;
  //                 },
  //                 (right) {
  //                   setSignupState = true;
  //                 }
  //             );
  //           }
  //       );
  //     },
  //   );
  // }

  Future<bool> requestSignUp(String firstName, String lastName, String email, String password, String uuid, String role) async {
    try {
      // Step 1: Call the signUp method and handle the response
      var response = await repo.signUp(SignUpRequest(firstName, lastName, email, password, uuid, role));

      // Step 2: Handle the response using fold
      return await response.fold(
            (left) {
          // Handle error in sign-up process
          Logger().d('error: ${left.code} ${left.message}');
          return Future.value(false); // Return false if sign-up fails
        },
            (right) async {
          // Step 3: If sign-up is successful, proceed to verify the code
          verifyCode = right;

          // Step 4: Call checkVerifyCode and handle the result
          var verificationResponse = await repo.checkVerifyCode(email, verifyCode);

          // Step 5: Handle the verification response
          return await verificationResponse.fold(
                (left) {
              // Handle error in verification
              Logger().d('error: ${left.code} ${left.message}');
              return Future.value(false); // Return false if verification fails
            },
                (right) {
              // Set the state and return success
              setSignupState = true;
              return Future.value(true); // Return true if verification succeeds
            },
          );
        },
      );
    } catch (e) {
      // Handle any unexpected errors (e.g., network errors)
      Logger().d('Unexpected error: $e');
      return Future.value(false);
    }
  }

}
// sign up -> check verify code ->