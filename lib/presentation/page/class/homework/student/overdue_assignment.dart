import 'package:flutter/material.dart';
import '../../../../../data/model/assignment.dart';
import 'exercise_card.dart';

var assignments = [
  Assignment(
      id: 4,
      title: 'Participa nt Excercise 4',
      description: 'mo ta',
      isSubmitted: false,
      deadline: "2024-12-11T14:30:00",
      lecturerId: 1,
      fileUrl: '',
      classId: '147983'),
  Assignment(
      id: 3,
      title: 'Participant Excercise 4',
      description: 'mo ta',
      isSubmitted: false,
      deadline: "2024-12-11T14:30:00",
      lecturerId: 1,
      fileUrl: '',
      classId: '147983'),
  Assignment(
      id: 2,
      title: 'Participant Excercise 4',
      description: 'mo ta',
      isSubmitted: false,
      deadline: "2024-12-11T14:30:00",
      lecturerId: 1,
      fileUrl: '',
      classId: '147983'),
  Assignment(
      id: 1,
      title: 'Participant Excercise 4',
      description: 'mo ta',
      isSubmitted: false,
      deadline: "2024-12-11T14:30:00",
      lecturerId: 1,
      fileUrl: '',
      classId: '147983'),
];

class OverdueAssignment extends StatefulWidget {
  const OverdueAssignment({super.key});

  @override
  State<OverdueAssignment> createState() => _OverdueAssignmentState();
}

class _OverdueAssignmentState extends State<OverdueAssignment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: List.generate(assignments.length, (index) {
              return ExerciseCard(
                assignment: assignments[index],
                type: "PASS_DUE",
              );
            }),
          ),
        ),
      ],
    );
  }
}