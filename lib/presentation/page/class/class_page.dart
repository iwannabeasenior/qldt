import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qldt/presentation/page/class/dashboard/dashboard_page.dart';
import 'package:qldt/presentation/page/class/homework/homework_page.dart';
import 'package:qldt/presentation/page/class/reference/reference_page.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> with SingleTickerProviderStateMixin {
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
            Tab(text: 'Thời khóa biểu'),
            Tab(text: 'Bài tập'),
            Tab(text: 'Tài liệu'),
          ],
        )
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Dashboardpage(),
          HomeworkPage(),
          ReferencePage()
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white,),
          backgroundColor: QLDTColor.red,
          onPressed: () {
            Navigator.pushNamed(context, '/CreateClass');
          }
      ),
    );
  }
}
