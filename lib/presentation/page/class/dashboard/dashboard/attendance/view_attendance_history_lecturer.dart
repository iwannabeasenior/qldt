import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';

import '../../../../../../data/repo/attendance_repository.dart';
import 'attendance_detail.dart';
import 'attendance_provider.dart';
//lecturer
class AttendanceHistoryLecturer extends StatefulWidget {
  final classId;
  const AttendanceHistoryLecturer({super.key, required this.classId});
  @override
  State<AttendanceHistoryLecturer> createState() => _AttendanceHistoryLecturerState();
}


class _AttendanceHistoryLecturerState
    extends State<AttendanceHistoryLecturer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AttendanceProvider>();
      provider.fetchAttendanceDates(UserPreferences.getToken() ?? "", widget.classId);  // Adjust as necessary
    });
  }


  @override
  Widget build(BuildContext context) {

    final provider = context.watch<AttendanceProvider>(); // Watch for changes in the provider
    final absenceDates = provider.absenceDates;  // Get the absence dates from the provider
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          'Lịch sử điểm danh',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Table 1',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (absenceDates.isEmpty) // If no attendance dates, show loading or empty state
              Center(child: CircularProgressIndicator()),
            if (absenceDates.isNotEmpty) // Show the list of attendance dates
              Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                },
                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: Colors.grey),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Ngày',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Action',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  // Render attendance dates dynamically from provider's absenceDates list
                  for (var date in absenceDates)
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(date),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the attendance details page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AttendanceDetail(date: date, classId: widget.classId),
                              ),
                            );
                          },
                          child: const Text(
                            "Xem",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ]),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
