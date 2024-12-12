import 'package:flutter/material.dart';

import 'attendance_detail.dart';

class ViewAttendanceHistoryLecturer extends StatefulWidget {
  const ViewAttendanceHistoryLecturer({super.key});

  @override
  State<ViewAttendanceHistoryLecturer> createState() =>
      _ViewAttendanceHistoryLecturerState();
}

class _ViewAttendanceHistoryLecturerState
    extends State<ViewAttendanceHistoryLecturer> {
  final List<Map<String, dynamic>> attendanceHistory = [
    {"date": "2024-11-13", "action": "Xem"},
    {"date": "2024-11-28", "action": "Xem"},
  ];

  @override
  Widget build(BuildContext context) {
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
                for (var record in attendanceHistory)
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(record["date"]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AttendanceDetailScreen(date: record["date"]),
                            ),
                          );
                        },

                        child: Text(
                          record["action"],
                          style: const TextStyle(
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
