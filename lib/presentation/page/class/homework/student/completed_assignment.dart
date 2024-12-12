import 'package:flutter/material.dart';
import '../../../../../data/model/assignment.dart';
import 'exercise_card.dart';

var assignments = [
  Assignment(
      id: 4,
      title: 'Participant Excercise 4',
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

class CompletedAssignment extends StatefulWidget {
  const CompletedAssignment({super.key});

  @override
  State<CompletedAssignment> createState() => _CompletedAssignmentState();
}

class _CompletedAssignmentState extends State<CompletedAssignment> {
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
                type: "COMPLETE",
              );
            }),
          ),
        ),
      ],
    );
  }
}