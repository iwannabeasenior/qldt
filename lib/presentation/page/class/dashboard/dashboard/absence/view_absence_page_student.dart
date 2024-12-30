

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/model/absence_response.dart';
import 'package:qldt/data/model/absence_student.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../data/repo/absence_repository.dart';
import '../../../../../../data/request/get_student_absence.dart';
import 'absence_provider.dart';



class AbsencePageStudent extends StatefulWidget {
  final classId;
  const AbsencePageStudent({super.key, this.classId});

  @override
  State<AbsencePageStudent> createState() => _AbsencePageStudentState();
}
  void openFileUrl(String fileUrl) async {
    if (await canLaunch(fileUrl)) {
      await launch(fileUrl);
    } else {
      throw 'Could not launch $fileUrl';
    }
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;
    switch (status) {
      case "ACCEPTED":
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case "PENDING":
        color = Colors.orange;
        icon = Icons.hourglass_empty;
        break;
      case "REJECTED":
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
    }
    return Chip(
      backgroundColor: color.withOpacity(0.1),
      avatar: Icon(icon, color: color),
      label: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }



class _AbsencePageStudentState extends State<AbsencePageStudent> {

  late final AbsenceProvider _provider;
  int _currentPage = 0;
  List<AbsenceRequest1> _absenceRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = context.read<AbsenceProvider>();
      _provider.getStudentAbsenceRequests(
          GetStudentAbsence(
            token: UserPreferences.getToken() ?? "",
            classId: widget.classId,
            status: null,
            date: null,
            page: "0",
            pageSize: "10",
          ) );
      _loadPage(_currentPage);
// Adjust as necessary
      // Fetch the absence requests

    });
  }

  void _loadPage(int page) {
    _provider.getStudentAbsenceRequests(
        GetStudentAbsence(
          token: UserPreferences.getToken() ?? "",
          classId: widget.classId,
          status: null,
          date: null,
          page: "0",
          pageSize: "10",
        ), replace: true );
    setState(() {
      _currentPage = page;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Absence Requests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AbsenceProvider>(
          builder: (context, absenceProvider, child) {
            // Check if data is loaded
            if (absenceProvider.isLoading && _absenceRequests.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            // Update the local state with the fetched data
            _absenceRequests = absenceProvider.absenceResponse.absenceRequests;

            return RefreshIndicator(
              onRefresh: _refreshAbsenceRequests,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _absenceRequests.length,
                      itemBuilder: (context, index) {
                        final request = _absenceRequests[index];
                        final studentAccount = request.studentAccount;
                        final studentName =
                            '${studentAccount.firstName} ${studentAccount.lastName}';

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Student: $studentName',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Class ID: ${request.classId}'),
                                Text('Date: ${request.absenceDate}'),
                                Text('Reason: ${request.reason}'),
                                Text('Title: ${request.title}'),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      'Status: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    _buildStatusChip(request.status),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (request.fileUrl != null)
                                  Row(
                                    children: [
                                      const Icon(Icons.attach_file, size: 16),
                                      Expanded(
                                        child: Text(
                                          request.fileUrl!,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => openFileUrl(request.fileUrl!),
                                        child: const Text('View'),
                                      ),
                                    ],
                                  )
                                else
                                  const Text(
                                    'No file attached',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildPagination(absenceProvider.pageInfo),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

// Refresh function
  Future<void> _refreshAbsenceRequests() async {
    await _provider.getStudentAbsenceRequests(
      GetStudentAbsence(
        token: UserPreferences.getToken() ?? "",
        classId: widget.classId,
        status: null,
        date: null,
        page: "0",
        pageSize: "10",
      ),
      replace: true,
    );
    setState(() {});
  }


  Widget _buildPagination(PageInfo pageInfo) {
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
