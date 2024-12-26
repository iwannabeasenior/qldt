import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';

import '../../../data/model/open_class_response.dart';
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


class OpenClassList extends StatefulWidget {
  const OpenClassList({super.key});

  @override
  State<OpenClassList> createState() => _OpenClassListState();
}


class _OpenClassListState extends State<OpenClassList> {
  late final ManageClassProvider _provider;
  int _currentPage = 0;
  int _pageSize = 10;  // Default page size

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = context.read<ManageClassProvider>();
      _provider.getOpenClassList(UserPreferences.getToken() ?? "", "0", "10");  // Adjust as necessary
      _loadPage(_currentPage);  // Load the first page initially
    });
  }

  // Function to load data for a specific page
  void _loadPage(int page) {
    _provider.getOpenClassList(UserPreferences.getToken() ?? "", page.toString(), _pageSize.toString(), replace: true);  // Pass `replace: true`
    setState(() {
      _currentPage = page;
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
              return Center(child: CircularProgressIndicator());
            }

            if (provider.openClassList.isEmpty) {
              return Center(child: Text("Không có lớp mở nào"));
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      border: TableBorder.all(color: Colors.grey.shade300),
                      columnWidths: const {
                        0: FlexColumnWidth(1.2),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1.8),
                        4: FlexColumnWidth(1),
                        5: FlexColumnWidth(1.5),
                        6: FlexColumnWidth(1.5),
                        7: FlexColumnWidth(1.5),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey.shade300),
                          children: [
                            _buildHeaderCell("Mã lớp"),
                            _buildHeaderCell("Tên lớp"),
                            // _buildHeaderCell("Mã lớp đính kèm"),
                            _buildHeaderCell("Kiểu lớp"),
                            _buildHeaderCell("Giảng viên"),
                            _buildHeaderCell("Số lượng"),
                            _buildHeaderCell("Bắt đầu"),
                            _buildHeaderCell("Kết thúc"),
                          ],
                        ),
                        ...provider.openClassList.map((data) {
                          return TableRow(
                            children: [
                              _buildDataCell(data.classId),
                              _buildDataCell(data.className),
                              // _buildDataCell(data.attachedCode ?? "không"),
                              _buildDataCell(data.classType),
                              _buildDataCell(data.lecturerName),
                              _buildDataCell(data.studentCount),
                              _buildDataCell(data.startDate),
                              _buildDataCell(data.endDate),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                _buildPagination(provider.pageInfo1),
              ],
            );
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

  // Widget to build the pagination controls
  Widget _buildPagination(PageInfo1 pageInfo) {
    int totalPages = int.parse(pageInfo.totalPage);
    List<int> pageNumbers = _getPageNumbers(totalPages);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 0
                ? () => _loadPage(_currentPage - 1)
                : null,
            icon: Icon(Icons.arrow_left),
          ),
          for (int i = 0; i < pageNumbers.length; i++)
            GestureDetector(
              onTap: () => _loadPage(pageNumbers[i]),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: pageNumbers[i] == _currentPage
                      ? Colors.blue
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  (pageNumbers[i] + 1).toString(),
                  style: TextStyle(
                    color: pageNumbers[i] == _currentPage
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          IconButton(
            onPressed: _currentPage < totalPages - 1
                ? () => _loadPage(_currentPage + 1)
                : null,
            icon: Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }

  // Calculate the pages to display (3 pages at a time)
  List<int> _getPageNumbers(int totalPages) {
    List<int> pageNumbers = [];
    int startPage = _currentPage - 1 < 0 ? 0 : _currentPage - 1;
    int endPage = _currentPage + 1 >= totalPages ? totalPages - 1 : _currentPage + 1;

    for (int i = startPage; i <= endPage; i++) {
      pageNumbers.add(i);
    }
    return pageNumbers;
  }
}