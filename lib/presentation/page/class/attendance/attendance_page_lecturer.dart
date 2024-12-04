// import 'package:flutter/material.dart';
//
// class AttendancePageLecturer extends StatefulWidget {
//   const AttendancePageLecturer({super.key});
//
//   @override
//   State<AttendancePageLecturer> createState() => _AttendancePageLecturerState();
// }
//
// class _AttendancePageLecturerState extends State<AttendancePageLecturer> {
//   final String _fixedToken = "asHML4";
//   final String _fixedClassId = "000100";
//   Map<int, String> attendanceDates = {}; // Lưu ngày điểm danh cho từng session
//
//
//   List<Map<String, dynamic>> students = [
//     {"id": "236", "name": "Nguyễn TT"},
//     {"id": "237", "name": "Nguyễn ABC"},
//   ];
//
//   Map<String, Map<int, String>> attendanceRecords = {};  // Chứa trạng thái điểm danh
//   int currentSession = 1; // Bắt đầu với session 1
//
//   // Hàm toggle trạng thái điểm danh
//   void toggleAttendance(String studentId, int session, String status) {
//     setState(() {
//       attendanceRecords.putIfAbsent(studentId, () => {});
//       attendanceRecords[studentId]![session] = status;
//     });
//   }
//
//   // Lưu điểm danh
//   Future<void> saveAttendance() async {
//     List<String> attendanceList = [];
//
//     attendanceRecords.forEach((studentId, sessions) {
//       if (sessions.containsKey(currentSession)) {
//         attendanceList.add(studentId);
//       }
//     });
//
//     if (attendanceList.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No students selected for attendance')),
//       );
//       return;
//     }
//
//     // Lưu ngày điểm danh cho session hiện tại
//     attendanceDates[currentSession] = DateTime.now().toString().split(' ')[0];
//
//     final attendanceData = {
//       "token": _fixedToken,
//       "class_id": _fixedClassId,
//       "attendance_list": attendanceList,
//       "date": attendanceDates[currentSession], // Gửi ngày của session hiện tại
//     };
//
//     // Mock API call
//     await Future.delayed(const Duration(seconds: 1)); // Simulate API call delay
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Attendance saved successfully')),
//     );
//
//     // Increment session
//     setState(() {
//       currentSession += 1;  // Tăng session mỗi lần điểm danh
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance Management'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Class ID: $_fixedClassId',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal, // Đặt scroll ngang
//                 child: DataTable(
//                   columns: [
//                     const DataColumn(label: Text('Name')),
//                     // Hiển thị session hiện tại cùng với ngày
//                     DataColumn(
//                       label: Text('Session $currentSession (${attendanceDates[currentSession] ?? "Today"})'),
//                     ),
//                     // Thêm các cột session cũ
//                     for (int i = 1; i < currentSession; i++)
//                       DataColumn(
//                         label: Text('Session $i (${attendanceDates[i] ?? "Unknown"})'),
//                       ),
//                   ],
//                   rows: students.map((student) {
//                     List<DataCell> cells = [
//                       DataCell(Text(student["name"])),
//                       // Cột trạng thái điểm danh cho session hiện tại
//                       DataCell(
//                         DropdownButton<String>(
//                           value: attendanceRecords[student["id"]]?[currentSession] ?? "PRESENT",
//                           items: const [
//                             DropdownMenuItem(value: "PRESENT", child: Text('PRESENT')),
//                             DropdownMenuItem(value: "EXCUSED_ABSENCE", child: Text('EXCUSED_ABSENCE')),
//                             DropdownMenuItem(value: "UNEXCUSED_ABSENCE", child: Text('UNEXCUSED_ABSENCE')),
//                           ],
//                           onChanged: (String? newValue) {
//                             if (newValue != null) {
//                               toggleAttendance(student["id"], currentSession, newValue);
//                             }
//                           },
//                         ),
//                       ),
//                     ];
//
//                     // Thêm trạng thái điểm danh của các session cũ
//                     for (int i = 1; i < currentSession; i++) {
//                       String status = attendanceRecords[student["id"]]?[i] ?? "PRESENT";
//                       cells.add(
//                         DataCell(
//                           Row(
//                             children: [
//                               Text(status), // Hiển thị trạng thái hiện tại
//                               IconButton(
//                                 icon: const Icon(Icons.edit),
//                                 onPressed: () {
//                                   // Hiển thị dialog để chỉnh sửa
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       String? selectedStatus = status;
//                                       return AlertDialog(
//                                         title: const Text('Edit Attendance Status'),
//                                         content: DropdownButton<String>(
//                                           value: selectedStatus,
//                                           items: const [
//                                             DropdownMenuItem(value: "PRESENT", child: Text('PRESENT')),
//                                             DropdownMenuItem(value: "EXCUSED_ABSENCE", child: Text('EXCUSED_ABSENCE')),
//                                             DropdownMenuItem(value: "UNEXCUSED_ABSENCE", child: Text('UNEXCUSED_ABSENCE')),
//                                           ],
//                                           onChanged: (String? newValue) {
//                                             if (newValue != null) {
//                                               setState(() {
//                                                 selectedStatus = newValue;
//                                               });
//                                             }
//                                           },
//                                         ),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () {
//                                               if (selectedStatus != null) {
//                                                 toggleAttendance(student["id"], i, selectedStatus!);
//                                               }
//                                               Navigator.of(context).pop();
//                                             },
//                                             child: const Text('Save'),
//                                           ),
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.of(context).pop();
//                                             },
//                                             child: const Text('Cancel'),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }
//
//                     return DataRow(cells: cells);
//                   }).toList(),
//                 )
//                 ,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: saveAttendance,
//               child: const Text('Save Attendance'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AttendancePageLecturer extends StatefulWidget {
  const AttendancePageLecturer({super.key});

  @override
  State<AttendancePageLecturer> createState() => _AttendancePageLecturerState();
}

