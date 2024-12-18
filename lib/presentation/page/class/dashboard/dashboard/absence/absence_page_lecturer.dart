import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../data/model/absence_lecturer.dart';
import '../../../../../../data/repo/absence_repository.dart';
import '../../../../../../data/request/get_student_absence.dart';
import 'absence_provider.dart';
//View list of absence lecturer
class AbsenceLecturerPage extends StatelessWidget {
  const AbsenceLecturerPage({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = context.read<AbsenceRepo>();
    return ChangeNotifierProvider(
      create: (context) => AbsenceProvider(repo),
      child: AbsenceLecturerView(),
    );
  }

}

class AbsenceLecturerView extends StatefulWidget {
  const AbsenceLecturerView({super.key});

  @override
  State<AbsenceLecturerView> createState() => _AbsenceLecturerViewState();
}

// class _AbsenceLecturerViewState extends State<AbsenceLecturerView> {
//   String _selectedStatusFilter = "ALL";
//   String? _selectedDateFilter;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Fetch the absence requests
//       context.read<AbsenceProvider>().getAllAbsenceRequests(
//         GetStudentAbsence(
//           token: "bq1EzE",
//           classId: "000100",
//           status: null,
//           date: null,
//           page: 0,
//           pageSize: 2,
//         ),
//       );
//     });
//   }
//
//   List<Map<String, dynamic>> _absenceRequests = [
//     {
//       "id": "163",
//       "date": "2024-11-10",
//       "reason": "Bị ốm",
//       "status": "PENDING",
//       "file": "https://example.com/medical_report.pdf",
//       "student_account": {"last_name": "TT", "first_name": "Nguyễn"}
//     },
//     {
//       "id": "167",
//       "date": "2024-11-12",
//       "reason": "Việc gia đình",
//       "status": "PENDING",
//       "file": "https://drive.google.com/file/d/1isJqhNg2oG6ZNWdkv5gTiv33_OtQZJq3/view?usp=drivesdk",
//       "student_account": {"last_name": "Anh", "first_name": "Lê"}
//     },
//   ];
//
//
//   Future<void> openFileUrl(String url) async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not open file: $url')),
//       );
//     }
//   }
//   // Lọc yêu cầu
//   List<Map<String, dynamic>> get filteredRequests {
//     List<Map<String, dynamic>> requests = _absenceRequests;
//
//     // Lọc theo trạng thái
//     if (_selectedStatusFilter != "ALL") {
//       requests = requests.where((req) => req["status"] == _selectedStatusFilter).toList();
//     }
//
//     // Lọc theo ngày (nếu không phải "Tất cả các ngày")
//     if (_selectedDateFilter != null) {
//       requests = requests.where((req) => req["date"] == _selectedDateFilter).toList();
//     }
//
//     return requests;
//   }
//
//   // Hàm lưu dữ liệu
//   void _saveData() {
//     // Thu thập các thay đổi trạng thái
//     List<Map<String, dynamic>> changes = [];
//
//     // print("data: $_absenceRequests");
//     for (var request in _absenceRequests) {
//       if (request["status"] != "PENDING") {
//         changes.add({
//           "status": request["status"],
//           "id": request["id"],
//         });
//       }
//     }
//
//     // Gửi dữ liệu tới server hoặc xử lý thêm
//     if (changes.isNotEmpty) {
//       print("Thay đổi trạng thái đã được gửi: $changes");
//
//       // Giả sử bạn có API gửi dữ liệu
//       String token = "NvZlyO"; // Token fix
//       // Bạn có thể sử dụng một hàm gửi HTTP như `http.post()` để gửi `changes` và `token` tới server.
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Dữ liệu đã được lưu!')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Không có thay đổi nào để lưu!')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Manage Absence Requests'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//
//             // Bộ lọc
//             Row(
//               children: [
//                 Expanded(
//                   child: DropdownButton<String>(
//                     value: _selectedStatusFilter,
//                     items: ["ALL", "PENDING", "ACCEPTED", "REJECTED"]
//                         .map(
//                           (status) => DropdownMenuItem(
//                         value: status,
//                         child: Text(status),
//                       ),
//                     )
//                         .toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         setState(() {
//                           _selectedStatusFilter = value;
//                         });
//                       }
//                     },
//                     hint: const Text("Filter by Status"),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: DropdownButton<String>(
//                     value: _selectedDateFilter ?? "ALL_DATES",
//                     items: [
//                       const DropdownMenuItem<String>(
//                         value: "ALL_DATES",
//                         child: Text("Tất cả các ngày"),
//                       ),
//                       ...(_absenceRequests)
//                           .map((req) => req["date"] as String)
//                           .toSet()
//                           .map(
//                             (String date) => DropdownMenuItem<String>(
//                           value: date,
//                           child: Text(date),
//                         ),
//                       )
//                           .toList(),
//                     ],
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedDateFilter = newValue == "ALL_DATES" ? null : newValue;
//                       });
//                     },
//                     hint: const Text("Lọc theo ngày"),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//
//             // Danh sách yêu cầu
//             Expanded(
//               child: ListView.builder(
//                 itemCount: filteredRequests.length,
//                 itemBuilder: (context, index) {
//                   final request = filteredRequests[index];
//                   final fileUrl = request["file"];
//                   final studentAccount = request["student_account"];
//                   final studentName = studentAccount != null
//                       ? '${studentAccount["first_name"] ?? "Unknown"} ${studentAccount["last_name"] ?? ""}'
//                       : "Unknown Student";
//
//                   return Card(
//                     child: ListTile(
//                       title: Text('Student: $studentName'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Date: ${request["date"]}'),
//                           Text('Reason: ${request["reason"]}'),
//                           const SizedBox(height: 5),
//                           fileUrl != null
//                               ? Row(
//                             children: [
//                               const Icon(Icons.attach_file, size: 16),
//                               Expanded(
//                                 child: Text(
//                                   fileUrl,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                     color: Colors.blue,
//                                     decoration: TextDecoration.underline,
//                                   ),
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed: () => openFileUrl(fileUrl),
//                                 child: const Text('View'),
//                               ),
//                             ],
//                           )
//                               : const Text(
//                             'No file attached',
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                       trailing: DropdownButton<String>(
//                         value: request["status"],
//                         items: ["PENDING", "ACCEPTED", "REJECTED"]
//                             .map(
//                               (status) => DropdownMenuItem(
//                             value: status,
//                             child: Text(status),
//                           ),
//                         )
//                             .toList(),
//                         onChanged: (newValue) {
//                           setState(() {
//                             request["status"] = newValue;
//                           });
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Nút Lưu
//             Center(
//               child: ElevatedButton(
//                 onPressed: _saveData, // Gọi hàm lưu dữ liệu
//                 child: const Text('Lưu'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
// }
class _AbsenceLecturerViewState extends State<AbsenceLecturerView> {
  String _selectedStatusFilter = "ALL";
  String? _selectedDateFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch the absence requests
      context.read<AbsenceProvider>().getAllAbsenceRequests(
        GetStudentAbsence(
          token: "bq1EzE",
          classId: "000100",
          status: null,
          date: null,
          page: 0,
          pageSize: 2,
        ),
      );
    });
  }

  List<AbsenceLecturer> get filteredRequests {
    final absenceProvider = context.read<AbsenceProvider>();
    List<AbsenceLecturer> requests = absenceProvider.absenceLecturer;

    // Filter by status
    if (_selectedStatusFilter != "ALL") {
      requests = requests
          .where((req) => req.status == _selectedStatusFilter)
          .toList();
    }
    // Filter by date
    if (_selectedDateFilter != null) {
      requests =
          requests.where((req) => req.absenceDate == _selectedDateFilter).toList();
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

  // void _saveData() {
  //   List<Map<String, dynamic>> changes = [];
  //
  //   for (var request in filteredRequests) {
  //     if (request.status != "PENDING") {
  //       changes.add({
  //         "status": request.status,
  //         "id": request.id,
  //       });
  //     }
  //   }
  //
  //   if (changes.isNotEmpty) {
  //     print("Thay đổi trạng thái đã được gửi: $changes");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Dữ liệu đã được lưu!')),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Không có thay đổi nào để lưu!')),
  //     );
  //   }
  // }

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
      String token = "bq1EzE";

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
                      ...filteredRequests
                          .map((req) => req?.absenceDate)
                          .where((date) => date != null) // Filter out null values
                          .cast<String>() // Ensure the type is String, not String?
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

                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                              'Student: ${request.studentAccount?.firstName ?? "Unknown"} ${request.studentAccount?.lastName ?? ""}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date: ${request.absenceDate}'),
                              Text('Reason: ${request.reason}'),
                              Text('Title: ${request.title}'),

                              const SizedBox(height: 5),
                              request.fileUrl != null
                                  ? Row(
                                children: [
                                  const Icon(Icons.attach_file, size: 16),
                                  Expanded(
                                    child: Text(
                                      request.fileUrl!,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration:
                                        TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        openFileUrl(request.fileUrl!),
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
                            value: request.status,
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
                                request.status = newValue!;
                              });
                            },
                          ),
                        ),
                      );
                    },
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
}
