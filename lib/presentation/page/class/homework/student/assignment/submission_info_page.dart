import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../data/repo/assignment_repository.dart';
import '../../../../../theme/color_style.dart';
import '../student_assignments_provider.dart';

class SubmissionInfoPage extends StatelessWidget {
  final String title;
  final String assignmentId;
  const SubmissionInfoPage({super.key, required this.assignmentId, required this.title});
  @override
  Widget build(BuildContext context) {
    final repo = context.read<AssignmentRepo>();
    return ChangeNotifierProvider(
      create: (context) => StudentAssignmentProvider(repo),
      child: SubmissionInfoView(title: title, assignmentId: assignmentId,),
    );
  }
}

class SubmissionInfoView extends StatefulWidget {
  final String title;
  final String assignmentId;
  const SubmissionInfoView({super.key, required this.title, required this.assignmentId});
  @override
  State<SubmissionInfoView> createState() => _SubmissionInfoViewState();
}

class _SubmissionInfoViewState extends State<SubmissionInfoView> {
  @override
  void initState() {
        super.initState();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<StudentAssignmentProvider>().getSubmission(UserPreferences.getToken() ?? "", widget.assignmentId);
        });
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentAssignmentProvider>(context, listen: true);
    //launch Url
    late final Uri _url = Uri.parse(provider.submission!.fileUrl ?? "");
    Future<void> _launchUrl() async {
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
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
                  'Thông tin bài tập đã nộp',
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
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator(),)
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Tiêu đề bài tập
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                ),
                Text(
                  provider.submission?.grade == null
                      ? 'Chưa có điểm'
                      : 'Điểm: ${provider.submission?.grade.toString()}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: provider.submission?.grade.toString() != 'null' ? Colors.green : Colors.red
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey,),
            const SizedBox(height: 16),
            //Mô tả bài tập
            Container(
              padding: const EdgeInsets.all(16),
              width: 500,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mô tả:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.submission!.textResponse ?? "",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            //Xem tài liệu và nộp bài
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Xem tài liệu
                  ElevatedButton(
                    onPressed: _launchUrl,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: QLDTColor.red,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Xem tài liệu',
                      style: TextStyle(fontSize: 16, color: QLDTColor.white),
                    ),
                  ),
                  const SizedBox(height: 16,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
