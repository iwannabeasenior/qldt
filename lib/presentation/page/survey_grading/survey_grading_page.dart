import 'package:flutter/material.dart';

import '../../../data/model/class.dart';
import 'detail_grading_page.dart';

class SurveyGradingPage extends StatefulWidget {
  const SurveyGradingPage({super.key});

  @override
  State<SurveyGradingPage> createState() => _SurveyGradingPageState();
}

class _SurveyGradingPageState extends State<SurveyGradingPage> {
  // Sample data for testing the UI
  final List<GetSurveyResponse> responses = [
    GetSurveyResponse(
        id: 1,
        assignmentId: 19,
        studentId: 49,
        submissionTime: DateTime(2024, 11, 5, 16, 32, 18),
        grade: 10.0,
        fileUrl: 'https://drive.google.com/file/d/1Slp-scKzGRET2PomrN6RlO9UrIJJWN6G/view',
        textResponse: ""
    ),
    GetSurveyResponse(
        id: 2,
        assignmentId: 19,
        studentId: 50,
        submissionTime: DateTime(2024, 9, 24, 14, 23),
        grade: null,
        fileUrl: 'https://example.com/file2',
        textResponse: ""
    ),
    GetSurveyResponse(
        id: 3,
        assignmentId: 19,
        studentId: 51,
        submissionTime: DateTime(2024, 9, 28, 23, 59),
        grade: null,
        fileUrl: 'https://example.com/file3',
        textResponse: ""
    ),
  ];

  final List<Survey> surveys = [
    Survey(
        id: 19,
        title: 'Bài tập lớn về Histogram',
        description: 'Giả sử bạn có một mảng gồm các số nguyên không âm đại diện cho độ cao của các thanh...',
        lecturerId: 1,
        classId: 101,
        deadline: DateTime(2024, 11, 10),
        fileUrl: 'https://example.com/assignment'
    ),
    // Add more Survey instances if necessary
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Participant Exercise 23.9.2024",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: responses.asMap().entries.map((entry) {
              int index = entry.key + 1; // Get the 1-based index
              GetSurveyResponse response = entry.value;
              return GestureDetector(
                onTap: () {
                  // Find the matching Survey by `assignmentId`
                  Survey? survey = surveys.firstWhere((s) => s.id == response.assignmentId);
                  if (survey != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailGradingPage(
                          response: response,
                          survey: survey,
                        ),
                      ),
                    );
                  }
                },
                child: _buildResponseCard(response, index),
              );            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildResponseCard(GetSurveyResponse response, int index) {
    // Determine the status icon and color based on whether the grade is null
    IconData iconData;
    Color iconColor;
    String statusText;

    if (response.grade != null) {
      iconData = Icons.check_circle;
      iconColor = Colors.green;
      statusText = 'Đã chấm điểm: ${response.grade}';
    } else {
      iconData = Icons.hourglass_empty;
      iconColor = Colors.orange;
      statusText = 'Chưa chấm điểm';
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$index: Tên sv - ${response.studentId}', // Displaying the index
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                Icon(iconData, color: iconColor),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Đã nộp: ${response.submissionTime.hour}:${response.submissionTime.minute.toString().padLeft(2, '0')} - ${response.submissionTime.day}.${response.submissionTime.month}.${response.submissionTime.year}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              statusText,
              style: TextStyle(fontSize: 14, color: iconColor),
            ),
          ],
        ),
      ),
    );
  }
}
