import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/model/class_info.dart';
import 'package:qldt/data/repo/class_repository.dart';
import 'package:qldt/presentation/page/class/dashboard/info_class/class_info_provider.dart';

Map<String, dynamic> classData = {
  'type': 'Lý thuyết-LT',
  'lecturer': 'Nguyễn Tiến Thành',
  'students': 100,
  'startDate': '01/11/2024',
  'endDate': '31/12/2024',
};

class EditClassInfo extends StatelessWidget {
  final ClassInfo classInfo;
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
  final ClassInfo classInfo;
  const EditClassScreen({super.key, required this.classInfo});

  @override
  _EditClassScreenState createState() => _EditClassScreenState();
}

class _EditClassScreenState extends State<EditClassScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> pickDate(String type) async {
    final pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2024),
        lastDate: DateTime(2026)
    );

    if(pickedDate != null) {
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



  @override
  void initState() {
    super.initState();
    _classNameController.text = widget.classInfo.className;
    _statusController.text = widget.classInfo.status;
    _startDate = DateTime.parse(widget.classInfo.startDate);
    _endDate = DateTime.parse(widget.classInfo.endDate);
  }

  @override
  Widget build(BuildContext context) {
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
              "Danh sách sinh viên lớp",
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
                    labelText: 'Giảng viên',
                    border:
                    InputBorder.none, // Không cần viền mặc định của TextField
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                  onChanged: (value) {
                    classData['lecturer'] = value;
                  },
                ),
              ),
              SizedBox(height: 16),
              // TextField cho số lượng sinh viên với viền
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                      text: classData['students'].toString()),
                  decoration: InputDecoration(
                    labelText: 'Số lượng sinh viên',
                    border:
                    InputBorder.none, // Không cần viền mặc định của TextField
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                  onChanged: (value) {
                    classData['students'] = int.tryParse(value) ?? 0;
                  },
                ),
              ),
              SizedBox(height: 16),
              // TextField cho thời gian bắt đầu với viền
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextField(
                  controller: _startDateController,
                  decoration: InputDecoration(
                    labelText: 'Thời gian bắt đầu',
                    hintText: 'dd/mm/yyyy',
                    border:
                    InputBorder.none, // Không cần viền mặc định của TextField
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _startDateController.text =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 16),
              // TextField cho thời gian kết thúc với viền
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextField(
                  controller: _endDateController,
                  decoration: InputDecoration(
                    labelText: 'Thời gian kết thúc',
                    hintText: 'dd/mm/yyyy',
                    border:
                    InputBorder.none, // Không cần viền mặc định của TextField
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _endDateController.text =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 16),
              // Nút lưu với kiểu dáng như các nút khác
              ElevatedButton(
                onPressed: () {
                  // Cập nhật lại thông tin lớp học
                  classData['startDate'] = _startDateController.text;
                  classData['endDate'] = _endDateController.text;

                  // Quay lại màn hình trước
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFAE2C2C),
                  minimumSize: Size(
                      double.infinity, 50), // Kích thước nút giống các nút khác
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bo tròn góc nút
                  ),
                ),
                child: Text(
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
