import 'package:flutter/material.dart';

class AttendancePageLecturer extends StatefulWidget {
  const AttendancePageLecturer({super.key});

  @override
  State<AttendancePageLecturer> createState() => _AttendancePageLecturerState();
}

class _AttendancePageLecturerState extends State<AttendancePageLecturer> {
  final String _fixedToken = "asHML4";
  final String _fixedClassId = "000100";
  Map<int, String> attendanceDates = {}; // Lưu ngày điểm danh cho từng session


  List<Map<String, dynamic>> students = [
    {"id": "236", "name": "Nguyễn TT"},
    {"id": "237", "name": "Nguyễn ABC"},
  ];

  Map<String, Map<int, String>> attendanceRecords = {};  // Chứa trạng thái điểm danh
  int currentSession = 1; // Bắt đầu với session 1

  // Hàm toggle trạng thái điểm danh
  void toggleAttendance(String studentId, int session, String status) {
    setState(() {
      attendanceRecords.putIfAbsent(studentId, () => {});
      attendanceRecords[studentId]![session] = status;
    });
  }

  // Lưu điểm danh
  Future<void> saveAttendance() async {
    List<String> attendanceList = [];

    attendanceRecords.forEach((studentId, sessions) {
      if (sessions.containsKey(currentSession)) {
        attendanceList.add(studentId);
      }
    });

    if (attendanceList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No students selected for attendance')),
      );
      return;
    }

    // Lưu ngày điểm danh cho session hiện tại
    attendanceDates[currentSession] = DateTime.now().toString().split(' ')[0];

    final attendanceData = {
      "token": _fixedToken,
      "class_id": _fixedClassId,
      "attendance_list": attendanceList,
      "date": attendanceDates[currentSession], // Gửi ngày của session hiện tại
    };

    // Mock API call
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call delay

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendance saved successfully')),
    );

    // Increment session
    setState(() {
      currentSession += 1;  // Tăng session mỗi lần điểm danh
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Class ID: $_fixedClassId',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Đặt scroll ngang
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text('Name')),
                    // Hiển thị session hiện tại cùng với ngày
                    DataColumn(
                      label: Text('Session $currentSession (${attendanceDates[currentSession] ?? "Today"})'),
                    ),
                    // Thêm các cột session cũ
                    for (int i = 1; i < currentSession; i++)
                      DataColumn(
                        label: Text('Session $i (${attendanceDates[i] ?? "Unknown"})'),
                      ),
                  ],
                  rows: students.map((student) {
                    List<DataCell> cells = [
                      DataCell(Text(student["name"])),
                      // Cột trạng thái điểm danh cho session hiện tại
                      DataCell(
                        DropdownButton<String>(
                          value: attendanceRecords[student["id"]]?[currentSession] ?? "PRESENT",
                          items: const [
                            DropdownMenuItem(value: "PRESENT", child: Text('PRESENT')),
                            DropdownMenuItem(value: "EXCUSED_ABSENCE", child: Text('EXCUSED_ABSENCE')),
                            DropdownMenuItem(value: "UNEXCUSED_ABSENCE", child: Text('UNEXCUSED_ABSENCE')),
                          ],
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              toggleAttendance(student["id"], currentSession, newValue);
                            }
                          },
                        ),
                      ),
                    ];

                    // Thêm trạng thái điểm danh của các session cũ
                    for (int i = 1; i < currentSession; i++) {
                      String status = attendanceRecords[student["id"]]?[i] ?? "PRESENT";
                      cells.add(
                        DataCell(
                          Row(
                            children: [
                              Text(status), // Hiển thị trạng thái hiện tại
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Hiển thị dialog để chỉnh sửa
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String? selectedStatus = status;
                                      return AlertDialog(
                                        title: const Text('Edit Attendance Status'),
                                        content: DropdownButton<String>(
                                          value: selectedStatus,
                                          items: const [
                                            DropdownMenuItem(value: "PRESENT", child: Text('PRESENT')),
                                            DropdownMenuItem(value: "EXCUSED_ABSENCE", child: Text('EXCUSED_ABSENCE')),
                                            DropdownMenuItem(value: "UNEXCUSED_ABSENCE", child: Text('UNEXCUSED_ABSENCE')),
                                          ],
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                selectedStatus = newValue;
                                              });
                                            }
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              if (selectedStatus != null) {
                                                toggleAttendance(student["id"], i, selectedStatus!);
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Save'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return DataRow(cells: cells);
                  }).toList(),
                )
                ,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: saveAttendance,
              child: const Text('Save Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}



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
//
//   List<Map<String, dynamic>> students = [
//     {"id": "236", "name": "Nguyễn TT"},
//     {"id": "237", "name": "Nguyễn ABC"},
//   ];
//
//   Map<String, List<int>> attendanceRecords = {};
//   int currentSession = 1; // Bắt đầu với session 1
//
//   void toggleAttendance(String studentId, int session) {
//     setState(() {
//       attendanceRecords.putIfAbsent(studentId, () => []);
//       if (attendanceRecords[studentId]!.contains(session)) {
//         attendanceRecords[studentId]!.remove(session);
//       } else {
//         attendanceRecords[studentId]!.add(session);
//       }
//     });
//   }
//
//   Future<void> saveAttendance() async {
//     List<String> attendanceList = [];
//
//     attendanceRecords.forEach((studentId, sessions) {
//       if (sessions.contains(currentSession)) {
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
//     final attendanceData = {
//       "token": _fixedToken,
//       "class_id": _fixedClassId,
//       "attendance_list": attendanceList,
//     };
//
//     // Mock API call
//     await Future.delayed(const Duration(seconds: 1)); // Simulate API call delay
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Attendance saved successfully')),
//     );
//
//     // Increment session and clear current session selections
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
//                     // Cột session mới sẽ được thêm vào bên trái các session cũ
//                     DataColumn(label: Text('Session $currentSession')),
//                     // Thêm các cột session cũ vào sau
//                     for (int i = 1; i < currentSession; i++)
//                       DataColumn(label: Text('Session $i')),
//                   ],
//                   rows: students.map((student) {
//                     List<DataCell> cells = [
//                       DataCell(Text(student["name"])),
//                       // Cột checkbox cho session hiện tại
//                       DataCell(
//                         Checkbox(
//                           value: attendanceRecords[student["id"]]
//                               ?.contains(currentSession) ??
//                               false,
//                           onChanged: (bool? value) {
//                             toggleAttendance(student["id"], currentSession);
//                           },
//                         ),
//                       ),
//                     ];
//
//                     // Thêm các checkbox cho các session cũ
//                     for (int i = 1; i < currentSession; i++) {
//                       cells.add(
//                         DataCell(
//                           Icon(
//                             attendanceRecords[student["id"]]
//                                 ?.contains(i) ??
//                                 false
//                                 ? Icons.check_box
//                                 : Icons.check_box_outline_blank,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       );
//                     }
//
//                     return DataRow(cells: cells);
//                   }).toList(),
//                 ),
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
//


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
//     final attendanceData = {
//       "token": _fixedToken,
//       "class_id": _fixedClassId,
//       "attendance_list": attendanceList,
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
//                     // Cột session mới sẽ được thêm vào bên trái các session cũ
//                     DataColumn(label: Text('Session $currentSession')),
//                     // Thêm các cột session cũ vào sau
//                     for (int i = 1; i < currentSession; i++)
//                       DataColumn(label: Text('Session $i')),
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
//                     // Thêm các trạng thái điểm danh cho các session cũ
//                     for (int i = 1; i < currentSession; i++) {
//                       String status = attendanceRecords[student["id"]]?[i] ?? "PRESENT";
//                       cells.add(
//                         DataCell(
//                           Text(status),  // Hiển thị trạng thái hiện tại cho các session cũ
//                         ),
//                       );
//                     }
//
//                     return DataRow(cells: cells);
//                   }).toList(),
//                 ),
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
//
