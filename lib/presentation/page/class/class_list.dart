import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/repo/class_repository.dart';
import 'package:qldt/presentation/page/class/class_list_provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';




class ClassList extends StatefulWidget {
  @override
  _ClassListState createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  late ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var repo = context.read<ClassRepo>();
    var classListProvider = ClassListProvider(repo: repo);

    return ChangeNotifierProvider<ClassListProvider>(
      create: (_) => classListProvider..getClassList(),
      child: Consumer<ClassListProvider>(
        builder: (context, provider, _) {
          var data = provider.classes;

          return RefreshIndicator(
            onRefresh: () async {
              provider.getClassList(onRefresh: true);
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Column(
                  children: [
                    Text("HUST", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text("Danh sách lớp", style: TextStyle(fontSize: 25, color: Colors.white)),
                  ],
                ),
                toolbarHeight: 115,
                centerTitle: true,
                backgroundColor: const Color(0xFFAE2C2C),
                automaticallyImplyLeading: false,
              ),
              body: data == null
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Danh sách lớp học
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController, //cuộn
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final classSchedule = data[index];
                          return GestureDetector(
                              onTap: () {
                                UserPreferences;
                                Navigator.pushNamed(context, '/ClassDetail', arguments: classSchedule.id);
                              },
                              child: ClassScheduleCard(classSchedule: classSchedule));
                        },
                      ),
                    ),

                    // Thanh phân trang
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: provider.currentPage > 0
                              ? () {
                            provider.getClassList(page: provider.currentPage - 1);
                            scrollController.jumpTo(0); // scroll on top
                          }
                              : null,
                          icon: const Icon(Icons.arrow_back),
                        ),
                        Text(
                          'Page ${provider.currentPage + 1}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          onPressed: provider.hasNextPage
                              ? () {
                            provider.getClassList(page: provider.currentPage + 1);
                            scrollController.jumpTo(0); // Cuộn về đầu danh sách
                          }
                              : null, // Vô hiệu hóa nút nếu không có trang tiếp theo
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
