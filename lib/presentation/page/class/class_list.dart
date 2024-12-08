import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/repo/class_repository.dart';
import 'package:qldt/presentation/page/class/class_list_provider.dart';




class ClassList extends StatefulWidget {
  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  String selectedTerm = '2024.1';
  List<String> terms = ['2024.1', '2023.3', '2023.2'];
  List<Class> classList = [
  ];

  @override
  Widget build(BuildContext context) {
    var repo = context.read<ClassRepo>();

    return FutureProvider<List<Class>?>(
      create: (_) => ClassListProvider(repo: repo).getClassList(),
      initialData: null,
      catchError: (_, error) {
        Logger().d(error);
        return null;
      },
      builder: (context, _) {
        var data = context.watch<List<Class>?>();
        return Scaffold(
          appBar: AppBar(
            title: const Column(
              children: [
                Text("HUST", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white)),
                Text("Danh sách lớp", style: TextStyle(fontSize: 25, color: Colors.white)),
              ],
            ),
            toolbarHeight: 115,
            centerTitle: true,
            backgroundColor: Color(0xFFAE2C2C),
            automaticallyImplyLeading: false,
          ),
          body: (data == null || data.isEmpty) ? const Center(child: CircularProgressIndicator()) : Padding(
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
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      final classSchedule = data[index];
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '');
                          },
                          child: ClassScheduleCard(classSchedule: classSchedule)
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

// Widget hiển thị thông tin lớp học
class ClassScheduleCard extends StatelessWidget {
  final Class classSchedule;

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
            // Column(
            //   children: [
            //     Text(
            //       classSchedule.startTime,
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //     ),
            //     Container(
            //       width: 1,
            //       height: 40,
            //       color: Colors.grey,
            //     ),
            //     Text(
            //       classSchedule.endTime,
            //       style: TextStyle(fontSize: 16),
            //     ),
            //   ],
            // ),
            // SizedBox(width: 16),
            // Thông tin chi tiết của lớp học
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mã lớp + Tên lớp + Mã môn
                  Text(
                    "${classSchedule.id} – ${classSchedule.name} - ${classSchedule.classType}",
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
                        classSchedule.lecturerName ?? "",
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
                        '${classSchedule.startDate} - ${classSchedule.endDate}',
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
