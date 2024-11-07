import 'package:flutter/material.dart';
import 'package:qldt/presentation/theme/color_style.dart';


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
class OpenClassList extends StatefulWidget {
  const OpenClassList({super.key});

  @override
  State<OpenClassList> createState() => _OpenClassListPageState();
}

class _OpenClassListPageState extends State<OpenClassList> {
  final List<ClassModel> classData = [
    ClassModel(
      classCode: "101",
      semester: "2024.1",
      className: "Toán Cơ Bản",
      description: null,
      startDate: DateTime(2024, 01, 10),
      endDate: DateTime(2024, 05, 10),
      maxStudents: 50,
    ),
    ClassModel(
      classCode: "102",
      semester: "2024.1",
      className: "Vật Lý Cơ Bản",
      description: null,
      startDate: DateTime(2024, 01, 12),
      endDate: DateTime(2024, 05, 12),
      maxStudents: 50,
    ),
    ClassModel(
      classCode: "103",
      semester: "2024.1",
      className: "Hóa Học Cơ Bản",
      description: null,
      startDate: DateTime(2024, 01, 15),
      endDate: DateTime(2024, 05, 15),
      maxStudents: 50,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh sách các lớp mở",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: QLDTColor.red,
      ),
      backgroundColor: QLDTColor.white,
      body: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Table(
              border: TableBorder.all(color: Colors.white),
              children: [
                TableRow(
                  children: [
                    _buildHeaderCell('Mã Lớp'),
                    _buildHeaderCell('Tên Lớp'),
                    _buildHeaderCell('Học Kỳ'),
                    _buildHeaderCell('Ngày Bắt Đầu'),
                    _buildHeaderCell('Ngày Kết Thúc'),
                    _buildHeaderCell('Số Sinh Viên Tối Đa'),
                  ],
                ),
                ...classData.map((data) {
                  return TableRow(
                    children: [
                      _buildDataCell(data.classCode),
                      _buildDataCell(data.className),
                      _buildDataCell(data.semester),
                      _buildDataCell("${data.startDate.day}/${data.startDate.month}/${data.startDate.year}"),
                      _buildDataCell("${data.endDate.day}/${data.endDate.month}/${data.endDate.year}"),
                      _buildDataCell(data.maxStudents.toString()),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build header cells
  Widget _buildHeaderCell(String text) {
    return Container(
      color: QLDTColor.red,
      padding: const EdgeInsets.all(8.0),
      height: 100,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Container(
      color: QLDTColor.red,
      padding: const EdgeInsets.all(8.0),
      height: 80,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
