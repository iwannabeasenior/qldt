import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm thư viện để định dạng ngày tháng
import 'package:logger/logger.dart';
import 'package:qldt/presentation/page/manage_class/open_class_list.dart';
import 'package:qldt/presentation/theme/color_style.dart';

import '../../../data/model/class.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({super.key});

  @override
  State<CreateClass> createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClass> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _classCodeController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _maxStudentsController = TextEditingController();

  // Controllers để hiển thị ngày đã chọn
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  String? _selectedSemester;
  DateTime? _startDate;
  DateTime? _endDate;

  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy'); // Định dạng ngày

  List<String> _getClassType() {
    final year = DateTime.now().year;
    return ["LT", "BT", "LT-BT"];
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
          _startDateController.text = _dateFormatter.format(pickedDate); // Cập nhật văn bản
        } else {
          _endDate = pickedDate;
          _endDateController.text = _dateFormatter.format(pickedDate); // Cập nhật văn bản
        }
      });
    }
  }

  void _createClass() {
    if (_formKey.currentState!.validate() && _startDate != null && _endDate != null ) {
      if (_endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thời gian bắt đầu không thể sau thời gian kết thúc'))
        );
        return;
      }
      final classModel = ClassModel(
        classCode: _classCodeController.text,
        semester: _selectedSemester!,
        className: _classNameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        maxStudents: int.parse(_maxStudentsController.text),
      );

      // Now you can use classModel for further processing (e.g., sending it to the backend)
      Logger().d('Class created: ${classModel}');

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tạo lớp học mới",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: QLDTColor.red,
      ),
      backgroundColor: QLDTColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _classCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Mã lớp *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mã lớp không được để trống';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedSemester,
                  decoration: const InputDecoration(
                    labelText: 'Loai lớp *',
                    border: OutlineInputBorder(),
                  ),
                  items: _getClassType().map((semester) {
                    return DropdownMenuItem<String>(
                      value: semester,
                      child: Text(semester),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSemester = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Vui lòng chọn kỳ học';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _classNameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên lớp *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tên lớp không được để trống';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context, true),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _startDateController, // Sử dụng controller
                            decoration: const InputDecoration(
                              labelText: 'Ngày bắt đầu *',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.arrow_drop_down), // Thêm tam giác ngược
                              hintText: 'Chọn ngày bắt đầu',
                            ),
                            validator: (value) {
                              if (_startDate == null) {
                                return 'Vui lòng chọn ngày bắt đầu';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context, false),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _endDateController,
                            decoration: const InputDecoration(
                              labelText: 'Ngày kết thúc *',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.arrow_drop_down),
                              hintText: 'Chọn ngày kết thúc',
                            ),
                            validator: (value) {
                              if (_endDate == null) {
                                return 'Vui lòng chọn ngày kết thúc';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _maxStudentsController,
                  decoration: const InputDecoration(
                    labelText: 'Số lượng sinh viên tối đa *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số lượng sinh viên';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Số lượng sinh viên phải là số';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _createClass,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: QLDTColor.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Tạo lớp học',style: TextStyle(
                    color: Colors.white,  // Màu chữ trắng
                    fontSize: 20,         // Kích thước font lớn hơn (tuỳ chỉnh theo nhu cầu)
                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
