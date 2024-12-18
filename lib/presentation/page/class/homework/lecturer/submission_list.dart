import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/model/assignment.dart';
import 'package:qldt/data/model/survey.dart';
import 'package:qldt/data/repo/assignment_repository.dart';
import 'package:qldt/data/repo/material_repository.dart';
import 'package:qldt/helper/utils.dart';
import 'package:qldt/presentation/page/class/class_detail.dart';
import 'package:qldt/presentation/page/class/homework/homework_page.dart';
import 'package:qldt/presentation/page/class/homework/lecturer/grading_assignment.dart';
import 'package:qldt/presentation/page/class/homework/lecturer/lecturer_assignments_provider.dart';
import 'package:qldt/presentation/page/class/homework/lecturer/survey_list.dart';
import 'package:qldt/presentation/page/class/material/material_provider.dart';
import 'package:qldt/presentation/page/home_page.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:qldt/presentation/theme/color_style.dart';
import '../../../../../data/model/class.dart';


class SubmissionList extends StatelessWidget {
  final String title;
  final String surveyId;
  final String classId;
  const SubmissionList({super.key, required this.title, required this.surveyId, required this.classId});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AssignmentRepo>();
    return ChangeNotifierProvider(
        create: (context) => LecturerAssignmentProvider(repo),
        child: SubmissionListView(title, surveyId, classId),
    );
  }
}

class SubmissionListView extends StatefulWidget {
  final title;
  final surveyId;
  final String classId;
  const SubmissionListView(this.title, this.surveyId, this.classId);

  @override
  State<SubmissionListView> createState() => _SubmissionListViewState();
}

class _SubmissionListViewState extends State<SubmissionListView> {
  @override
  void initState() {
    Logger().d("surveyId is: ${widget.surveyId}, token is ${UserPreferences.getToken()}");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LecturerAssignmentProvider>().fetchSubmissionList(UserPreferences.getToken() ?? "", widget.surveyId);
    });
  }
  @override
  Widget build(BuildContext context) {
    final submissionProvider = Provider.of<LecturerAssignmentProvider>(context, listen: true);
    if (submissionProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent,),
      );
    }
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ClassDetail(classID: widget.classId, initialIndex: 1,)));
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
                widget.title,
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
              child: submissionProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                scrollDirection: Axis.vertical,
                children: List.generate(submissionProvider.surveyResponses.length, (index) {
                  return SubmissionCard(
                    submission: submissionProvider.surveyResponses[index],
                    index: index + 1, title: widget.title, classId: widget.classId,
                  );
                }),
              )
          ),
        ],
      ),
    );
  }
}


class SubmissionCard extends StatelessWidget {
  final GetSurveyResponse submission;
  final String title;
  final int index;
  final String classId;

  const SubmissionCard(
      {required this.submission, required this.index, required this.title, required this.classId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>GradingAssignment(submission: submission, title: title, classId: classId,)));
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
