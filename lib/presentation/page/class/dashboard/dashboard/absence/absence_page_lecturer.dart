import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
//View list of absence lecturer
class AbsenceLecturerPage extends StatefulWidget {
  const AbsenceLecturerPage({super.key});

  @override
  State<AbsenceLecturerPage> createState() => _AbsenceLecturerPageState();
}

class _AbsenceLecturerPageState extends State<AbsenceLecturerPage> {
  String _selectedStatusFilter = "ALL";
  String? _selectedDateFilter;

  List<Map<String, dynamic>> _absenceRequests = [
    {
      "id": "163",
      "date": "2024-11-10",
      "reason": "Bị ốm",
      "status": "PENDING",
      "file": "https://example.com/medical_report.pdf",
      "student_account": {"last_name": "TT", "first_name": "Nguyễn"}
    },
    {
      "id": "167",
      "date": "2024-11-12",
      "reason": "Việc gia đình",
      "status": "PENDING",
      "file": "https://drive.google.com/file/d/1isJqhNg2oG6ZNWdkv5gTiv33_OtQZJq3/view?usp=drivesdk",
      "student_account": {"last_name": "Anh", "first_name": "Lê"}
    },
  ];


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
  // Lọc yêu cầu
  List<Map<String, dynamic>> get filteredRequests {
    List<Map<String, dynamic>> requests = _absenceRequests;

    // Lọc theo trạng thái
    if (_selectedStatusFilter != "ALL") {
      requests = requests.where((req) => req["status"] == _selectedStatusFilter).toList();
    }

    // Lọc theo ngày (nếu không phải "Tất cả các ngày")
    if (_selectedDateFilter != null) {
      requests = requests.where((req) => req["date"] == _selectedDateFilter).toList();
    }

    return requests;
  }

  // Hàm lưu dữ liệu
  void _saveData() {
    // Thu thập các thay đổi trạng thái
    List<Map<String, dynamic>> changes = [];

    // print("data: $_absenceRequests");
    for (var request in _absenceRequests) {
      if (request["status"] != "PENDING") {
        changes.add({
          "status": request["status"],
          "id": request["id"],
        });
      }
    }

    // Gửi dữ liệu tới server hoặc xử lý thêm
    if (changes.isNotEmpty) {
      print("Thay đổi trạng thái đã được gửi: $changes");

      // Giả sử bạn có API gửi dữ liệu
      String token = "NvZlyO"; // Token fix
      // Bạn có thể sử dụng một hàm gửi HTTP như `http.post()` để gửi `changes` và `token` tới server.

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dữ liệu đã được lưu!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có thay đổi nào để lưu!')),
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
            const SizedBox(height: 20),

            // Bộ lọc
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
                      ...(_absenceRequests)
                          .map((req) => req["date"] as String)
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
                        _selectedDateFilter = newValue == "ALL_DATES" ? null : newValue;
                      });
                    },
                    hint: const Text("Lọc theo ngày"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Danh sách yêu cầu
            Expanded(
              child: ListView.builder(
                itemCount: filteredRequests.length,
                itemBuilder: (context, index) {
                  final request = filteredRequests[index];
                  final fileUrl = request["file"];
                  final studentAccount = request["student_account"];
                  final studentName = studentAccount != null
                      ? '${studentAccount["first_name"] ?? "Unknown"} ${studentAccount["last_name"] ?? ""}'
                      : "Unknown Student";

                  return Card(
                    child: ListTile(
                      title: Text('Student: $studentName'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${request["date"]}'),
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
                        onChanged: (newValue) {
                          setState(() {
                            request["status"] = newValue;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Nút Lưu
            Center(
              child: ElevatedButton(
                onPressed: _saveData, // Gọi hàm lưu dữ liệu
                child: const Text('Lưu'),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
