import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:qldt/data/request/files_request.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class CreateHomeWork extends StatelessWidget {
  const CreateHomeWork({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class CreateAssignmentScreen extends StatefulWidget {
  @override
  _CreateAssignmentScreenState createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? _selectedDate;
  List<FileRequest> files = [];

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      files = result.files.map((file) => FileRequest(file: file, fileData: file.bytes)).toList();
    }
  }

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
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
    return Scaffold(
      appBar: AppBar(
        title: const Column(
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
              decoration: const InputDecoration(
                labelText: "Tên bài kiểm tra*",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Mô tả
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Mô tả",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            const Center(child: Text("Hoặc", style: TextStyle(color: Colors.grey))),
            const SizedBox(height: 8),
            // Nút tải tài liệu
            Center(
              child: ElevatedButton.icon(
                onPressed: pickFiles,
                icon: const Icon(Icons.upload_file, color: Colors.white),
                label: Text(
                  files.isEmpty ? "Tải tài liệu lên" : "Change Files",
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: QLDTColor.red,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
            //Hiển thị danh sách tài liệu
            if (files.isNotEmpty)
              Column(
                children: [
                  for (var i = 0; i < files.length; i++)
                    Text('File: ${files[i].file?.name.split('/').last}'),
                ],
              ),
            const SizedBox(height: 16),
            // Chọn thời gian kết thúc
            GestureDetector(
              onTap: pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: QLDTColor.red),
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
            const SizedBox(height: 24),
            // Nút submit
            Center(
              child: ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  backgroundColor: QLDTColor.red,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}