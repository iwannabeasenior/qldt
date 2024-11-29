import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AbsenceLecturerPage extends StatefulWidget {
  const AbsenceLecturerPage({super.key});

  @override
  State<AbsenceLecturerPage> createState() => _AbsenceLecturerPageState();
}

class _AbsenceLecturerPageState extends State<AbsenceLecturerPage> {
  // Cố định lớp ID
  final String _fixedClassId = "000111";

  // Dữ liệu yêu cầu vắng mặt
  final Map<String, List<Map<String, dynamic>>> _absenceRequests = {
    "000111": [
      {
        "date": "2024-11-10",
        "reason": "Bị ốm",
        "status": "PENDING",
        "file": "https://example.com/medical_report.pdf"
      },
      {
        "date": "2024-11-12",
        "reason": "Việc gia đình",
        "status": "PENDING",
        "file": "https://drive.google.com/file/d/1isJqhNg2oG6ZNWdkv5gTiv33_OtQZJq3/view?usp=drivesdk"
      },
    ],
  };

  // Cập nhật trạng thái của một yêu cầu
  void updateRequestStatus(int index, String newStatus) {
    setState(() {
      _absenceRequests[_fixedClassId]![index]["status"] = newStatus;
    });
  }

  // Lưu tất cả các thay đổi trạng thái
  void saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All changes have been saved successfully')),
    );
  }

  // Mở URL
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Absence Requests'),
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
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _absenceRequests[_fixedClassId]?.length ?? 0,
                itemBuilder: (context, index) {
                  final request = _absenceRequests[_fixedClassId]![index];
                  final fileUrl = request["file"];

                  return Card(
                    child: ListTile(
                      title: Text('Date: ${request["date"]}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reason: ${request["reason"]}'),
                          const SizedBox(height: 5),
                          fileUrl != null
                              ? Row(
                            children: [
                              const Icon(Icons.attach_file, size: 16),
                              Expanded(
                                child: Text(
                                  fileUrl,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => openFileUrl(fileUrl),
                                child: const Text('View'),
                              ),
                            ],
                          )
                              : const Text(
                            'No file attached',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: DropdownButton<String>(
                        value: request["status"],
                        items: ["PENDING", "ACCEPTED", "REJECTED"]
                            .map(
                              (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            updateRequestStatus(index, value);
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
