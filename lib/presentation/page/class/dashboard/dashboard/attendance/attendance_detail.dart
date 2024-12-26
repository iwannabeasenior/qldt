import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/request/get_attendance_list_request.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';

import '../../../../../../data/model/class_info.dart';
import '../../../../../../data/repo/attendance_repository.dart';
import 'attendance_provider.dart';
// lecturer
class AttendanceDetail extends StatefulWidget {
  final String date;
  final String classId;
  const AttendanceDetail({super.key, required this.date, required this.classId});
  @override
  State<AttendanceDetail> createState() => _AttendanceDetailState();
}

class _AttendanceDetailState extends State<AttendanceDetail> {

  final List<String> statuses = ["PRESENT", "EXCUSED_ABSENCE", "UNEXCUSED_ABSENCE"];
  Map<String, String> previousStatuses = {}; // This will be an empty map initially

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AttendanceProvider>();
      provider.getAttendanceStudentDetail(GetAttendanceListRequest(token: UserPreferences.getToken() ?? "", classId: widget.classId, date: widget.date, pageableRequest: PageableRequest(page: "0", pageSize: "10")));
      provider.fetchStudentAccounts(UserPreferences.getToken() ?? "", "LECTURER", UserPreferences.getId() ?? "", widget.classId);

    });
  }


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>(); // Watch the provider for updates

    final attendanceStudentDetail = provider.attendanceStudentDetail;
    final studentLists = provider.studentLists; // Get student data
    if (previousStatuses.isEmpty) {
      for (var i = 0; i < attendanceStudentDetail.length; i++) {
        final student = attendanceStudentDetail[i];
        // Initialize previousStatuses with the current status if not set
        previousStatuses[student.attendanceId!] = student.status;
      }
    }


    // Update the names in attendanceStudentDetail using studentLists
    for (var i = 0; i < attendanceStudentDetail.length; i++) {
      final student = attendanceStudentDetail[i];
      // Search for the matching studentId in studentLists
      final matchedStudent = studentLists.firstWhere(
              (studentList) => studentList.studentId == student.studentId,
      );
      // Set the name of the student from studentLists
      student.name = '${matchedStudent.firstName} ${matchedStudent.lastName}';
      if (!previousStatuses.containsKey(student.attendanceId)) {
        previousStatuses[student.attendanceId!] = student.status;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          widget.date,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(3),
                },
                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: Colors.grey),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'STT',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'MSSV',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Tên',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Status',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  // Render student data from the provider's list
                  for (int i = 0; i < attendanceStudentDetail.length; i++)
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text((i + 1).toString()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(attendanceStudentDetail[i].studentId),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(attendanceStudentDetail[i].name ?? 'No Name'), // Fallback value
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          value: attendanceStudentDetail[i].status.isEmpty
                              ? null
                              : attendanceStudentDetail[i].status,
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              // attendanceStudentDetail[i].status = newValue!;
                              // If the status has changed, update it
                              // if (previousStatuses[attendanceStudentDetail[i].attendanceId] != newValue) {
                              //   Logger().d('reigh');
                              //   attendanceStudentDetail[i].status = newValue!;                                Logger().d('new ${previousStatuses[attendanceStudentDetail[i].attendanceId]} và ${attendanceStudentDetail[i].attendanceId} ');
                              // }
                              attendanceStudentDetail[i].status = newValue!;
                            });
                          },
                          items: statuses
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: const Text("Select"),
                        ),
                      ),
                    ]),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "PRESENT, EXCUSED_ABSENCE, UNEXCUSED_ABSENCE",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding:
              const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
            ),
            onPressed: () {
    for (var student in attendanceStudentDetail) {
    // Only call setAttendanceStatus if the status has changed
    if (previousStatuses[student.attendanceId] != student.status) {
    provider.setAttendanceStatus(
    token: UserPreferences.getToken() ?? "", // The token (can be dynamic or passed)
    attendanceId: student.attendanceId, // Get the attendanceId
    status: student.status, // Get the status
    );
    }}

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Attendance submitted!")),
              );
            },
            child: const Text("Gửi"),
          ),
        ],
      ),
    );
  }
}
