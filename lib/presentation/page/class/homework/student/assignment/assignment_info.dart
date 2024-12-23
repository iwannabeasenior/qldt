import 'package:flutter/material.dart';
import 'package:qldt/data/model/assignment.dart';
import 'package:qldt/presentation/page/class/homework/student/assignment/submit_assignment.dart';
import 'package:qldt/presentation/theme/color_style.dart';
import 'package:url_launcher/url_launcher.dart';

class AssignmentInfoPage extends StatelessWidget {
  final String type;
  final Assignment assignment;
  const AssignmentInfoPage({super.key, required this.type, required this.assignment});

  @override
  Widget build(BuildContext context) {
    //launch Url
    late final Uri _url = Uri.parse(assignment.fileUrl ?? "");
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
                  'Thông tin bài tập',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Tiêu đề bài tập
            Text(
              assignment.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
                    assignment.description,
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
                  (type == 'UPCOMING')
                      ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SubmitAssignment(assignmentId: assignment.id.toString(), classId: assignment.classId,)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: QLDTColor.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Nộp bài',
                      style: TextStyle(
                        fontSize: 16,
                        color: QLDTColor.white,
                      ),
                    ),
                  )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



