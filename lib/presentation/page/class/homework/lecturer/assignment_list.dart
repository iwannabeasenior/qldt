import 'package:flutter/material.dart';
import 'package:qldt/data/model/assignment.dart';
import 'package:qldt/helper/utils.dart';
import 'package:qldt/presentation/page/class/homework/lecturer/submission_list.dart';

var assignments = [
  Assignment(
      id: 357,
      title: "Bai tap GT3",
      description: "bài tập tích phân",
      lecturerId: '9',
      deadline: "2024-12-11T14:30:00",
      fileUrl: "https://drive.google.com/file/d/1FzRajBcROur4tjZ0b_G9WfdDy6c2-hoW/view?usp=drivesdk",
      classId: "151203"),
  Assignment(
      id: 358,
      title: "Bai tap GT3",
      description: "bài tập tích phân",
      lecturerId: '9',
      deadline: "2024-12-11T14:30:00",
      fileUrl: "https://drive.google.com/file/d/1FzRajBcROur4tjZ0b_G9WfdDy6c2-hoW/view?usp=drivesdk",
      classId: "151203"),
  Assignment(
      id: 359,
      title: "Bai tap GT3",
      description: "bài tập tích phân",
      lecturerId: '9',
      deadline: "2024-12-11T14:30:00",
      fileUrl: "https://drive.google.com/file/d/1FzRajBcROur4tjZ0b_G9WfdDy6c2-hoW/view?usp=drivesdk",
      classId: "151203"),
  Assignment(
      id: 360,
      title: "Bai tap GT3",
      description: "bài tập tích phân",
      lecturerId: '9',
      deadline: "2024-12-11T14:30:00",
      fileUrl: "https://drive.google.com/file/d/1FzRajBcROur4tjZ0b_G9WfdDy6c2-hoW/view?usp=drivesdk",
      classId: "151203"),
];

class AssignmentList extends StatefulWidget {
  const AssignmentList({super.key});

  @override
  State<AssignmentList> createState() => _AssignmentListState();
}

class _AssignmentListState extends State<AssignmentList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(
                  assignments.length,
                  (index){
                    return AssignmentCard(assignment: assignments[index]);
                  }
              ),
            )
        )
      ],
    );
  }
}

class AssignmentCard extends StatelessWidget {
  final Assignment assignment;

  const AssignmentCard({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    String deadline = Utils.formatDateTime(assignment.deadline);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/SubmissionList');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            assignment.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Icon(
                            Icons.edit_note_outlined,
                            color: Colors.black,
                          )
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'Deadline: $deadline',
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
