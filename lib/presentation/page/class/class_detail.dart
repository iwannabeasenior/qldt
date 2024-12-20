import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qldt/presentation/page/class/class_list.dart';
import 'package:qldt/presentation/page/class/homework/create_home_work.dart';
import 'package:qldt/presentation/page/class/homework/homework_page.dart';
import 'package:qldt/presentation/page/class/material/material_page.dart';
import 'package:qldt/presentation/page/home_page.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:qldt/presentation/theme/color_style.dart';

import 'dashboard/dashboard_page.dart';

class ClassDetail extends StatefulWidget {
  final classID;
  final int initialIndex;
  ClassDetail({required this.classID, this.initialIndex = 0});
  @override
  _ClassDetailState createState() => _ClassDetailState();
}

class _ClassDetailState extends State<ClassDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: widget.initialIndex, vsync: this);
    _tabController.addListener((){
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
    // final argument = ModalRoute.of(context)?.settings.arguments as String;
    final String role = UserPreferences.getRole() ?? "";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFAE2C2C),
        toolbarHeight: 100,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(index: 1,)));
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "HUST",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              "IT3030",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.green,
            tabs: [
              Tab(text: 'Lớp học'),
              Tab(text: 'Bài tập'),
              Tab(text: 'Tài liệu'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                DashboardPage(),
                HomeworkPage(classId: widget.classID,),
                MaterialsPage(classID: widget.classID)
              ],
            ),
          ),
        ],
      ),
      floatingActionButton:
        _tabController.index == 1 && role != 'STUDENT'
          ? FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateAssignmentScreen()));
            },
            backgroundColor: QLDTColor.red,
            child: const Icon(Icons.add, color: Colors.white,),
        )
          : SizedBox.shrink(),
    );
  }
}
