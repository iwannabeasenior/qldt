import 'package:flutter/material.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/model/survey.dart';
import 'package:qldt/presentation/theme/color_style.dart';
import 'package:url_launcher/url_launcher.dart';

var submission = GetSurveyResponse(
    id: 1,
    assignmentId: 12,
    submissionTime: '',
    grade: 10.0,
    fileUrl: 'https://drive.google.com/file/d/1BlF0F94Eq1xBRq63mcbZQYOnMyCn-3mA/view?usp=drivesdk',
    textResponse: 'bai lam cua toi',
    studentAccount: StudentAccount(
        accountId: '26',
        lastName: 'Nguyen',
        firstName: 'Hoang',
        email: 'hoang15122003@gmail.com',
        studentId: '16'));

class GradingAssignment extends StatefulWidget {
  const GradingAssignment({super.key});

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
                      '${submission.studentAccount.firstName} ${submission.studentAccount.lastName} - ${submission.studentAccount.studentId}',
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
                            submission.fileUrl,
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
              child: submission.grade != null
              ? Text('Chấm điểm: ${submission.grade}')
                : const Text('Chấm điểm: ..'),
          )
        ],
      ),
    );
  }

  //launch Url
  final Uri _url = Uri.parse(submission.fileUrl);
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  //grading submission dialog
  void _showGradingSubmissionDialog() {
    final TextEditingController gradeController = TextEditingController();
    gradeController.text = submission.grade.toString();
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
                  onPressed: (){
                    //gọi API chấm điểm 
                    Navigator.of(context).pop();
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




