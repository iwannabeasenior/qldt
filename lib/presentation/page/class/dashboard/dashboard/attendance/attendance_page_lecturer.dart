
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../../../data/repo/attendance_repository.dart';
import 'attendance_provider.dart';

class AttendancePageLecturer extends StatelessWidget {
  const AttendancePageLecturer({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AttendanceRepo>();  // Reading the AttendanceRepo

    return ChangeNotifierProvider(
      create: (context) => AttendanceProvider(repo),
      child: const AttendancePageLecturerView(),  // Passing the AttendancePageView widget
    );
  }


}

class AttendancePageLecturerView  extends StatefulWidget {
  const AttendancePageLecturerView ({super.key});

  @override
  State<AttendancePageLecturerView > createState() => _AttendancePageLecturerViewState();
}

class _AttendancePageLecturerViewState extends State<AttendancePageLecturerView> {
  Map<String, bool> attendanceRecords = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch the student accounts when the page is loaded
      context.read<AttendanceProvider>().fetchStudentAccounts(
        "wVIo5R", "LECTURER", "237", "000100",
      );
    });
  }


  String getCurrentDate() {
    // Get current date and format it as "yyyy-MM-dd"
    DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  void toggleAttendance(String studentId) {
    setState(() {
      Logger().d('đảo ${studentId}');
      // Đảo ngược trạng thái có mặt (true) thành vắng mặt (false) và ngược lại
      attendanceRecords[studentId] = !(attendanceRecords[studentId] ?? false);
      Logger().d('trạng thái ${studentId} là ${attendanceRecords[studentId]}');

    });
  }



  Future<void> saveAttendance() async {
    List<String> attendanceList = [];

    bool anyChecked = false;

    // Collect student IDs who are absent (unchecked)
    attendanceRecords.forEach((studentId, isPresent) {
      if (isPresent == false || isPresent == null) {
        // If the student is absent (checkbox unchecked), add them to the attendance list
        attendanceList.add(studentId);
        Logger().d('list ${studentId}');

      }
      if (isPresent) {
        anyChecked = true; // At least one student is marked as present
      }
      // Logger().d('is ${isPresent}');
    });


    // If no checkboxes are selected, show a message and exit
    if (!anyChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No students selected for attendance')),
      );
      return;
    }

    // Prepare the data to pass to the provider's takeAttendance method
    final token = "wVIo5R";
    final classId = "000100";
    final date = getCurrentDate(); // Use current date as the attendance date

    try {
      // Call the takeAttendance method from the provider
      await context.read<AttendanceProvider>().takeAttendance(
        token: token,
        classId: classId,
        date: "2024-11-30",
        attendanceList: attendanceList,
      );

      // Show success message after successful attendance submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance sent successfully')),
      );

      // Clear attendance records after saving
      setState(() {
        attendanceRecords.clear();
      });
    } catch (e) {
      // Show error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>(); // Watching the provider
    final students = provider.studentLists;

    if (attendanceRecords.isEmpty && students.isNotEmpty) {
      for (var student in students) {
        attendanceRecords[student.studentId] = false; // Mặc định là false (vắng mặt)
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          '${getCurrentDate()} (Hôm nay)',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20.0,
                  columns: const [
                    DataColumn(
                        label:
                        Text('STT', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label:
                        Text('MSSV', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label:
                        Text('Họ tên', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label:
                        Text('Có mặt', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: List<DataRow>.generate(
                    students.length,
                        (index) {
                      final student = students[index];
                      return DataRow(cells: [
                        DataCell(Text('${index + 1}')), // STT
                        DataCell(Text(student.studentId)), // MSSV
                        DataCell(Text(
                            student.firstName + " " + student.lastName)), // Họ tên
                        DataCell(
                          Checkbox(
                            value: attendanceRecords[student.studentId] ?? false,
                            onChanged: (bool? value) {
                              toggleAttendance(student.studentId);
                            },
                          ),
                        ), // Có mặt
                      ]);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: saveAttendance,
              child: const Text(
                'Gửi',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

