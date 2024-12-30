import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/repo/assignment_repository.dart';
import 'package:qldt/data/request/files_request.dart';
import 'package:qldt/data/request/survey_request.dart';
import 'package:qldt/presentation/page/class/class_detail.dart';
import 'package:qldt/presentation/page/class/homework/lecturer/lecturer_assignments_provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class CreateHomeWork extends StatelessWidget {
  final String classId;
  const CreateHomeWork({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AssignmentRepo>();
    return ChangeNotifierProvider(
        create: (context) => LecturerAssignmentProvider(repo),
        child: CreateAssignmentScreen(classId: classId),
    );
  }
}


class CreateAssignmentScreen extends StatefulWidget {
  final String classId;
  const CreateAssignmentScreen({super.key, required this.classId});

  @override
  State<CreateAssignmentScreen> createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDate;

  List<FileRequest> files = [];

  //pick files
  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        files = result.files.map((file) => FileRequest(file: file, fileData: file.bytes)).toList();
      });
    }
  }
  //pick date
  Future<void> setDeadline() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }


  //submit create homework
  void submitHomework(LecturerAssignmentProvider provider) {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null || _selectedDate!.isBefore(DateTime.now())) {
      // Hiển thị SnackBar nếu selectedDate không hợp lệ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hạn nộp bài không hợp lệ'), backgroundColor: Colors.red,),
      );
      return;
    }

    final title = _titleController.text;
    final description = _descriptionController.text;

    final createSurveyRequest = SurveyRequest(
        token: UserPreferences.getToken() ?? "",
        classId: widget.classId,
        title: title,
        deadline: _selectedDate!.toIso8601String(),
        description: description,
        files: files
    );

    provider.createSurvey(createSurveyRequest).then((_) {
      // Show success message after the request
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Absence request submitted successfully')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClassDetail(
            classID: widget.classId,
            initialIndex: 1,
          ),
        ),
      );
    }).catchError((e) {
      // Show error message if there's an issue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit absence request $e')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LecturerAssignmentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
        backgroundColor: const Color(0xFFAE2C2C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tên bài kiểm tra
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Tên bài kiểm tra*",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              // Mô tả
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Mô tả",
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < files.length; i++)
                      Text('File: ${files[i].file?.name.split('/').last}'),
                  ],
                ),
              const SizedBox(height: 16),
              // Chọn thời gian
              GestureDetector(
                onTap: setDeadline,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: QLDTColor.red),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('HH:mm - dd/MM/yyyy').format(_selectedDate!)
                        : 'Hạn nộp bài',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Nút submit
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a date')),
                      );
                      return;
                    }
                    submitHomework(provider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: QLDTColor.red,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: provider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}