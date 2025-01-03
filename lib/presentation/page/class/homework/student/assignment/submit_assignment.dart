import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/request/survey_request.dart';
import 'package:qldt/presentation/page/class/class_detail.dart';
import 'package:qldt/presentation/page/class/homework/student/student_assignments_provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:qldt/presentation/theme/color_style.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../../../data/repo/assignment_repository.dart';
import '../../../../../../data/request/files_request.dart';

class SubmitAssignment extends StatelessWidget {
  final String assignmentId;
  final String classId;
  final String title;

  const SubmitAssignment({super.key, required this.assignmentId, required this.classId, required this.title});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AssignmentRepo>();
    return ChangeNotifierProvider(
      create: (context) => StudentAssignmentProvider(repo),
      child: SubmitAssignmentPage(assignmentId: assignmentId, classId: classId, title: title,),
    );
  }
}
  class SubmitAssignmentPage extends StatefulWidget {
    final String title;
    final String classId;
    final String assignmentId;
    const SubmitAssignmentPage({super.key, required this.assignmentId, required this.classId, required this.title});

    @override
    State<SubmitAssignmentPage> createState() => _SubmitAssignmentPageState();
  }

  class _SubmitAssignmentPageState extends State<SubmitAssignmentPage> {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _textResponseController = TextEditingController();

    //pick files
    List<FileRequest> files = [];
    Future<void> pickFiles() async {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null) {
        setState(() {
          files = result.files.map((file) => FileRequest(file: file, fileData: file.bytes)).toList();
        });
      }
    }

    //on submit
    void submitSurvey(StudentAssignmentProvider provider) {
      if (!_formKey.currentState!.validate()) return;

      final textResponse = _textResponseController.text;

      final submitSurveyRequest = SubmitSurveyRequest(
          token: UserPreferences.getToken() ?? "",
          assignmentId: widget.assignmentId,
          textResponse: textResponse,
          files: files
      );

      provider.submitSurvey(submitSurveyRequest).then((_){
        // Show success message after the request
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('submitted successfully')),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ClassDetail(classID: widget.classId, initialIndex: 1,)));
      }).catchError((e) {
        // Show error message if there's an issue
        Logger().d("Error submit: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit $e')),
        );
      });
    }

    @override
    Widget build(BuildContext context) {
      final provider = Provider.of<StudentAssignmentProvider>(context);
      return provider.isLoading ? Center(child: CircularProgressIndicator()) : Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              GestureDetector(
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Spacer(),
              const Column(
                children: [
                  Text(
                    'HUST',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                  Text(
                    'Nộp bài tập',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  )
                ],
              ),
              const Spacer(),
            ],
          ),
          backgroundColor: QLDTColor.red,
          centerTitle: true,
          toolbarHeight: 115,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Tiêu đề bài tập
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
                const Divider(
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                //Mô tả bài tập
                // Trường mô tả
                TextFormField(
                  controller: _textResponseController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: "Mô tả",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: QLDTColor.red),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 500,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: files.isNotEmpty
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tệp đã chọn:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...files.map((file) => Text(
                        'File: ${file.file?.name.split('/').last}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black),
                      )),
                    ],
                  )
                      : const Text(
                    "Tài liệu đính kèm",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),

                const SizedBox(height: 15),

                //Xem tài liệu và nộp bài
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Tải tài liệu lên
                      ElevatedButton(
                        onPressed: pickFiles,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: QLDTColor.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Text(
                          'Tải tài liệu lên',
                          style: TextStyle(fontSize: 16, color: QLDTColor.white),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      //Submit
                      ElevatedButton(
                        onPressed: () {
                          submitSurvey(provider);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: QLDTColor.red,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child:  const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }


