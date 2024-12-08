import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/survey.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/class.dart';

class DetailGradingPage extends StatefulWidget {
  final GetSurveyResponse response;
  final Survey survey;

  const DetailGradingPage({
    Key? key,
    required this.response,
    required this.survey,
  }) : super(key: key);

  @override
  _DetailGradingPageState createState() => _DetailGradingPageState();
}

class _DetailGradingPageState extends State<DetailGradingPage> {
  bool isEditingGrade = false;
  String? newGrade;

  Future<void> _openFileUrl(String url) async {
    final Uri uri = Uri.parse(url);
    Logger().d('url is: $url');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'không thể mở $url';
    }
  }

  void _submitGrade() {
    if (newGrade != null && newGrade!.isNotEmpty) {
      double? gradeValue = double.tryParse(newGrade!);
      if (gradeValue != null) {
        // Call the API to update the grade
        updateGrade(gradeValue);

        setState(() {
          widget.response.grade = gradeValue; // Update the grade locally
          isEditingGrade = false; // Exit edit mode
          newGrade = null; // Clear the new grade input
        });
      } else {
        // Show an error if the input is not a valid double
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Điểm không hợp lệ. Vui lòng nhập lại.")),
        );
      }
    }
  }

  Future<void> updateGrade(double grade) async {
    // Simulate API call to update the grade
    Logger().d("Updating grade to: $grade for student: ${widget.response.studentId}");
    // Implement your API call here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HUST"),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "1: ${widget.response.studentId}", // Display the student ID
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Đề bài:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.survey.description),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildFilesSection(widget.response),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Điểm: ${widget.response.grade ?? 'Chưa chấm điểm'}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (widget.response.grade == null) ...[
              const SizedBox(height: 16),
              if (!isEditingGrade)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditingGrade = true; // Enter edit mode
                    });
                  },
                  child: Text("Nhập Điểm"),
                ),
              if (isEditingGrade) ...[
                TextField(
                  keyboardType: TextInputType.number, // Numeric input
                  decoration: InputDecoration(labelText: "Nhập điểm"),
                  onChanged: (value) {
                    newGrade = value; // Capture the input value
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isEditingGrade = false; // Exit edit mode without saving
                          newGrade = null; // Clear the input
                        });
                      },
                      child: Text("Hủy"),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _submitGrade,
                      child: Text("Xác nhận"),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilesSection(GetSurveyResponse response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (response.fileUrl != null)
          InkWell(
            onTap: () => _openFileUrl(response.fileUrl!),
            child: Row(
              children: [
                Icon(Icons.link, color: Colors.blue),
                const SizedBox(width: 8),
                Text('Open File'),
              ],
            ),
          ),
      ],
    );
  }
}
