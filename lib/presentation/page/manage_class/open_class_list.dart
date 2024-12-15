// import 'package:flutter/materials.dart';
// import 'package:qldt/presentation/theme/color_style.dart';
//
//

import 'package:flutter/material.dart';


class Class {
  final id;
  final name;
  Class(this.id, this.name);
}

class ClassModel {
  final String classCode;
  final String semester;
  final String className;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final int maxStudents;

  ClassModel({
    required this.classCode,
    required this.semester,
    required this.className,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.maxStudents,
  });
}
// class OpenClassList extends StatefulWidget {
//   const OpenClassList({super.key});
//
//   @override
//   State<OpenClassList> createState() => _OpenClassListPageState();
// }
//
// class _OpenClassListPageState extends State<OpenClassList> {
//   final List<ClassModel> classData = [
//     ClassModel(
//       classCode: "101",
//       semester: "2024.1",
//       className: "Toán Cơ Bản",
//       description: null,
//       startDate: DateTime(2024, 01, 10),
//       endDate: DateTime(2024, 05, 10),
//       maxStudents: 50,
//     ),
//     ClassModel(
//       classCode: "102",
//       semester: "2024.1",
//       className: "Vật Lý Cơ Bản",
//       description: null,
//       startDate: DateTime(2024, 01, 12),
//       endDate: DateTime(2024, 05, 12),
//       maxStudents: 50,
//     ),
//     ClassModel(
//       classCode: "103",
//       semester: "2024.1",
//       className: "Hóa Học Cơ Bản",
//       description: null,
//       startDate: DateTime(2024, 01, 15),
//       endDate: DateTime(2024, 05, 15),
//       maxStudents: 50,
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Danh sách các lớp mở",
//           style: TextStyle(fontSize: 24, color: Colors.white),
//         ),
//         backgroundColor: QLDTColor.red,
//       ),
//       backgroundColor: QLDTColor.white,
//       body: Padding(
//         padding: const EdgeInsets.all(9.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const SizedBox(height: 30),
//             Table(
//               border: TableBorder.all(color: Colors.white),
//               children: [
//                 TableRow(
//                   children: [
//                     _buildHeaderCell('Mã Lớp'),
//                     _buildHeaderCell('Tên Lớp'),
//                     _buildHeaderCell('Học Kỳ'),
//                     _buildHeaderCell('Ngày Bắt Đầu'),
//                     _buildHeaderCell('Ngày Kết Thúc'),
//                     _buildHeaderCell('Số Sinh Viên Tối Đa'),
//                   ],
//                 ),
//                 ...classData.map((data) {
//                   return TableRow(
//                     children: [
//                       _buildDataCell(data.classCode),
//                       _buildDataCell(data.className),
//                       _buildDataCell(data.semester),
//                       _buildDataCell("${data.startDate.day}/${data.startDate.month}/${data.startDate.year}"),
//                       _buildDataCell("${data.endDate.day}/${data.endDate.month}/${data.endDate.year}"),
//                       _buildDataCell(data.maxStudents.toString()),
//                     ],
//                   );
//                 }).toList(),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper method to build header cells
//   Widget _buildHeaderCell(String text) {
//     return Container(
//       color: QLDTColor.red,
//       padding: const EdgeInsets.all(8.0),
//       height: 100,
//       child: Text(
//         text,
//         style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildDataCell(String text) {
//     return Container(
//       color: QLDTColor.red,
//       padding: const EdgeInsets.all(8.0),
//       height: 80,
//       child: Text(
//         text,
//         style: const TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }




class ClassModel1 {
  final String classId;
  final String className;
  final String? attachedCode;
  final String classType;
  final String lecturerName;
  final int studentCount;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  ClassModel1({
    required this.classId,
    required this.className,
    this.attachedCode,
    required this.classType,
    required this.lecturerName,
    required this.studentCount,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory ClassModel1.fromJson(Map<String, dynamic> json) {
    return ClassModel1(
      classId: json['class_id'],
      className: json['class_name'],
      attachedCode: json['attached_code'],
      classType: json['class_type'],
      lecturerName: json['lecturer_name'],
      studentCount: int.parse(json['student_count']),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'],
    );
  }
}

class OpenClassList extends StatefulWidget {
  const OpenClassList({Key? key}) : super(key: key);

  @override
  _OpenClassListState createState() => _OpenClassListState();
}

class _OpenClassListState extends State<OpenClassList> {
  final List<Map<String, dynamic>> rawClassData = [
    {
      "class_id": "023001",
      "class_name": "Bảo vệ bài tập lớn",
      "attached_code": null,
      "class_type": "LT_BT",
      "lecturer_name": "Nguyễn Anh Quân",
      "student_count": "1",
      "start_date": "2024-12-03",
      "end_date": "2024-12-31",
      "status": "ACTIVE",
    },
    {
      "class_id": "016333",
      "class_name": "Bảo vệ BTL",
      "attached_code": null,
      "class_type": "BT",
      "lecturer_name": "Nguyễn Anh Quân",
      "student_count": "0",
      "start_date": "2024-12-03",
      "end_date": "2024-12-31",
      "status": "ACTIVE",
    },
  ];

  late final List<ClassModel1> classData;

  @override
  void initState() {
    super.initState();
    classData = rawClassData.map((json) => ClassModel1.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh sách các lớp mở",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          columnWidths: const {
            0: FlexColumnWidth(1.2), // Class Code
            1: FlexColumnWidth(2),   // Class Name
            2: FlexColumnWidth(1),   // Class Type
            3: FlexColumnWidth(1.8), // Lecturer Name
            4: FlexColumnWidth(0.8), // Student Count
            5: FlexColumnWidth(1.5), // Start Date
            6: FlexColumnWidth(1.5), // End Date
          },
          children: [
            // Table Header
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade300),
              children: [
                _buildHeaderCell("Mã lớp"),
                _buildHeaderCell("Tên lớp"),
                _buildHeaderCell("Kiểu lớp"),
                _buildHeaderCell("Giảng viên"),
                _buildHeaderCell("SL"),
                _buildHeaderCell("Bắt đầu"),
                _buildHeaderCell("Kết thúc"),
              ],
            ),
            // Table Data
            ...classData.map((data) {
              return TableRow(
                children: [
                  _buildDataCell(data.classId),
                  _buildDataCell(data.className),
                  _buildDataCell(data.classType),
                  _buildDataCell(data.lecturerName),
                  _buildDataCell(data.studentCount.toString()),
                  _buildDataCell(_formatDate(data.startDate)),
                  _buildDataCell(_formatDate(data.endDate)),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}


