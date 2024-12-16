import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/model/survey.dart';
import 'package:qldt/data/repo/assignment_repository.dart';
import 'package:qldt/helper/utils.dart';
import 'package:qldt/presentation/page/class/homework/lecturer/lecturer_assignments_provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';

class AssignmentList extends StatelessWidget {
  final String classId;
  const AssignmentList({super.key, required this.classId});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AssignmentRepo>();
    return ChangeNotifierProvider(
        create: (context) => LecturerAssignmentProvider(repo),
        child: SurveysView(classId),
    );
  }
}

class SurveysView extends StatefulWidget {
  final classId;
  SurveysView(this.classId);

  @override
  State<SurveysView> createState() => _SurveysViewState();
}

class _SurveysViewState extends State<SurveysView> {
  @override
  void initState() {
    Logger().d(widget.classId);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LecturerAssignmentProvider>().fetchLecturerAssignments(UserPreferences.getToken() ?? "", widget.classId);
    });
  }
  @override
  Widget build(BuildContext context) {
    final lecturerAssignmentProvider = Provider.of<LecturerAssignmentProvider>(context, listen: true);
    return Column(
      children: [
        Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List.generate(
                  lecturerAssignmentProvider.surveys.length,
                  (index){
                    return AssignmentCard(survey: lecturerAssignmentProvider.surveys[index]);
                  }
              ),
            )
        )
      ],
    );
  }
}


class AssignmentCard extends StatelessWidget {
  final Survey survey;

  const AssignmentCard({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    String deadline = Utils.formatDateTime(survey.deadline.toString());
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
                            survey.title,
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
