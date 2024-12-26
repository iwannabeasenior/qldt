import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qldt/main.dart';
import 'package:qldt/presentation/page/class/homework/student/student_assignments_provider.dart';
import 'package:qldt/presentation/page/class/homework/student/upcoming_assignment.dart';
import 'package:qldt/presentation/theme/color_style.dart';

import 'completed_assignment.dart';
import 'overdue_assignment.dart';

class StudentAssignmentsPage extends StatefulWidget {
  final String classId;
  StudentAssignmentsPage({required this.classId});

  @override
  _StudentAssignmentsPageState createState() => _StudentAssignmentsPageState();
}

class _StudentAssignmentsPageState extends State<StudentAssignmentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);

    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        indicator: const BoxDecoration(),
        unselectedLabelColor: QLDTColor.red,
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        indicatorColor: Colors.white,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        tabs: [
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: QLDTColor.red),
                borderRadius: BorderRadius.circular(20),
                color: _tabController.index == 0
                    ? QLDTColor.red
                    : Colors.transparent,
              ),
              child: const Text('Sắp tới'),
            ),
          ),
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: QLDTColor.red),
                borderRadius: BorderRadius.circular(18),
                color: _tabController.index == 1
                    ? QLDTColor.red
                    : Colors.transparent,
              ),
              child: const Text('Quá hạn'),
            ),
          ),
          Tab(
            child: Container(
              width: 95,
              height: 40,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: QLDTColor.red),
                borderRadius: BorderRadius.circular(20),
                color: _tabController.index == 2
                    ? QLDTColor.red
                    : Colors.transparent,
              ),
              child: const Text(
                'Hoàn thành',
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TabBarView(controller: _tabController, children: [
          UpcomingAssignment(classId: widget.classId),
          OverdueAssignment(classId: widget.classId),
          CompletedAssignment(classId: widget.classId),
        ]),
      ),
    );
  }
}