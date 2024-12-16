import 'package:flutter/material.dart';
import 'package:qldt/helper/format_date_time.dart';
import 'package:qldt/helper/utils.dart';
import 'package:qldt/presentation/page/class/homework/student/assignment/assignment_info.dart';

import '../../../../../data/model/assignment.dart';


class ExerciseCard extends StatelessWidget {
  final Assignment assignment;
  final String type;

  const ExerciseCard({super.key, required this.assignment, required this.type});

  @override
  Widget build(BuildContext context) {
    String deadline = FormatDateTime().formatDateTime(assignment.deadline);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AssignmentInfoPage(type: type,))
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                          type == "UPCOMING"
                              ? const Icon(Icons.navigate_next_outlined,
                              color: Colors.blue)
                              : type == "PASS_DUE"
                              ? const Icon(Icons.error_outline,
                              color: Colors.red)
                              : const Icon(Icons.check_outlined,
                              color: Colors.green)
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      type == "UPCOMING"
                          ? Text(
                        'Đến hạn vào lúc $deadline',
                        style: const TextStyle(color: Colors.grey),
                      )
                          : type == "PASS_DUE"
                          ? Text(
                        'Quá hạn vào lúc $deadline',
                        style: const TextStyle(color: Colors.grey),
                      )
                          : const Text(
                        'Đã nộp vào',
                        style: TextStyle(color: Colors.grey),
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