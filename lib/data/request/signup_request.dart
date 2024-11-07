import 'package:dartz/dartz.dart';

class SignUpRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String uuid;
  final String role;

  SignUpRequest(this.firstName, this.lastName, this.email, this.password,
      this.uuid, this.role);

  Map<String, dynamic> toJson() => {
    'ho': firstName,
    'ten': lastName,
    'email': email,
    'password': password,
    'uuid': int.parse(uuid),
    'role': role
  };
}

/**
 * Map<String, dynamic> data = {
    "ho": request.firstName,
    "ten": request.lastName,
    "email": request.email,
    "password": request.password,
    "uuid": int.parse(uuid),
    "role": role
    };
 */

