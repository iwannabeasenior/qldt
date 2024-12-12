import 'package:flutter/material.dart';
import 'package:qldt/presentation/page/class/homework/lecturer/assignment_list.dart';
import 'package:qldt/presentation/page/class/homework/student/student_assignments_page.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:qldt/helper/enum.dart'; // Đừng quên import Role nếu cần

class HomeworkPage extends StatefulWidget {
  const HomeworkPage({super.key});

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    String? role = await UserPreferences.getRole();
    setState(() {
      _role = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_role == null) {
      // Hiển thị khi chưa tải xong vai trò
      return const Center(child: CircularProgressIndicator());
    }

    // Hiển thị nội dung dựa trên vai trò
    return Scaffold(
      body: Center(
        child: _role == 'STUDENT'
            ? const StudentAssignmentsPage()
            : const AssignmentList(),
      ),
    );
  }
}
