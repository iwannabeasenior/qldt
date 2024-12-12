



import 'package:qldt/helper/enum.dart';

class User {
  String? id;
  String? status;
  String? name;
  String? role;
  String? firstName;
  String? lastName;
  String? avatar;
  String? email;
  User({required this.id, required this.status, required this.name, required this.role,
    required this.firstName, required this.lastName, required this.avatar, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['ho'],
      lastName: json['ten'],
      avatar: json['avatar'],
      role: json['role'],
      status: json['status'],
      name: json['name'],
      email: json['email']
    );
  }
}
