import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Map<String, dynamic> classData = {
  'type': 'Lý thuyết-LT',
  'lecturer': 'Nguyễn Tiến Thành',
  'students': 100,
  'startDate': '01/11/2024',
  'endDate': '31/12/2024',
};

class EditClassScreen extends StatefulWidget {
  @override
  _EditClassScreenState createState() => _EditClassScreenState();
}

class _EditClassScreenState extends State<EditClassScreen> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _startDateController.text = classData['startDate'];
    _endDateController.text = classData['endDate'];

    // Đảm bảo giá trị loại lớp học không có khoảng trắng thừa
    _selectedType = classData['type'];
    if (_selectedType == null || !_validClassTypes.contains(_selectedType)) {
      // Nếu loại lớp học không hợp lệ, chọn mặc định
      _selectedType = _validClassTypes[0];
    }
  }

  final List<String> _validClassTypes = [
    'Lý thuyết - LT',
    'Bài tập - BT',
    'LT + BT'
  ];

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
        title: Column(
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
        child: Column(
          children: [
            // Phần loại lớp học: Text + DropdownButton, thêm Container viền
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Loại lớp học: ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  // Đưa DropdownButton sang bên phải
                  DropdownButton<String>(
                    value: _selectedType,
                    items: _validClassTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedType = newValue;
                      });
                      // Cập nhật lại dữ liệu
                      classData['type'] = newValue!;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // TextField cho giảng viên với viền
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: TextEditingController(text: classData['lecturer']),
                decoration: InputDecoration(
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
    );
  }
}
