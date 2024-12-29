import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/model/class_info.dart';
import 'package:qldt/data/repo/class_repository.dart';
import 'package:qldt/data/request/edit_class_request.dart';
import 'package:qldt/presentation/page/class/dashboard/info_class/class_info_provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';

class EditClassInfo extends StatelessWidget {
  final ClassInfo? classInfo;
  const EditClassInfo({super.key, required this.classInfo});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ClassRepo>();
    return ChangeNotifierProvider(
      create: (context) => ClassInfoProvider(repo),
      child: EditClassScreen(classInfo: classInfo,),
    );
  }
}

class EditClassScreen extends StatefulWidget {
  final ClassInfo? classInfo;
  const EditClassScreen({super.key, required this.classInfo});

  @override
  _EditClassScreenState createState() => _EditClassScreenState();
}

class _EditClassScreenState extends State<EditClassScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _classNameController = TextEditingController();

  String? _selectedStatus;
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> pickDate(String type) async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2026)
    );

    if (pickedDate != null) {
      if (type == 'start') {
        setState(() {
          _startDate = pickedDate;
        });
      } else {
        setState(() {
          _endDate = pickedDate;
        });
      }
    }
  }

  void submitRequest(ClassInfoProvider provider) {
    if (!_formKey.currentState!.validate()) return;

    if (_endDate != null && _startDate != null && _endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ngày kết thúc không được trước ngày bắt đầu')),
      );
      return;
    }

    final String startDate = _startDate != null ? _startDate!.toIso8601String().split("T")[0] : "";
    final String endDate = _endDate != null ? _endDate!.toIso8601String().split("T")[0] : "";
    final className = _classNameController.text;
    final status = _selectedStatus ?? "";

    final editClassRequest = EditClassRequest(
      token: UserPreferences.getToken(),
      classId: widget.classInfo?.classId,
      className: className,
      status: status,
      startDate: startDate,
      endDate: endDate,
    );

    provider.editClass(editClassRequest).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thông tin lớp học đã được cập nhật thành công')),
      );

      // Quay lại màn hình trước và gửi thông tin lớp học đã chỉnh sửa
      Navigator.pop(context, true);
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thông tin lớp học thất bại')),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _classNameController.text = widget.classInfo!.className;
    _selectedStatus = widget.classInfo!.status;
    _startDate = DateTime.parse(widget.classInfo!.startDate);
    _endDate = DateTime.parse(widget.classInfo!.endDate);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClassInfoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFAE2C2C),
        toolbarHeight: 115,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "HUST",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              "Chỉnh sửa thông tin lớp học",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // TextFormField Class Name
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                  controller: _classNameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên lớp học',
                    border:
                    InputBorder.none, // Không cần viền mặc định của TextField
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'class name is required' : null,
                ),
              ),
              const SizedBox(height: 16),
              // Dropdown cho trạng thái lớp học
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Trạng thái lớp học',
                    border: InputBorder.none,
                  ),
                  items: [
                    'ACTIVE',
                    'COMPLETED',
                    'UPCOMING'
                  ].map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                  validator: (value) =>
                  value == null || value.isEmpty ? 'status is required' : null,
                ),
              ),
              const SizedBox(height: 16),
              // Ngày bắt đầu
              GestureDetector(
                onTap: () => pickDate("start"),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ngày bắt đầu',
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        _startDate != null
                            ? _startDate!.toIso8601String().split("T")[0]
                            : 'Select Date',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Ngày kết thúc
              GestureDetector(
                onTap: () => pickDate("end"),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ngày kết thúc',
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        _endDate != null
                            ? _endDate!.toIso8601String().split("T")[0]
                            : 'Select Date',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Nút lưu với kiểu dáng như các nút khác
              ElevatedButton(
                onPressed: () {
                  // Cập nhật lại thông tin lớp học
                  submitRequest(provider);
                  // Quay lại màn hình trước
                  // Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAE2C2C),
                  minimumSize: const Size(
                      double.infinity, 50), // Kích thước nút giống các nút khác
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bo tròn góc nút
                  ),
                ),
                child: const Text(
                  'Lưu',
                  style:
                  TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
