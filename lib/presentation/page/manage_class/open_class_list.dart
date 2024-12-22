import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repo/manage_class_repository.dart';
import '../../theme/color_style.dart';
import 'manage_class_provider.dart';

class ClassModel1 {
  final String classId;
  final String className;
  final String? attachedCode;
  final String classType;
  final String lecturerName;
  final String studentCount;
  final String startDate;
  final String endDate;
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
      studentCount: json['student_count'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
    );
  }
}

class OpenClassList extends StatelessWidget {
  const OpenClassList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ManageClassRepo>();
    return ChangeNotifierProvider(
      create: (context) => ManageClassProvider(repo),
      child: OpenClassListView(),
    );
  }
}

class OpenClassListView extends StatefulWidget {
  const OpenClassListView({super.key});

  @override
  State<OpenClassListView> createState() => _OpenClassListViewState();
}


class _OpenClassListViewState extends State<OpenClassListView> {
  late final ManageClassProvider _provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = context.read<ManageClassProvider>();
      _provider.getOpenClassList("0v80WG", "0", "10");  // Adjust as necessary
    });
  }

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ManageClassProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              // Show loading spinner while fetching data
              return Center(child: CircularProgressIndicator());
            }

            if (provider.openClassList.isEmpty) {
              // Show message if there are no classes available
              return Center(child: Text("Không có lớp mở nào"));
            }

             return SingleChildScrollView(  // Cho phép cuộn
                scrollDirection: Axis.vertical,  // Cuộn theo chiều dọc
                child:Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FlexColumnWidth(1.2), // Class Code
                1: FlexColumnWidth(2),   // Class Name
                2: FlexColumnWidth(1),   // Class Name
                3: FlexColumnWidth(1),   // Class Type
                4: FlexColumnWidth(1.8), // Lecturer Name
                5: FlexColumnWidth(1.5), // Student Count
                6: FlexColumnWidth(1.5), // Start Date
                7: FlexColumnWidth(1.5), // End Date
              },
              children: [
                // Table Header
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  children: [
                    _buildHeaderCell("Mã lớp"),
                    _buildHeaderCell("Tên lớp"),
                    _buildHeaderCell("Mã lớp đính kèm"),
                    _buildHeaderCell("Kiểu lớp"),
                    _buildHeaderCell("Giảng viên"),
                    _buildHeaderCell("Số lượng"),
                    _buildHeaderCell("Bắt đầu"),
                    _buildHeaderCell("Kết thúc"),
                  ],
                ),
                // Table Data
                ...provider.openClassList.map((data) {
                  return TableRow(
                    children: [
                      _buildDataCell(data.classId),
                      _buildDataCell(data.className),
                      _buildDataCell(data.attachedCode ?? "không"),

                      _buildDataCell(data.classType),
                      _buildDataCell(data.lecturerName),
                      _buildDataCell(data.studentCount),
                      _buildDataCell(data.startDate),
                      _buildDataCell(data.endDate),
                    ],
                  );
                }).toList(),
              ],
            ));
          },
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
}


