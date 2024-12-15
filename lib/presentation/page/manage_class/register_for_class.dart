// import 'package:flutter/materials.dart';
// import 'package:logger/logger.dart';
// import 'package:qldt/presentation/page/manage_class/open_class_list.dart';
// import 'package:qldt/presentation/theme/color_style.dart';
//
// import '../../../data/model/class.dart';
//
// class RegisterForClass extends StatefulWidget {
//   const RegisterForClass({super.key});
//
//   @override
//   State<RegisterForClass> createState() => _RegisterForClassPageState();
// }
//
// class _RegisterForClassPageState extends State<RegisterForClass> {
//   final List<ClassModel> classData = [
//     ClassModel(
//       classCode: "101",
//       semester: "2024.1",
//       className: "Toán Cơ Bản",
//       description: null,
//       startDate: DateTime(2024, 01, 10),
//       endDate: DateTime(2024, 05, 10),
//       maxStudents: 50,
//     ),
//     ClassModel(
//       classCode: "102",
//       semester: "2024.1",
//       className: "Vật Lý Cơ Bản",
//       description: null,
//       startDate: DateTime(2024, 01, 12),
//       endDate: DateTime(2024, 05, 12),
//       maxStudents: 50,
//     ),
//     ClassModel(
//       classCode: "103",
//       semester: "2024.1",
//       className: "Hóa Học Cơ Bản",
//       description: null,
//       startDate: DateTime(2024, 01, 15),
//       endDate: DateTime(2024, 05, 15),
//       maxStudents: 50,
//     ),
//   ];
//
//   final TextEditingController _controller = TextEditingController();
//   List<ClassModel> filteredClassData = [];
//   List<bool> selectedClasses = [];
//   Widget? errorWidget;
//
//   void _searchClass() {
//     final String input = _controller.text.trim();
//
//     final classToAdd =
//         classData.where((classInfo) => classInfo.classCode == input);
//
//     if (classToAdd.isNotEmpty &&
//         !filteredClassData.any((classInfo) => classInfo.classCode == input)) {
//       filteredClassData.add(classToAdd.first);
//       selectedClasses.add(false);
//       errorWidget = null;
//     } else {
//       errorWidget = Text(
//         'Không tìm thấy lớp với mã: $input',
//         style: const TextStyle(color: Colors.red, fontSize: 16),
//       );
//     }
//
//     setState(() {});
//     _controller.clear();
//   }
//
//   void _deleteSelectedClasses() {
//     for (int i = filteredClassData.length - 1; i >= 0; i--) {
//       if (selectedClasses[i]) {
//         filteredClassData.removeAt(i);
//         selectedClasses.removeAt(i);
//       }
//     }
//     setState(() {});
//   }
//
//   void _submitRegistration() {
//     for (var classInfo in filteredClassData) {
//       Logger()
//           .d('Đã đăng ký lớp: ${classInfo.classCode} - ${classInfo.className}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Register For Class",
//           style: TextStyle(fontSize: 24, color: Colors.white),
//         ),
//         backgroundColor: QLDTColor.red,
//       ),
//       backgroundColor: QLDTColor.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               const SizedBox(height: 30),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: TextField(
//                       controller: _controller,
//                       decoration: InputDecoration(
//                         hintText: 'Nhập Mã Lớp',
//                         border: const OutlineInputBorder(),
//                         hintStyle: TextStyle(color: QLDTColor.red),
//                       ),
//                       style: TextStyle(color: QLDTColor.red),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     flex: 1,
//                     child: ElevatedButton(
//                       onPressed: _searchClass,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: QLDTColor.red,
//                         minimumSize: const Size(double.infinity, 56),
//                       ),
//                       child: const Text(
//                         'Đăng Ký',
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20,),
//
//               // Display error widget if it is set
//               if (errorWidget != null) errorWidget!,
//
//               // Your existing table for displaying class information...
//               if (filteredClassData.isNotEmpty)
//                 Table(
//                   border: TableBorder.all(color: Colors.white),
//                   children: [
//                     TableRow(
//                       children: [
//                         Container(
//                           color: QLDTColor.red,
//                           padding: const EdgeInsets.all(8.0),
//                           child: const Text(
//                             'Mã Lớp',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         Container(
//                           color: QLDTColor.red,
//                           padding: const EdgeInsets.all(8.0),
//                           child: const Text(
//                             'Số lượng',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         Container(
//                           color: QLDTColor.red, // Add your desired background color here
//                           padding: const EdgeInsets.all(8.0),
//                           child: const Text(
//                             'Tên Lớp',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         Container(
//                           color: QLDTColor.red, // Add your desired background color here
//                           padding: const EdgeInsets.all(8.0),
//                           child: const Text(
//                             'Chọn',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     ...filteredClassData.asMap().entries.map((entry) {
//                       int index = entry.key;
//                       ClassModel data = entry.value;
//
//                       return TableRow(
//                         children: [
//                           Container(
//                             height: 70,
//                             color: QLDTColor.red,
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(data.classCode,
//                                 style: const TextStyle(color: Colors.white)),
//                           ),
//                           Container(
//                             height: 70,
//                             color: QLDTColor.red,
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(data.maxStudents.toString(),
//                                 style: const TextStyle(color: Colors.white)),
//                           ),
//                           Container(
//                             height: 70,
//                             color: QLDTColor.red,
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(data.className,
//                                 style: const TextStyle(color: Colors.white)),
//                           ),
//                           Container(
//                             height: 70,
//                             color: QLDTColor.red,
//                             alignment: Alignment.center,
//                             padding: const EdgeInsets.all(8.0),
//                             child: Checkbox(
//                               value: selectedClasses[index],
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   selectedClasses[index] = value!;
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: SizedBox(
//                       height: 56,
//                       child: ElevatedButton(
//                         onPressed: _submitRegistration,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: QLDTColor.red,
//                         ),
//                         child: const Text(
//                           'Gửi Đăng Ký',
//                           style: TextStyle(color: Colors.white, fontSize: 20),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _deleteSelectedClasses,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: QLDTColor.red,
//                       ),
//                       child: const Text(
//                         'Xóa các lớp đã chọn',
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/OpenClassList');
//                     },
//                     child: Text(
//                       'Danh sách các lớp mở',
//                       style: TextStyle(
//                         decoration: TextDecoration.underline,
//                         color: QLDTColor.red,
//                         fontSize: 24,
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qldt/presentation/page/manage_class/open_class_list.dart';
import 'package:qldt/presentation/theme/color_style.dart';

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
  State<RegisterForClass> createState() => _RegisterForClassPageState();
}

class _RegisterForClassPageState extends State<RegisterForClass> {
  final List<ClassModel2> classData = [
    ClassModel2(
      classId: "101",
      className: "Toán Cơ Bản",
      attachedCode: null,
      classType: "Theory",
      lecturerName: "Dr. A",
      studentCount: 50,
      startDate: DateTime(2024, 01, 10),
      endDate: DateTime(2024, 05, 10),
      status: "Open",
    ),
    ClassModel2(
      classId: "102",
      className: "Vật Lý Cơ Bản",
      attachedCode: null,
      classType: "Lab",
      lecturerName: "Dr. B",
      studentCount: 50,
      startDate: DateTime(2024, 01, 12),
      endDate: DateTime(2024, 05, 12),
      status: "Open",
    ),
    ClassModel2(
      classId: "103",
      className: "Hóa Học Cơ Bản",
      attachedCode: null,
      classType: "Theory",
      lecturerName: "Dr. C",
      studentCount: 50,
      startDate: DateTime(2024, 01, 15),
      endDate: DateTime(2024, 05, 15),
      status: "Open",
    ),
  ];

  final TextEditingController _controller = TextEditingController();
  List<ClassModel2> filteredClassData = [];
  List<bool> selectedClasses = [];
  Widget? errorWidget;

  void _searchClass() {
    final String input = _controller.text.trim();

    final classToAdd =
    classData.where((classInfo) => classInfo.classId == input);

    if (classToAdd.isNotEmpty &&
        !filteredClassData.any((classInfo) => classInfo.classId == input)) {
      filteredClassData.add(classToAdd.first);
      selectedClasses.add(false);
      errorWidget = null;
    } else {
      errorWidget = Text(
        'Không tìm thấy lớp với mã: $input',
        style: const TextStyle(color: Colors.red, fontSize: 16),
      );
    }

    setState(() {});
    _controller.clear();
  }

  void _deleteSelectedClasses() {
    for (int i = filteredClassData.length - 1; i >= 0; i--) {
      if (selectedClasses[i]) {
        filteredClassData.removeAt(i);
        selectedClasses.removeAt(i);
      }
    }
    setState(() {});
  }

  // void _submitRegistration() {
  //   for (var classInfo in filteredClassData) {
  //     Logger()
  //         .d('Đã đăng ký lớp: ${classInfo.classId} - ${classInfo.className}');
  //   }
  // }
  void _submitRegistration() async {
    // Get selected class IDs
    List<String> selectedClassIds = [];
    for (int i = 0; i < filteredClassData.length; i++) {
      if (selectedClasses[i]) {
        selectedClassIds.add(filteredClassData[i].classId);
      }
    }

    // Prepare the request body
    Map<String, dynamic> requestBody = {
      "token": "RiTn0v", // Replace with the actual token if needed
      "class_ids": selectedClassIds,
    };

    // Send the request to the server

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    flex: 1,
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
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _searchClass,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: QLDTColor.red,
                        minimumSize: const Size(double.infinity, 56),
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

              const SizedBox(height: 20,),

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
                        // Container(
                        //   color: QLDTColor.red,
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: const Text(
                        //     'Số lượng',
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   color: QLDTColor.red,
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: const Text(
                        //     'Tên Lớp',
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
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
                      ClassModel2 data = entry.value;

                      return TableRow(
                        children: [
                          Container(
                            height: 70,
                            // color: QLDTColor.red,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(data.classId,
                                style: TextStyle(color: QLDTColor.red)),
                          ),
                          // Container(
                          //   height: 70,
                          //   color: QLDTColor.red,
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text(data.studentCount.toString(),
                          //       style: const TextStyle(color: Colors.white)),
                          // ),
                          // Container(
                          //   height: 70,
                          //   color: QLDTColor.red,
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text(data.className,
                          //       style: const TextStyle(color: Colors.white)),
                          // ),
                          Container(
                            height: 70,
                            // color: QLDTColor.red,
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
                        onPressed: _submitRegistration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: QLDTColor.red,
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
                      onPressed: _deleteSelectedClasses,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: QLDTColor.red,
                      ),
                      child: const Text(
                        'Xóa các lớp đã chọn',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
