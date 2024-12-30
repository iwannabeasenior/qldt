// import 'package:flutter/material.dart';
// import 'package:qldt/presentation/page/class/dashboard/info_class/class_info.dart';
// import 'package:qldt/presentation/pref/user_preferences.dart';
// List<String> icons_lecturer = [
//   "assets/detail_class_icon/class_info.png",
//   "assets/detail_class_icon/attendance.png",
//   "assets/detail_class_icon/attendance_history.png",
//   "assets/detail_class_icon/absence_list.png",
// ];
// List<String> titles_lecturer = [
//   "Thông tin lớp học",
//   "Điểm danh",
//   "Lịch sử điểm danh",
//   "Danh sách xin nghỉ",
// ];
//
//
// List<String> icons_student = [
//   "assets/detail_class_icon/class_info.png",
//   "assets/detail_class_icon/absence_application.png",
//   "assets/detail_class_icon/absence.png",
//   "assets/detail_class_icon/attendance_history.png",
// ];
// List<String> titles_student = [
//   "Thông tin lớp học",
//   "Lịch sử xin nghỉ",
//   "Xin nghỉ",
//   "Lịch sử vắng mặt",
// ];
//
//
// class DashboardPage extends StatefulWidget {
//   final String classId;
//   const DashboardPage({super.key, required this.classId});
//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }
//
// class _DashboardPageState extends State<DashboardPage> {
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> screens = [
//       ClassInfoScreen(classId: widget.classId),
//       const ClassInfoScreen(classId: '',),// sửa lại sang màn hình xin nghỉ
//       const ClassInfoScreen(classId: '',),// sửa lại sang màn hình xin nghỉ
//       const ClassInfoScreen(classId: '',),// sửa lại sang màn hình điểm danh
//     ];
//     return Container(
//       margin: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black),
//         borderRadius: BorderRadius.circular(20)
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: UserPreferences.getRole() == 'STUDENT' ? Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             for(var i = 0; i < icons_student.length; i++)
//               _Item(
//                 title: titles_student[i],
//                 icon: icons_student[i],
//                 itemClick: () {
//                   switch(i) {
//                     case 0:
//                       Navigator.push(context, MaterialPageRoute(builder: (context)=>screens[i]));
//                     case 1:
//                       Navigator.pushNamed(context, '/AbsencePageStudent', arguments: widget.classId);
//                     case 2:
//                       Navigator.pushNamed(context, '/AbsencePage', arguments: widget.classId);
//                     case 3:
//                       Navigator.pushNamed(context, '/AttendancePage', arguments: widget.classId);
//                   }
//
//                 },
//               )
//           ],
//         ) : Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             for(var i = 0; i < icons_lecturer.length; i++) _Item(
//               title: titles_lecturer[i],
//               icon: icons_lecturer[i],
//               itemClick: () {
//                 switch(i) {
//                   case 0:
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>screens[i]));
//                   case 1:
//                     Navigator.pushNamed(context, '/AttendancePageLecturer', arguments: widget.classId);
//                   case 2:
//                     Navigator.pushNamed(context, '/AttendanceHistoryLecturer', arguments: widget.classId);
//                   case 3:
//                     Navigator.pushNamed(context, '/AbsenceLecturerPage', arguments: widget.classId);
//                 }
//               },
//             )
//           ],
//         )
//       )
//     );
//   }
// }
//
// class _Item extends StatelessWidget {
//   final title;
//   final icon;
//   final void Function() itemClick;
//   const _Item({super.key, required this.title, required this.icon, required this.itemClick});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       flex: 1,
//       child: GestureDetector(
//         onTap: itemClick,
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           margin: EdgeInsets.symmetric(vertical: 8),
//           decoration: BoxDecoration(
//               border: Border.all(color: Colors.black),
//               borderRadius: BorderRadius.circular(30)
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20
//                 ),
//               ),
//               Image(image: AssetImage(icon), height: 30, width: 30,)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:qldt/presentation/page/class/dashboard/info_class/class_info.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';

List<String> icons_lecturer = [
  "assets/detail_class_icon/class_info.png",
  "assets/detail_class_icon/attendance.png",
  "assets/detail_class_icon/attendance_history.png",
  "assets/detail_class_icon/absence_list.png",
];

List<String> titles_lecturer = [
  "Thông tin lớp học",
  "Điểm danh",
  "Lịch sử điểm danh",
  "Danh sách xin nghỉ",
];

List<String> icons_student = [
  "assets/detail_class_icon/class_info.png",
  "assets/detail_class_icon/absence_application.png",
  "assets/detail_class_icon/absence.png",
  "assets/detail_class_icon/attendance_history.png",
];

List<String> titles_student = [
  "Thông tin lớp học",
  "Lịch sử xin nghỉ",
  "Xin nghỉ",
  "Lịch sử vắng mặt",
];

class DashboardPage extends StatefulWidget {
  final String classId;
  const DashboardPage({super.key, required this.classId});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      ClassInfoScreen(classId: widget.classId),
      const ClassInfoScreen(classId: ''), // sửa lại sang màn hình xin nghỉ
      const ClassInfoScreen(classId: ''), // sửa lại sang màn hình xin nghỉ
      const ClassInfoScreen(classId: ''), // sửa lại sang màn hình điểm danh
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Dashboard'),
      // ),
      body: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: UserPreferences.getRole() == 'STUDENT'
              ? _buildStudentUI(screens)
              : _buildLecturerUI(screens),
        ),
      ),
    );
  }

  // UI for students
  Widget _buildStudentUI(List<Widget> screens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < icons_student.length; i++)
          _Item(
            title: titles_student[i],
            icon: icons_student[i],
            itemClick: () {
              switch (i) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screens[i]),
                  );
                  break;
                case 1:
                  Navigator.pushNamed(context, '/AbsencePageStudent', arguments: widget.classId);
                  break;
                case 2:
                  Navigator.pushNamed(context, '/AbsencePage', arguments: widget.classId);
                  break;
                case 3:
                  Navigator.pushNamed(context, '/AttendancePage', arguments: widget.classId);
                  break;
              }
            },
          ),
      ],
    );
  }

  // UI for lecturers
  Widget _buildLecturerUI(List<Widget> screens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < icons_lecturer.length; i++)
          _Item(
            title: titles_lecturer[i],
            icon: icons_lecturer[i],
            itemClick: () {
              switch (i) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screens[i]),
                  );
                  break;
                case 1:
                  Navigator.pushNamed(context, '/AttendancePageLecturer', arguments: widget.classId);
                  break;
                case 2:
                  Navigator.pushNamed(context, '/AttendanceHistoryLecturer', arguments: widget.classId);
                  break;
                case 3:
                  Navigator.pushNamed(context, '/AbsenceLecturerPage', arguments: widget.classId);
                  break;
              }
            },
          ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback itemClick;

  const _Item({super.key, required this.title, required this.icon, required this.itemClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: itemClick,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Image.asset(
                icon,
                height: 30,
                width: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
