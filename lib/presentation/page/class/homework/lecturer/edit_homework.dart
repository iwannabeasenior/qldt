import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/model/survey.dart';
import 'package:qldt/data/repo/assignment_repository.dart';
import 'package:qldt/data/request/files_request.dart';
import 'package:qldt/data/request/survey_request.dart';
import 'package:qldt/presentation/page/class/homework/lecturer/lecturer_assignments_provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class EditHomeWork extends StatelessWidget {
  final Survey survey;
  const EditHomeWork({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AssignmentRepo>();
    return ChangeNotifierProvider(
        create: (context) => LecturerAssignmentProvider(repo),
        child: EditAssignmentScreen(survey: survey,),
    );
  }
}


class EditAssignmentScreen extends StatefulWidget {
  final Survey survey;
  const EditAssignmentScreen({super.key, required this.survey});

  @override
  State<EditAssignmentScreen> createState() => _EditAssignmentScreenState();
}

class _EditAssignmentScreenState extends State<EditAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDate;

  List<FileRequest> files = [];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.survey.title;
    _descriptionController.text = widget.survey.description;
    _selectedDate = widget.survey.deadline;
  }

  @override
  void dispose(){
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  //pick files
  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      files = result.files.map((file) => FileRequest(file: file, fileData: file.bytes)).toList();
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
    _titleController.text = widget.survey.title;
    _descriptionController.text = widget.survey.description;
    if (!_formKey.currentState!.validate()) return;

    final description = _descriptionController.text;

    final editSurveyRequest = SurveyRequest(
        token: UserPreferences.getToken() ?? "",
        assignmentId: widget.survey.id.toString(),
        deadline: _selectedDate!.toIso8601String(),
        description: description,
        files: files
    );

    provider.editSurvey(editSurveyRequest).then((_) {
      // Show success message after the request
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Absence request submitted successfully')),
      );
    }).catchError((e) {
      // Show error message if there's an issue
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit absence request')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LecturerAssignmentProvider>(context);
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
              "Chỉnh sửa bài tập",
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
                enabled: false,
              ),
              const SizedBox(height: 16),
              // Mô tả
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Mô tả",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Description is required' : null,
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
              files.isNotEmpty
                ? Column(
                  children: [
                    for (var i = 0; i < files.length; i++)
                      Text('File: ${files[i].file?.name.split('/').last}'),
                  ],
                )
                : SizedBox.shrink(),
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
                        ? DateFormat('HH:mm - dd:MM:yyyy').format(_selectedDate!)
                        : DateFormat('HH:mm - dd:MM:yyyy').format(widget.survey.deadline),
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