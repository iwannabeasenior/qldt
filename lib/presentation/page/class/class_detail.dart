import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qldt/presentation/page/class/homework/homework_page.dart';
import 'package:qldt/presentation/page/class/reference/reference_page.dart';
import 'package:qldt/presentation/theme/color_style.dart';

import 'dashboard/dashboard_page.dart';

class ClassDetail extends StatefulWidget {
  const ClassDetail({super.key});

  @override
  State<ClassDetail> createState() => _ClassDetailState();
}

class _ClassDetailState extends State<ClassDetail> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //class name
        title: Text('IT3333'),
        backgroundColor: QLDTColor.red,
        centerTitle: true,
        bottom: TabBar(
          labelStyle: TextStyle(
            color: Colors.white
          ),
          controller: _tabController,
          tabs: [
            Tab(text: 'Lớp học'),
            Tab(text: 'Bài tập'),
            Tab(text: 'Tài liệu'),
          ],
        )
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DashboardPage(),
          HomeworkPage(),
          ReferencePage()
        ],
      ),
    );
  }
}
