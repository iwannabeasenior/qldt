import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class RegisterForClass extends StatefulWidget {
  const RegisterForClass({super.key});

  @override
  State<RegisterForClass> createState() => _RegisterForClassPageState();
}

class _RegisterForClassPageState extends State<RegisterForClass> {
  final List<Map<String, String>> classData = [
    {"maLop": "101", "maLopKem": "201", "tenLop": "Toán Cơ Bản"},
    {"maLop": "102", "maLopKem": "202", "tenLop": "Vật Lý Cơ Bản"},
    {"maLop": "103", "maLopKem": "203", "tenLop": "Hóa Học Cơ Bản"},
  ];

  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> filteredClassData = [];
  List<bool> selectedClasses = [];

  void _searchClass() {
    final String input = _controller.text.trim();
    final classToAdd = classData.firstWhere(
          (classInfo) => classInfo['maLop'] == input,
      orElse: () => {},
    );

    if (classToAdd.isNotEmpty &&
        !filteredClassData.any((classInfo) => classInfo['maLop'] == input)) {
      filteredClassData.add(classToAdd);
      selectedClasses.add(false);
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

  void _submitRegistration() {
    // Log ra danh sách các lớp đã đăng ký
    for (var classInfo in filteredClassData) {
      Logger().d(
          'Đã đăng ký lớp: ${classInfo['maLop']} - ${classInfo['tenLop']}');
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
        
              Table(
                border: TableBorder.all(color: Colors.white),
                children: [
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Mã Lớp', style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Mã Lớp Kèm', style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Tên Lớp', style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Chọn', style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                  ...filteredClassData
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    Map<String, String> data = entry.value;
        
                    return TableRow(
                      children: [
                        Container(
                          height: 70,
                          color: QLDTColor.red,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data["maLop"]!,
                              style: const TextStyle(color: Colors.white)),
                        ),
                        Container(
                          height: 70,
                          color: QLDTColor.red,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data["maLopKem"]!,
                              style: const TextStyle(color: Colors.white)),
                        ),
                        Container(
                          height: 70,
                          color: QLDTColor.red,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data["tenLop"]!,
                              style: const TextStyle(color: Colors.white)),
                        ),
                        Container(
                          height: 70,
                          color: QLDTColor.red,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          child: Checkbox(
                            value: selectedClasses.length > index
                                ? selectedClasses[index]
                                : false,
                            onChanged: (bool? value) {
                              setState(() {
                                if (selectedClasses.length > index) {
                                  selectedClasses[index] = value!;
                                } else {
                                  selectedClasses.add(value!);
                                }
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
                      height: 56, // Chiều cao cố định cho nút
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
                    ),),
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
                        fontSize: 24
        
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