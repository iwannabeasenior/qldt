import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:qldt/presentation/theme/color_style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreateAssignmentScreen(),
    );
  }
}

class CreateAssignmentScreen extends StatefulWidget {
  @override
  _CreateAssignmentScreenState createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  String? uploadedFile;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'png'],
    );
    if (result != null) {
      setState(() {
        uploadedFile = result.files.single.name;
      });
    }
  }

  Future<void> selectDateTime(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          final selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStart) {
            startDate = selectedDateTime;
          } else {
            endDate = selectedDateTime;
          }
        });
      }
    }
  }

  void submit() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tên bài kiểm tra không được để trống")),
      );
      return;
    }

    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng chọn thời gian bắt đầu và kết thúc")),
      );
      return;
    }

    if (endDate!.isBefore(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Thời gian kết thúc phải sau thời gian bắt đầu")),
      );
      return;
    }

    // Xử lý lưu bài kiểm tra
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Bài kiểm tra đã được tạo thành công!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "HUST",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              "Tạo bài tập",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ],
        ),
        toolbarHeight: 115,
        centerTitle: true,
        backgroundColor: Color(0xFFAE2C2C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên bài kiểm tra
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Tên bài kiểm tra*",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Mô tả
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Mô tả",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Center(child: Text("Hoặc", style: TextStyle(color: Colors.grey))),
            SizedBox(height: 8),
            // Nút tải tài liệu
            Center(
              child: ElevatedButton.icon(
                onPressed: pickFile,
                icon: Icon(Icons.upload_file, color: Colors.white),
                label: Text(
                  "Tải tài liệu lên",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: QLDTColor.red,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
            if (uploadedFile != null)
              Center(
                  child: Text("Đã chọn file: $uploadedFile",
                      style: TextStyle(color: Colors.grey))),
            SizedBox(height: 16),
            // Chọn thời gian bắt đầu và kết thúc
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => selectDateTime(context, true),
                    child: Text(
                      startDate != null
                          ? "Bắt đầu: ${DateFormat('yyyy-MM-dd – kk:mm').format(startDate!)}"
                          : "Bắt đầu",
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: QLDTColor.white,
                      foregroundColor: QLDTColor.red,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => selectDateTime(context, false),
                    child: Text(
                      endDate != null
                          ? "Kết thúc: ${DateFormat('yyyy-MM-dd – kk:mm').format(endDate!)}"
                          : "Kết thúc",
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: QLDTColor.white,
                      foregroundColor: QLDTColor.red,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Nút submit
            Center(
              child: ElevatedButton(
                onPressed: submit,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: QLDTColor.red,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}