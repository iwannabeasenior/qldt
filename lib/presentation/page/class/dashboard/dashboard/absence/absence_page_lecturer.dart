import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../data/model/absence_lecturer.dart';
import '../../../../../../data/model/absence_response2.dart';
import '../../../../../../data/repo/absence_repository.dart';
import '../../../../../../data/request/get_student_absence.dart';
import 'absence_provider.dart';

// miss config

class AbsenceLecturerPage extends StatefulWidget {
  final classId;

  const AbsenceLecturerPage({super.key, required this.classId});

  @override
  State<AbsenceLecturerPage> createState() => _AbsenceLecturerPageState();
}

class _AbsenceLecturerPageState extends State<AbsenceLecturerPage> {
  int _currentPage = 0;
  String _selectedStatusFilter = "ALL";
  String? _selectedDateFilter;
  List<AbsenceRequest2> allDates = [];
  String token = UserPreferences.getToken() ?? "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AbsenceProvider>().getAllAbsenceRequests(
            GetStudentAbsence(
              token: token,
              classId: widget.classId,
              status: null,
              // config
              date: null,
              // config
              page: "0",
              pageSize: "5",
            ),
          );
      _loadPage(_currentPage);
    });
  }

  void _loadPage(int page) {
    context.read<AbsenceProvider>().getAllAbsenceRequests(
      GetStudentAbsence(
        token: UserPreferences.getToken() ?? "",
        classId: widget.classId,
        status: null,
        date: null,
        page: page.toString(),
        pageSize: "5",
      ),
      replace: true,
    );
    setState(() {
      _currentPage = page;
    });
  }

  List<AbsenceRequest2> get filteredRequests {
    final absenceProvider = context.read<AbsenceProvider>();
    List<AbsenceRequest2> requests = absenceProvider.absenceRequest2;

    // Filter by status
    if (_selectedStatusFilter != "ALL") {
      requests =
          requests.where((req) => req.status == _selectedStatusFilter).toList();
    }
    // Filter by date
    if (_selectedDateFilter != null) {
      requests = requests
          .where((req) => req.absenceDate == _selectedDateFilter)
          .toList();
    }
    if (allDates.isEmpty) {
      allDates = requests;
    }
    return requests;
  }

  Future<void> openFileUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open file: $url')),
      );
    }
  }

  void _saveData() {
    // Collect status changes
    List<Map<String, dynamic>> changes = [];

    for (var request in filteredRequests) {
      if (request.status != "PENDING") {
        changes.add({
          "status": request.status,
          "id": request.id,
        });
      }
    }

    if (changes.isNotEmpty) {
      // Token for authorization

      // Call `reviewAbsenceRequest` for each change
      for (var change in changes) {
        context.read<AbsenceProvider>().reviewAbsenceRequest(
              token,
              change["id"],
              change["status"],
            );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data has been saved!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes to save!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final _provider = Provider.of<AbsenceProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Absence Requests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedStatusFilter,
                    items: ["ALL", "PENDING", "ACCEPTED", "REJECTED"]
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedStatusFilter = value;
                        });
                      }
                    },
                    hint: const Text("Filter by Status"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedDateFilter ?? "ALL_DATES",
                    items: [
                      const DropdownMenuItem<String>(
                        value: "ALL_DATES",
                        child: Text("Tất cả các ngày"),
                      ),
                      ...allDates
                          .map((req) => req?.absenceDate)
                          .where(
                              (date) => date != null) // Filter out null values
                          .cast<
                              String>() // Ensure the type is String, not String?
                          .toSet()
                          .map(
                            (String date) => DropdownMenuItem<String>(
                              value: date,
                              child: Text(date),
                            ),
                          )
                          .toList(),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDateFilter =
                            newValue == "ALL_DATES" ? null : newValue;
                      });
                    },
                    hint: const Text("Lọc theo ngày"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<AbsenceProvider>(
                builder: (context, provider, _) {
                  final requests = filteredRequests;

                  return Column(
                    children: [
                      // ListView.builder to display absence requests
                      Expanded(
                        child: ListView.builder(
                          itemCount: requests.length,
                          itemBuilder: (context, index) {
                            final request = requests[index];
                            return Card(
                              child: ListTile(
                                  title: Text(
                                      'Student: ${request.studentAccount?.firstName ?? "Unknown"} ${request.studentAccount?.lastName ?? ""}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Date: ${request.absenceDate}'),
                                      Text('Reason: ${request.reason}'),
                                      Text('Title: ${request.title}'),
                                      const SizedBox(height: 5),
                                      request.fileUrl != null
                                          ? Row(
                                              children: [
                                                const Icon(Icons.attach_file,
                                                    size: 16),
                                                Expanded(
                                                  child: Text(
                                                    request.fileUrl!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.blue,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () => openFileUrl(
                                                      request.fileUrl!),
                                                  child: const Text('View'),
                                                ),
                                              ],
                                            )
                                          : const Text(
                                              'No file attached',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                    ],
                                  ),
                                  trailing: DropdownButton<String>(
                                    value: request.status ?? "PENDING",
                                    // Nếu status null, gán mặc định "PENDING"
                                    items: ["PENDING", "ACCEPTED", "REJECTED"]
                                        .map(
                                          (status) => DropdownMenuItem(
                                            value: status,
                                            child: Text(status),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (newValue) {
                                      Logger().d(newValue);
                                      setState(() {
                                        request.status =
                                            newValue; // Đảm bảo cập nhật đúng giá trị status
                                      });
                                    },
                                  )),
                            );
                          },
                        ),
                      ),

                      // Add pagination controls here after the list
                      _buildPagination(provider.pageInfo2),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveData,
                child: const Text('Lưu'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination(PageInfo2 pageInfo) {
    int totalPages = int.parse(pageInfo.totalPage);
    List<int> pageNumbers = _getPageNumbers(totalPages);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 0 ? () => _loadPage(_currentPage - 1) : null,
            icon: const Icon(Icons.arrow_left),
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
            icon: const Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }

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
