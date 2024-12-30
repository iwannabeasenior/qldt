// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';
//
// class AbsencePage extends StatefulWidget {
//   const AbsencePage({super.key});
//
//   @override
//   State<AbsencePage> createState() => _AbsencePageState();
// }
//
// class _AbsencePageState extends State<AbsencePage> {
//   final _formKey = GlobalKey<FormState>();
//   File? _file;
//   final TextEditingController _reasonController = TextEditingController();
//   final TextEditingController _titleController = TextEditingController(); // New controller for title
//
//   // Fixed token and class data
//   final String _fixedClassId = "000100"; // Fixed class ID
//   DateTime? _selectedDate;
//
//   // Mocked data for absence list
//   final List<Map<String, dynamic>> _mockAbsenceData = [
//     {
//       "id": "163",
//       "student_account": {
//         "account_id": "236",
//         "last_name": "TT",
//         "first_name": "Nguyễn",
//         "email": "studenthust1@hust.edu.vn",
//         "student_id": "117",
//       },
//       "absence_date": "2024-11-28",
//       "title": "Nghi Hoc",
//       "reason": "xin phép nghỉ học",
//       "status": "ACCEPTED",
//       "file_url": "https://drive.google.com/file/d/1isJqhNg2oG6ZNWdkv5gTiv33_OtQZJq3/view?usp=drivesdk",
//       "class_id": "000100",
//     },
//     {
//       "id": "116",
//       "student_account": {
//         "account_id": "236",
//         "last_name": "TT",
//         "first_name": "Nguyễn",
//         "email": "studenthust1@hust.edu.vn",
//         "student_id": "117",
//       },
//       "absence_date": "2024-11-11",
//       "title": "Nghi Hoc",
//       "reason": "xin phép nghỉ học",
//       "status": "ACCEPTED",
//       "class_id": "000100",
//     },
//   ];
//
//   // Upload file
//   Future<void> pickFile() async {
//     final result = await FilePicker.platform.pickFiles();
//
//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         _file = File(result.files.single.path!);
//       });
//     }
//   }
//
//   // Submit the absence request (mocked)
//   void submitAbsenceRequest() {
//     if (!_formKey.currentState!.validate()) return;
//
//     final selectedDateStr =
//     _selectedDate != null ? _selectedDate!.toIso8601String().split("T")[0] : "";
//     final title = _titleController.text;
//     final reason = _reasonController.text;
//
//     final newAbsence = {
//       "id": DateTime.now().millisecondsSinceEpoch.toString(),
//       "student_account": {
//         "account_id": "236",
//         "last_name": "TT",
//         "first_name": "Nguyễn",
//         "email": "studenthust1@hust.edu.vn",
//         "student_id": "117",
//       },
//       "absence_date": selectedDateStr,
//       "title": title, // Include title in the absence object
//       "reason": reason,
//       "status": "PENDING",
//       "file_url": _file != null ? _file!.path : null,
//       "class_id": _fixedClassId,
//     };
//
//     setState(() {
//       _mockAbsenceData.add(newAbsence);
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Absence request submitted successfully')),
//     );
//   }
//
//   // View absence list (mocked)
//   List<Map<String, dynamic>> fetchAbsenceList() {
//     return _mockAbsenceData.where((absence) => absence["class_id"] == _fixedClassId).toList();
//   }
//
//   // Pick date
//   Future<void> pickDate() async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2023),
//       lastDate: DateTime(2025),
//     );
//
//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Absence Request'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),
//                 GestureDetector(
//                   onTap: pickDate,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 16.0, horizontal: 12.0),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Text(
//                       _selectedDate != null
//                           ? _selectedDate!.toIso8601String().split("T")[0]
//                           : 'Select Date',
//                       style: const TextStyle(fontSize: 16.0),
//                     ),
//                   ),
//                 ),
//                 if (_selectedDate == null)
//                   const Padding(
//                     padding: EdgeInsets.only(top: 5.0),
//                     child: Text(
//                       'Date is required',
//                       style: TextStyle(color: Colors.red, fontSize: 12),
//                     ),
//                   ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   controller: _titleController,
//                   decoration: const InputDecoration(labelText: 'Title'),
//                   validator: (value) =>
//                   value == null || value.isEmpty ? 'Title is required' : null,
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   controller: _reasonController,
//                   decoration: const InputDecoration(labelText: 'Reason'),
//                   validator: (value) =>
//                   value == null || value.isEmpty ? 'Reason is required' : null,
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: pickFile,
//                   child: Text(_file == null ? 'Tải minh chứng' : 'Change File'),
//                 ),
//                 if (_file != null) Text('File: ${_file!.path.split('/').last}'),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_selectedDate == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Please select a date')),
//                       );
//                       return;
//                     }
//                     submitAbsenceRequest();
//                   },
//                   child: const Text('Gửi'),
//                 ),
//                 const SizedBox(height: 20),
//                 // const Text(
//                 //   'Absent Dates:',
//                 //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 // ),
//                 // const SizedBox(height: 10),
//                 // for (var absence in fetchAbsenceList())
//                 //   Padding(
//                 //     padding: const EdgeInsets.only(bottom: 8.0),
//                 //     child: Text(
//                 //       'Date: ${absence["absence_date"]}, Title: ${absence["title"]}, Reason: ${absence["reason"]}, Status: ${absence["status"]}',
//                 //       style: const TextStyle(fontSize: 14),
//                 //     ),
//                 //   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/repo/absence_repository.dart';
import 'package:qldt/data/request/absence_request.dart'; // Import AbsenceRequest

