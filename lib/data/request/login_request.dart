class LoginRequest {
  final String email;
  final String password;
  final int deviceId;
  final String? fcmToken;
  LoginRequest(this.email, this.password, this.deviceId, this.fcmToken);
  Map<String, dynamic> toJson() => <String, dynamic>{
    'email': email,
    'password': password,
    'device_id': deviceId,
    'fcm_token': fcmToken
  };
}