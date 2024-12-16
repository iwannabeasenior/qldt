import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/repo/assignment_repository.dart';
import 'package:qldt/presentation/page/class/homework/student/student_assignments_provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'exercise_card.dart';


class UpcomingAssignment extends StatelessWidget {
  final String classId;

  const UpcomingAssignment({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AssignmentRepo>();
    return ChangeNotifierProvider(
      create: (context) => StudentAssignmentProvider(repo),
      child: UpcomingAssignmentView(classId),
    );
  }
}

class UpcomingAssignmentView extends StatefulWidget {
  final classId;
  UpcomingAssignmentView(this.classId);

  @override
  State<UpcomingAssignmentView> createState() => _UpcomingAssignmentViewState();
}

class _UpcomingAssignmentViewState extends State<UpcomingAssignmentView> {
  @override
  void initState() {
    Logger().d("class id is: ${widget.classId}");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentAssignmentProvider>().fetchStudentAssignments(UserPreferences.getToken() ?? "", "UPCOMING", widget.classId);
    });
  }
  @override
  Widget build(BuildContext context) {
    final studentAssignmentsProvider = Provider.of<StudentAssignmentProvider>(context, listen: true);
    return Column(
      children: [
        Expanded(
          child: studentAssignmentsProvider.isLoading
              ? const Center(child: CircularProgressIndicator(),)
              : ListView(
            scrollDirection: Axis.vertical,
            children: List.generate(studentAssignmentsProvider.assignments.length, (index) {
              return ExerciseCard(
                assignment: studentAssignmentsProvider.assignments[index],
                type: "UPCOMING",
              );
            }),
          ),
        ),
      ],
    );
  }
}
