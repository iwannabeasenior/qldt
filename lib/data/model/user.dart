


enum Role {
  STUDENT,
  LECTURER,
}

class User {
  int? id;
  String? active;
  String? username;
  Role? role;
  String? firstName;
  String? lastName;
  String? avatar;

  User({required this.id, required this.active, required this.username, required this.role,
    required this.firstName, required this.lastName, required this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['ho'],
      lastName: json['ten'],
      avatar: json['avatar'],
      role: json['role'] == 'STUDENT' ? Role.STUDENT : Role.LECTURER,
      active: json['active'],
      username: json['username']
    );
  }
}

/**
 *
 *
 *
 * {
    "id": 72,
    "ho": "Nguyễn",
    "ten": "Anh Quân",
    "username": "sv0@hust.edu.vn",
    "token": "T1NOcF",
    "active": "Kích hoạt",
    "role": "STUDENT",
    "class_list": [
      {
        "class_id": "000002",
        "class_name": "Test Attendance",
        "lecturer_name": "gv2@hust.edu.vn",
        "student_count": 20,
        "start_date": "2024-10-10",
        "end_date": "2024-11-30",
        "status": "ACTIVE"
      }
    ],
    "avatar": null
    }
 */