class _AttendancePageLecturerState extends State<AttendancePageLecturer> {
  final String _fixedToken = "asHML4";
  final String _fixedClassId = "000100";

  List<Map<String, dynamic>> students = [
    {"id": "20215345", "name": "Nguyễn Trung Thành"},
    {"id": "20215489", "name": "Phạm Quốc Đạt"},
    {"id": "20214234", "name": "Nguyễn Huy Hoàng"},

  ];

  Map<String, bool> attendanceRecords = {};

  void toggleAttendance(String studentId) {
    setState(() {
      attendanceRecords[studentId] = !(attendanceRecords[studentId] ?? false);
    });
  }

  Future<void> saveAttendance() async {
    List<String> attendanceList = [];

    attendanceRecords.forEach((studentId, isPresent) {
      if (isPresent) {
        attendanceList.add(studentId);
      }
    });

    if (attendanceList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No students selected for attendance')),
      );
      return;
    }

    final attendanceData = {
      "token": _fixedToken,
      "class_id": _fixedClassId,
      "attendance_list": attendanceList,
    };

    Logger().d('data: $attendanceData');

    // Mock API call
    await Future.delayed(const Duration(seconds: 1));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendance sent successfully')),
    );

    // Clear attendance records after saving
    setState(() {
      attendanceRecords.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          '12/12/1212 (Hôm nay)',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20.0,
                  columns: const [
                    DataColumn(label: Text('STT', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('MSSV', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Họ tên', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Có mặt', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: List<DataRow>.generate(
                    students.length,
                        (index) {
                      final student = students[index];
                      return DataRow(cells: [
                        DataCell(Text('${index + 1}')), // STT
                        DataCell(Text(student["id"])), // MSSV
                        DataCell(Text(student["name"])), // Họ tên
                        DataCell(
                          Checkbox(
                            value: attendanceRecords[student["id"]] ?? false,
                            onChanged: (bool? value) {
                              toggleAttendance(student["id"]);
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
              child: const Text('Gửi', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
