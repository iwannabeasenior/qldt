import 'package:flutter/material.dart';



// Dữ liệu của lớp học
class ClassSchedule {
  final String startTime;
  final String endTime;
  final String classCode;
  final String courseCode;
  final String courseName;
  final String location;
  final String dayOfWeek;
  final String week;

  ClassSchedule({
    required this.startTime,
    required this.endTime,
    required this.classCode,
    required this.courseCode,
    required this.courseName,
    required this.location,
    required this.dayOfWeek,
    required this.week,
  });
}

class ClassList extends StatefulWidget {
  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  String selectedTerm = '2024.1';
  List<String> terms = ['2024.1', '2023.3', '2023.2'];
  List<ClassSchedule> classList = [
    ClassSchedule(
      startTime: "06:45",
      endTime: "10:05",
      classCode: "154052",
      courseCode: "IT4788",
      courseName: "Phát triển ứng dụng đa nền tảng",
      location: "TC - 207",
      dayOfWeek: "Sáng thứ 3, tiết 1 - 4",
      week: "Tuần 6",
    ),
    ClassSchedule(
      startTime: "06:45",
      endTime: "10:05",
      classCode: "154052",
      courseCode: "IT4788",
      courseName: "Phát triển ứng dụng đa nền tảng",
      location: "TC - 207",
      dayOfWeek: "Sáng thứ 3, tiết 1 - 4",
      week: "Tuần 6",
    ),
    // Thêm các lớp khác vào danh sách ở đây...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("HUST", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white)),
            Text("Danh sách lớp", style: TextStyle(fontSize: 25, color: Colors.white)),
          ],
        ),
        toolbarHeight: 115,
        centerTitle: true,
        backgroundColor: Color(0xFFAE2C2C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DropdownButton để chọn kỳ học
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Kỳ: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedTerm,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTerm = newValue!;
                    });
                  },
                  items: terms.map<DropdownMenuItem<String>>((String term) {
                    return DropdownMenuItem<String>(
                      value: term,
                      child: Text(term),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Danh sách lớp học
            Expanded(
              child: ListView.builder(
                itemCount: classList.length,
                itemBuilder: (context, index) {
                  final classSchedule = classList[index];
                  return ClassScheduleCard(classSchedule: classSchedule);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget hiển thị thông tin lớp học
class ClassScheduleCard extends StatelessWidget {
  final ClassSchedule classSchedule;

  ClassScheduleCard({required this.classSchedule});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Thời gian bắt đầu và kết thúc
            Column(
              children: [
                Text(
                  classSchedule.startTime,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey,
                ),
                Text(
                  classSchedule.endTime,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(width: 16),
            // Thông tin chi tiết của lớp học
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mã lớp + Tên lớp + Mã môn
                  Text(
                    "${classSchedule.classCode} – ${classSchedule.courseName} - ${classSchedule.courseCode}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  // Đường ngăn cách
                  Divider(color: Colors.black),
                  SizedBox(height: 4),
                  // Thông tin lớp học với chấm màu xanh ở đầu
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.blue, size: 8),
                      SizedBox(width: 4),
                      Text(
                        "${classSchedule.dayOfWeek}, ${classSchedule.location}",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.blue, size: 8),
                      SizedBox(width: 4),
                      Text(
                        classSchedule.week,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
