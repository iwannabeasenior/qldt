import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/presentation/page/class/homework/student/student_assignments_provider.dart';
import '../../../../../data/model/assignment.dart';
import '../../../../../data/repo/assignment_repository.dart';
import '../../../../pref/user_preferences.dart';
import 'exercise_card.dart';

class OverdueAssignment extends StatelessWidget {
  final String classId;
  const OverdueAssignment({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AssignmentRepo>();
    return ChangeNotifierProvider(
      create: (context) => StudentAssignmentProvider(repo),
      child: OverdueAssignmentView(classId),
    );
  }
}

class OverdueAssignmentView extends StatefulWidget {
  final classId;
  OverdueAssignmentView(this.classId);

  @override
  State<OverdueAssignmentView> createState() => _OverdueAssignmentViewState();
}

class _OverdueAssignmentViewState extends State<OverdueAssignmentView> {
  @override
  void initState() {
    Logger().d("class id is: ${widget.classId}");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentAssignmentProvider>().fetchStudentAssignments(UserPreferences.getToken() ?? "", "PASS_DUE", widget.classId);
    });
  }
  @override
  Widget build(BuildContext context) {
    final studentAssignmentsProvider = Provider.of<StudentAssignmentProvider>(context, listen: true);
    return Column(
      children: [
        Expanded(
          child: studentAssignmentsProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
            scrollDirection: Axis.vertical,
            children: List.generate(studentAssignmentsProvider.assignments.length, (index) {
              return ExerciseCard(
                assignment: studentAssignmentsProvider.assignments[index],
                type: "PASS_DUE",
              );
            }),
          ),
        ),
      ],
    );
  }
}
