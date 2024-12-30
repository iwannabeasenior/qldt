
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/repo/manage_class_repository.dart';
import 'package:qldt/presentation/page/manage_class/open_class_list.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:qldt/presentation/theme/color_style.dart';

import 'manage_class_provider.dart';

class ClassModel2 {
  final String classId;
  final String className;
  final String? attachedCode;
  final String classType;
  final String lecturerName;
  final int studentCount;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  ClassModel2({
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
}


class RegisterForClass extends StatefulWidget {
  const RegisterForClass({super.key});

  @override
  State<RegisterForClass> createState() => _RegisterForClassState();
}

class _RegisterForClassState extends State<RegisterForClass> {
  final TextEditingController _controller = TextEditingController();
  List<ClassModel1> filteredClassData = [];  // List for filtered data
  List<bool> selectedClasses = []; // To track the selected classes (checkboxes)
  Widget? errorWidget;
  List<ClassModel1> registeredClasses = [];  // List to track successfully registered classes

  Future<void> _fetchOpenClassList() async {
    final provider = Provider.of<ManageClassProvider>(context, listen: false);
    await provider.getOpenClassList(UserPreferences.getToken() ?? "", "0", "10", null, null, null, null);
  }

  @override
  void initState() {
    super.initState();
    _fetchOpenClassList();// Fetch class data when the widget is initialized

    final provider = Provider.of<ManageClassProvider>(context, listen: false);
    provider.getAllOpenClasses(UserPreferences.getToken());
  }

  // Search function to filter classes based on input
  void _searchClass() {
    final String input = _controller.text.trim();

    // Find the class that matches the entered class ID
    final classToAdd = Provider.of<ManageClassProvider>(context, listen: false)
        .openClassListCache
        .where((classInfo) => classInfo.classId == input )
        .toList();
    Logger().d("so luong la: ${Provider.of<ManageClassProvider>(context, listen: false).openClassListCache.length}");
    if (classToAdd.isNotEmpty) {
      setState(() {
        filteredClassData.add(classToAdd.first);  // Add the matched class to the list
        selectedClasses.add(false);  // Add a new entry for the newly added class in the list of selectedClasses
        errorWidget = null;  // Clear any error messages
      });
    } else {
      setState(() {
        errorWidget = Text(
          'Không tìm thấy lớp với mã: $input',
          style: const TextStyle(color: Colors.red, fontSize: 16),
        );  // Show error message
      });
    }

    _controller.clear(); // Clear input after adding the class
  }

  // Function to delete selected classes
  void _deleteSelectedClasses() {
    for (int i = filteredClassData.length - 1; i >= 0; i--) {
      if (selectedClasses[i]) {
        filteredClassData.removeAt(i);
        selectedClasses.removeAt(i);
      }
    }
    setState(() {});
  }

  // Function to submit registration for all classes in filteredClassData
  void _submitRegistration() async {
    List<String> selectedClassIds = [];

    // Collect all selected class IDs
    for (int i = 0; i < filteredClassData.length; i++) {
      // if (selectedClasses[i]) {
        selectedClassIds.add(filteredClassData[i].classId);
      // }
    }

    final provider = Provider.of<ManageClassProvider>(context, listen: false);
    if (selectedClassIds.isNotEmpty) {
      await provider
          .registerClass(UserPreferences.getToken() ?? "", selectedClassIds)
          .then((_) {
        // Show success message after the request
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng ký lớp thành công')),
        );

        // Add the successfully registered classes to registeredClasses list
        setState(() {
          registeredClasses.addAll(filteredClassData.where(
              (classInfo) => selectedClassIds.contains(classInfo.classId)));
        });
      }).catchError((e) {
        // Show error message if there's an issue
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng ký lớp thất bại')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Danh sách lớp không được trống"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register For Class",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: QLDTColor.red,
      ),
      backgroundColor: QLDTColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Nhập Mã Lớp',
                        border: const OutlineInputBorder(),
                        hintStyle: TextStyle(color: QLDTColor.red),
                      ),
                      style: TextStyle(color: QLDTColor.red),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _searchClass,  // Add the entered class to the list
                      style: ElevatedButton.styleFrom(
                        backgroundColor: QLDTColor.red,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),  // Decreased corner radius (adjust as needed)
                        ),
                      ),
                      child: const Text(
                        'Đăng Ký',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (errorWidget != null) errorWidget!,
              if (filteredClassData.isNotEmpty)
                Table(
                  border: TableBorder.all(color: QLDTColor.red),
                  children: [
                    TableRow(
                      children: [
                        Container(
                          color: QLDTColor.red,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Mã Lớp',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          color: QLDTColor.red,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Tên Lớp',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          color: QLDTColor.red,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Chọn',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...filteredClassData.asMap().entries.map((entry) {
                      int index = entry.key;
                      ClassModel1 data = entry.value;

                      return TableRow(
                        children: [
                          Container(
                            height: 70,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(data.classId,
                                style: TextStyle(color: QLDTColor.red)),
                          ),
                          Container(
                            height: 70,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(data.className,
                                style: TextStyle(color: QLDTColor.red)),
                          ),
                          Container(
                            height: 70,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Checkbox(
                              value: selectedClasses[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  selectedClasses[index] = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submitRegistration,  // Submit all selected classes
                        style: ElevatedButton.styleFrom(
                          backgroundColor: QLDTColor.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),  // Decreased corner radius (adjust as needed)
                          ),
                        ),
                        child: const Text(
                          'Gửi Đăng Ký',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _deleteSelectedClasses,  // Delete selected classes
                      style: ElevatedButton.styleFrom(
                        backgroundColor: QLDTColor.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),  // Decreased corner radius (adjust as needed)
                        ),
                      ),
                      child: const Text(
                        'Xóa các lớp đã chọn',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Display registered classes after successful registration
              if (registeredClasses.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Danh sách các lớp đã đăng ký',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: QLDTColor.red,
                      ),
                    ),
                    Table(
                      border: TableBorder.all(color: QLDTColor.red),
                      children: [
                        TableRow(
                          children: [
                            Container(
                              color: QLDTColor.red,
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                'Mã Lớp',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              color: QLDTColor.red,
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                'Tên Lớp',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...registeredClasses.map((data) {
                          return TableRow(
                            children: [
                              Container(
                                height: 70,
                                padding: const EdgeInsets.all(8.0),
                                child: Text(data.classId,
                                    style: TextStyle(color: QLDTColor.red)),
                              ),
                              Container(
                                height: 70,
                                padding: const EdgeInsets.all(8.0),
                                child: Text(data.className,
                                    style: TextStyle(color: QLDTColor.red)),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
                  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/OpenClassList');
                    },
                    child: Text(
                      'Danh sách các lớp mở',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: QLDTColor.red,
                        fontSize: 24,
                      ),
                    ),
                  ),
            ],
          ),
        ]),
      ),
    ));
  }
}


