import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/model/class_info.dart';
import 'package:qldt/presentation/page/class/dashboard/info_class/class_info_provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';

class StudentListScreen extends StatefulWidget {
  final ClassInfo? classInfo;
  const StudentListScreen({super.key, required this.classInfo});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {

  void _showAddStudentDialog(BuildContext context, ClassInfoProvider provider) {
    final TextEditingController studentIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm sinh viên',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextField(
                  controller: studentIdController,
                  decoration: const InputDecoration(
                    labelText: 'Mã số sinh viên',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final studentId = studentIdController.text;
                if (studentId.isNotEmpty) {
                  try {
                    await provider.addStudent(
                        UserPreferences.getToken() ?? "",
                        widget.classInfo!.classId,
                        studentId
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thêm sinh viên thành công')),
                    );

                    // Trả về true để báo hiệu có thay đổi dữ liệu
                    Navigator.of(context).pop(true);

                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lỗi: ${e.toString().replaceAll('Exception: ', '')}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    Navigator.of(context).pop(false);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập mã số sinh viên')),
                  );
                }
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    ).then((value) {
      // Nếu thêm thành công, pop màn hình StudentList với result = true
      if (value == true) {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClassInfoProvider>(context);
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
                '${widget.classInfo?.className} - ${widget.classInfo?.classId}',
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
                      'Danh sách lớp (${widget.classInfo!.studentCount})',
                      style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.separated(
                        itemCount: widget.classInfo!.studentCount.toInt(),
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
                                Text(widget.classInfo!.studentAccounts[index].firstName + widget.classInfo!.studentAccounts[index].lastName),
                                Text(widget.classInfo!.studentAccounts[index].studentId),
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
            const SizedBox(height: 16,),
            // Thêm nút "Thêm sinh viên" ở đây
            ElevatedButton.icon(
              onPressed: () => _showAddStudentDialog(context, provider),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAE2C2C),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text(
                'Thêm sinh viên',
                style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
