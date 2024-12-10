import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewAbsencePageStudent extends StatefulWidget {
  const ViewAbsencePageStudent({super.key});

  @override
  State<ViewAbsencePageStudent> createState() => _ViewAbsencePageStudentState();
}

class _ViewAbsencePageStudentState extends State<ViewAbsencePageStudent> {
  List<Map<String, dynamic>> _absenceRequests = [
    {
      "id": "163",
      "student_account": {
        "account_id": "236",
        "last_name": "TT",
        "first_name": "Nguyễn",
        "email": "studenthust1@hust.edu.vn",
        "student_id": "117",
      },
      "absence_date": "2024-11-28",
      "title": "Nghi Hoc",
      "reason": "xin phép nghỉ học",
      "status": "ACCEPTED",
      "file_url":
      "https://drive.google.com/file/d/1isJqhNg2oG6ZNWdkv5gTiv33_OtQZJq3/view?usp=drivesdk",
      "class_id": "000100"
    },
    {
      "id": "116",
      "student_account": {
        "account_id": "236",
        "last_name": "TT",
        "first_name": "Nguyễn",
        "email": "studenthust1@hust.edu.vn",
        "student_id": "117",
      },
      "absence_date": "2024-11-11",
      "title": "Nghi Hoc",
      "reason": "xin phép nghỉ học",
      "status": "PENDING",
      "class_id": "000100"
    },
    {
      "id": "120",
      "student_account": {
        "account_id": "237",
        "last_name": "LT",
        "first_name": "Phạm",
        "email": "studenthust2@hust.edu.vn",
        "student_id": "118",
      },
      "absence_date": "2024-11-05",
      "title": "Nghi Om",
      "reason": "Nghỉ ốm dài ngày",
      "status": "REJECTED",
      "class_id": "000101"
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Absence Requests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _absenceRequests.length,
          itemBuilder: (context, index) {
            final request = _absenceRequests[index];
            final studentAccount = request["student_account"];
            final studentName =
                '${studentAccount["first_name"] ?? "Unknown"} ${studentAccount["last_name"] ?? ""}';

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
                    Text('Class ID: ${request["class_id"]}'),
                    Text('Date: ${request["absence_date"]}'),
                    Text('Reason: ${request["reason"]}'),
                    Text('Title: ${request["title"]}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Status: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        _buildStatusChip(request["status"]),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (request["file_url"] != null)
                      Row(
                        children: [
                          const Icon(Icons.attach_file, size: 16),
                          Expanded(
                            child: Text(
                              request["file_url"],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                openFileUrl(request["file_url"]),
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
    );
  }
}