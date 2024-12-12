import 'package:flutter/material.dart';
import 'package:qldt/data/model/assignment.dart';
import 'package:qldt/data/model/survey.dart';
import 'package:qldt/helper/utils.dart';
import 'package:qldt/presentation/theme/color_style.dart';
import '../../../../../data/model/class.dart';

var assignment = Assignment(
    id: 1,
    title: 'Bài tập Giải tích',
    description: 'Mô tả',
    deadline: '2024-12-04T08:23:14',
    lecturerId: 123,
    fileUrl: '',
    classId: ''
);

var submissions = [
  GetSurveyResponse(
      id: 1,
      assignmentId: 12,
      submissionTime: '2024-12-04T08:23:14',
      grade: 10.0,
      fileUrl: '',
      textResponse: '',
      studentAccount: StudentAccount(
          accountId: '29',
          lastName: 'Nguyen',
          firstName: 'Huy Hoang',
          email: 'hoang15122003@gmail.com',
          studentId: '16')),
  GetSurveyResponse(
      id: 1,
      assignmentId: 12,
      submissionTime: '2024-12-04T08:23:14',
      grade: 10.0,
      fileUrl: '',
      textResponse: '',
      studentAccount: StudentAccount(
          accountId: '29',
          lastName: 'Nguyen',
          firstName: 'Huy Hoang',
          email: 'hoang15122003@gmail.com',
          studentId: '16')),
  GetSurveyResponse(
      id: 1,
      assignmentId: 12,
      submissionTime: '2024-12-04T08:23:14',
      grade: 10.0,
      fileUrl: '',
      textResponse: '',
      studentAccount: StudentAccount(
          accountId: '29',
          lastName: 'Nguyen',
          firstName: 'Huy Hoang',
          email: 'hoang15122003@gmail.com',
          studentId: '16')),
  GetSurveyResponse(
      id: 1,
      assignmentId: 12,
      submissionTime: '2024-12-04T08:23:14',
      grade: null,
      fileUrl: '',
      textResponse: '',
      studentAccount: StudentAccount(
          accountId: '29',
          lastName: 'Nguyen',
          firstName: 'Huy Hoang',
          email: 'hoang15122003@gmail.com',
          studentId: '16'))
];

class SubmissionList extends StatefulWidget {
  const SubmissionList({super.key});

  @override
  State<SubmissionList> createState() => _SubmissionListState();
}

class _SubmissionListState extends State<SubmissionList> {
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
          const SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 10,),
              Text(
                assignment.title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 0),
            child: Divider(thickness: 1, color: Colors.black,),
          ),
          Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: List.generate(submissions.length, (index) {
                  return SubmissionCard(
                    submission: submissions[index],
                    index: index + 1,
                  );
                }),
              )),
        ],
      ),
    );
  }
}

class SubmissionCard extends StatelessWidget {
  final GetSurveyResponse submission;
  final int index;

  const SubmissionCard(
      {super.key, required this.submission, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/GradingAssignment');
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: QLDTColor.lightBlack),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$index. ${submission.studentAccount
                            .firstName} ${submission.studentAccount
                            .lastName} - ${submission.studentAccount.studentId}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      submission.grade != null ? const Icon(
                        Icons.check_box_outlined, color: Colors.green,)
                          : const Icon(
                        Icons.error_outline, color: Colors.red,)
                    ],
                  ),
                  submission.grade != null ? const Divider(color: Colors.green,)
                      : const Divider(color: Colors.red,),
                  Text(
                    'Đã nộp vào: ${Utils.formatDateTime(
                        submission.submissionTime)}',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      submission.grade != null
                          ? Text('Điểm: ${submission.grade}', style: const TextStyle(color: Colors.green),)
                          : const Text('Chưa chấm điểm', style: const TextStyle(color: Colors.red),),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