import '../../../../../pref/user_preferences.dart';
import '../../../class_list_provider.dart';
import 'absence_provider.dart';  // Your AbsenceProvider



class AbsencePage extends StatefulWidget {
  final classId;
  const AbsencePage({super.key, required this.classId});

  @override
  State<AbsencePage> createState() => _AbsencePageState();
}


class _AbsencePageState extends State<AbsencePage> {
  late final ClassListProvider _classProvider;
  List<Class>? _classList;
  final _formKey = GlobalKey<FormState>();
  List<AbsenceFileRequest> files = [];
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  DateTime? _selectedDate;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _classProvider = context.read<ClassListProvider>();

      // Gọi `getClassList` và lưu kết quả vào `_classList`
      _classList = await _classProvider.getClassList();
      setState(() {}); // Cập nhật giao diện sau khi lấy dữ liệu
    });
  }
  // Pick file function (unchanged)
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      files = result.files.map((file) => AbsenceFileRequest(file: file, fileData: file.bytes)).toList();
      setState(() {

      });
    }
  }

  // Submit absence request to the provider
  void submitAbsenceRequest(AbsenceProvider provider) {
    if (!_formKey.currentState!.validate()) return;

    final selectedDateStr =
    _selectedDate != null ? _selectedDate!.toIso8601String().split("T")[0] : "";
    final title = _titleController.text;
    final reason = _reasonController.text;

    final absenceRequest = AbsenceRequest(
      token: UserPreferences.getToken() ?? "",
      classId: widget.classId, // Static classId for now
      // date: selectedDateStr,
      date: '${_selectedDate?.year}-${_selectedDate?.month}-${_selectedDate?.day}',
      title: _titleController.text,
      reason: _reasonController.text,
      files: files
    );

    provider.requestAbsence(absenceRequest).then((_) {
      // Show success message after the request
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Absence request submitted successfully')),
      );
    }).catchError((e) {
      // Show error message if there's an issue
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit absence request')),
      );
    });
  }

  // Date picker function (unchanged)
  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now() ,
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AbsenceProvider>(context);
    final classProvider = Provider.of<ClassListProvider>(context);


    // Tìm lớp phù hợp với widget.classId
    final matchingClass = classProvider.classes?.firstWhere(
          (c) => c.id == widget.classId,
      orElse: () =>
          Class(id: "0",
              name: "0",
              attachedCode: "0",
              lecturerName: "0",
              classType: "0",
              studentCount: "0",
              startDate: "0",
              endDate: "0",
              status: "0"),
    );
    bool isClassExpired = false;
    if (matchingClass != null && matchingClass.endDate != "0") {
      final classEndDate = DateTime.tryParse(matchingClass.endDate ?? "");
      if (classEndDate != null && classEndDate.isBefore(DateTime.now())) {
        isClassExpired = true;
      }
    }
    // if (matchingClass != null) {
    //   Logger().d("End date of class ${widget.classId}: ${matchingClass.endDate}");
    // } else {
    //   Logger().d("No class found with class_id ${widget.classId}");
    // }



    return Scaffold(
      appBar: AppBar(
        title: const Text('Absence Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isClassExpired)
              // Display the expiration message if the class is expired
                Center(
                  child: Text(
                    'Lớp học đã quá hạn',
                    style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                )
              else
              // Display the rest of the form if the class is not expired
                Column(
                  children: [
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          _selectedDate != null
                              ? _selectedDate!.toIso8601String().split("T")[0]
                              : 'Select Date',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    if (_selectedDate == null)
                      const Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          'Date is required',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Title is required' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _reasonController,
                      decoration: const InputDecoration(labelText: 'Reason'),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Reason is required' : null,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: pickFile,
                      child: Text(files.isEmpty ? 'Tải minh chứng' : 'Change File'),
                    ),
                    if (files.isNotEmpty) Column(
                      children: [
                        for (var i = 0; i < files.length; i++)
                          Text('File: ${files[i].file?.name?.split('/').last}'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a date')),
                          );
                          return;
                        }
                        submitAbsenceRequest(provider);
                      },
                      child: provider.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Gửi'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

