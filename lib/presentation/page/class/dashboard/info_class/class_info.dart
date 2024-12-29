import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qldt/main.dart';
import 'package:qldt/presentation/page/class/class_list.dart';
import 'package:qldt/presentation/page/class/dashboard/info_class/class_info_provider.dart';
import 'package:qldt/presentation/page/class/dashboard/info_class/student_list.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';

import '../../../../../data/model/class_info.dart';
import 'edit_class.dart';


class ClassInfoScreen extends StatefulWidget {
  final String classId;

  const ClassInfoScreen({super.key, required this.classId});

  @override
  State<ClassInfoScreen> createState() => _ClassInfoScreenState();
}

class _ClassInfoScreenState extends State<ClassInfoScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassInfoProvider>().getClassInfo(
          UserPreferences.getToken() ?? "",
          UserPreferences.getRole() ?? "",
          UserPreferences.getId() ?? "",
          widget.classId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final classInfoProvider =
        Provider.of<ClassInfoProvider>(context, listen: true);

    if (classInfoProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFAE2C2C),
        toolbarHeight: 115,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
              "Thông tin lớp học",
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
                '${classInfoProvider.classInfo?.className} - ${classInfoProvider.classInfo?.classId}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  InfoRow(
                    title: 'Loại lớp:',
                    value: classInfoProvider.classInfo!.classType,
                  ),
                  const SizedBox(height: 8),
                  InfoRow(
                    title: 'Giảng viên:',
                    value: classInfoProvider.classInfo!.lecturerName,
                  ),
                  const SizedBox(height: 8),
                  InfoRow(
                    title: 'Số lượng sinh viên:',
                    value: classInfoProvider.classInfo?.studentCount.toString() ?? "0",
                  ),
                  const SizedBox(height: 8),
                  InfoRow(
                    title: 'Thời gian bắt đầu:',
                    value: classInfoProvider.classInfo!.startDate,
                  ),
                  const SizedBox(height: 8),
                  InfoRow(
                    title: 'Thời gian kết thúc:',
                    value: classInfoProvider.classInfo!.endDate,
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                // Đợi kết quả từ EditClassScreen
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentListScreen(classInfo: classInfoProvider.classInfo,)),
                );

                // Nếu có cập nhật thành công, refresh lại data
                if (result == true) {
                  await context.read<ClassInfoProvider>().getClassInfo(
                      UserPreferences.getToken() ?? "",
                      UserPreferences.getRole() ?? "",
                      UserPreferences.getId() ?? "",
                      widget.classId
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAE2C2C),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text(
                'Danh sách sinh viên lớp',
                style:
                    TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 16),
            UserPreferences.getRole() == "LECTURER"
                ? ElevatedButton(
              onPressed: () async {
                // Đợi kết quả từ EditClassScreen
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditClassScreen(classInfo: classInfoProvider.classInfo,)),
                );

                // Nếu có cập nhật thành công, refresh lại data
                if (result == true) {
                  await context.read<ClassInfoProvider>().getClassInfo(
                      UserPreferences.getToken() ?? "",
                      UserPreferences.getRole() ?? "",
                      UserPreferences.getId() ?? "",
                      widget.classId
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAE2C2C),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text(
                'Chỉnh sửa lớp học',
                style:
                    TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              ),
            )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

///// Trang danh sách sinh viên lớp
