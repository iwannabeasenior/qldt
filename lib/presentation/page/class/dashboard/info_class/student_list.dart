import 'package:flutter/material.dart';
import 'package:qldt/data/model/class_info.dart';

class StudentListScreen extends StatelessWidget {
  final ClassInfo? classInfo;

  const StudentListScreen({super.key, required this.classInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFAE2C2C),
        toolbarHeight: 115,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        title: const Column(
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
              "Danh sách sinh viên lớp",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${classInfo?.className} - ${classInfo?.classId}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'Danh sách lớp (${classInfo!.studentCount})',
                      style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.separated(
                        itemCount: classInfo!.studentCount.toInt(),
                        separatorBuilder: (context, index) => const Divider(
                          color: Colors.black26, // Gạch mờ giữa các sinh viên
                          thickness: 1,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${index + 1}',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold)),
                                Text(classInfo!.studentAccounts[index].firstName + classInfo!.studentAccounts[index].lastName),
                                Text(classInfo!.studentAccounts[index].studentId),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
