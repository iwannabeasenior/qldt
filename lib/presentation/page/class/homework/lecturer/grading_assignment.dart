import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/model/survey.dart';
import 'package:qldt/presentation/page/class/homework/lecturer/submission_list.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:qldt/presentation/theme/color_style.dart';
import 'package:url_launcher/url_launcher.dart';

import 'lecturer_assignments_provider.dart';

class GradingAssignment extends StatefulWidget {
  final GetSurveyResponse submission;
  final String title;
  final String classId;
  const GradingAssignment({super.key, required this.submission, required this.title, required this.classId});

  @override
  State<GradingAssignment> createState() => _GradingAssignmentState();
}

class _GradingAssignmentState extends State<GradingAssignment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SubmissionList(title: widget.title, surveyId: widget.submission.assignmentId.toString(), classId: widget.classId,)));
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
                  'Chấm điểm bài tập',
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
        backgroundColor: const Color(0xffAE2C2C),
        centerTitle: true,
        toolbarHeight: 115,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: Column(
              children: [
                //Tên sinh viên
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.submission.studentAccount.firstName} ${widget.submission.studentAccount.lastName} - ${widget.submission.studentAccount.studentId}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1, color: Colors.black,)
                //Bài tập đã nộp
              ],
            ),
          ),
          GestureDetector(
            onTap: _launchUrl,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: QLDTColor.lightBlack)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.note_outlined, color: Colors.red,),
                              const SizedBox(width: 8,),
                              Text(
                                'Thông tin bài tập đã nộp',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          const Divider(),
                          Text(
                            widget.submission.fileUrl ?? "",
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            )
                          ),
                        ],
                      )
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
              onPressed: _showGradingSubmissionDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black
              ),
              child: widget.submission.grade != null
              ? Text('Chấm điểm: ${widget.submission.grade}')
                : const Text('Chấm điểm: ..'),
          )
        ],
      ),
    );
  }

  //launch Url
  late final Uri _url = Uri.parse(widget.submission.fileUrl ?? "");
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  //grading submission dialog
  void _showGradingSubmissionDialog() {
    final TextEditingController gradeController = TextEditingController();
    gradeController.text = widget.submission.grade.toString();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Nhập điểm bài tập'),
            content: TextField(
              controller: gradeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    final String score = gradeController.text.trim();
                    if (score.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng nhập điểm hợp lệ')),
                      );
                      return;
                    }

                    // Gọi API chấm điểm
                    final provider = context.read<LecturerAssignmentProvider>();
                    try {
                      await provider.gradingSubmission(
                        UserPreferences.getToken() ?? "",
                        widget.submission.assignmentId.toString(),
                        score,
                        widget.submission.id.toString(),
                      );
                      setState(() {
                        widget.submission.grade = double.parse(score);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Chấm điểm thành công')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Có lỗi xảy ra: $e')),
                      );
                    } finally {
                      Navigator.of(context).pop(); // Đóng dialog
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: QLDTColor.red,
                    foregroundColor: QLDTColor.white,
                  ),
                  child: const Text("Xác nhận")
              ),
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: QLDTColor.grey,
                    foregroundColor: QLDTColor.lightBlack,
                  ),
                  child: const Text("Hủy")
              )
            ],
          );
        }
    );
  }
}




