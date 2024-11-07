class LoginRequest {
  final String email;
  final String password;
  final int deviceId;
  LoginRequest(this.email, this.password, this.deviceId);
  Map<String, dynamic> toJson() => <String, dynamic>{
    'email': email,
    'password': password,
    'deviceId': deviceId
  };
}