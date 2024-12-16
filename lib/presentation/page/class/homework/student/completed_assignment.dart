import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/presentation/page/class/homework/student/student_assignments_provider.dart';
import '../../../../../data/model/assignment.dart';
import '../../../../../data/repo/assignment_repository.dart';
import '../../../../pref/user_preferences.dart';
import 'exercise_card.dart';

class CompletedAssignment extends StatelessWidget {
  final String classId;
  const CompletedAssignment({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AssignmentRepo>();
    return ChangeNotifierProvider(
      create: (context) => StudentAssignmentProvider(repo),
      child: CompletedAssignmentView(classId),
    );
  }
}

class CompletedAssignmentView extends StatefulWidget {
  final classId;
  const CompletedAssignmentView(this.classId);

  @override
  State<CompletedAssignmentView> createState() => _CompletedAssignmentViewState();
}

class _CompletedAssignmentViewState extends State<CompletedAssignmentView> {
  void initState() {
    Logger().d("class id is: ${widget.classId}");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentAssignmentProvider>().fetchStudentAssignments(UserPreferences.getToken() ?? "", "COMPLETED", widget.classId);
    });
  }
  @override
  Widget build(BuildContext context) {
    final studentAssignmentsProvider = Provider.of<StudentAssignmentProvider>(context, listen: true);
    return Column(
      children: [
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: List.generate(studentAssignmentsProvider.assignments.length, (index) {
              return ExerciseCard(
                assignment: studentAssignmentsProvider.assignments[index],
                type: "COMPLETED",
              );
            }),
          ),
        ),
      ],
    );
  }
}
