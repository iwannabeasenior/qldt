



import 'package:qldt/helper/enum.dart';

class User {
  int? id;
  String? status;
  String? username;
  Role? role;
  String? firstName;
  String? lastName;
  String? avatar;

  User({required this.id, required this.status, required this.username, required this.role,
    required this.firstName, required this.lastName, required this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['ho'],
      lastName: json['ten'],
      avatar: json['avatar'],
      role: json['role'] == 'STUDENT' ? Role.STUDENT : Role.LECTURER,
      status: json['status'],
      username: json['user_name']
    );
  }
}
