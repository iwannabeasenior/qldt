import 'package:flutter/material.dart';
import 'package:qldt/data/model/assignment.dart';
import 'package:qldt/presentation/theme/color_style.dart';

Assignment assignment = Assignment(
    id: 1,
    title: 'Tieu de',
    description: 'Mo ta',
    isSubmitted: false,
    deadline: '23:59 - 26.9.2024',
    lecturerId: '20211012',
    fileUrl: 'fileUrl',
    classId: '151203'
);

class AssignmentInfoPage extends StatelessWidget {
  final String type;
  const AssignmentInfoPage({super.key, required this.type});

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
                    onPressed: () {},
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
                      Navigator.pushNamed(context, '/SubmitAssignmentPage');
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



