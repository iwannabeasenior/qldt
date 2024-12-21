import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qldt/presentation/page/class/dashboard/info_class/student_list.dart';

import 'edit_class.dart';

// Dữ liệu lớp học (dùng chung)
Map<String, dynamic> classData = {
  'type': 'Lý thuyết-LT',
  'lecturer': 'Nguyễn Tiến Thành',
  'students': 100,
  'startDate': '01/11/2024',
  'endDate': '31/12/2024',
};



class ClassInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFAE2C2C),
        toolbarHeight: 115,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
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
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Giải tích III - 149732',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  InfoRow(
                    title: 'Loại lớp:',
                    value: classData['type'],
                  ),
                  SizedBox(height: 8),
                  InfoRow(
                    title: 'Giảng viên:',
                    value: classData['lecturer'],
                  ),
                  SizedBox(height: 8),
                  InfoRow(
                    title: 'Số lượng sinh viên:',
                    value: classData['students'].toString(),
                  ),
                  SizedBox(height: 8),
                  InfoRow(
                    title: 'Thời gian bắt đầu:',
                    value: classData['startDate'],
                  ),
                  SizedBox(height: 8),
                  InfoRow(
                    title: 'Thời gian kết thúc:',
                    value: classData['endDate'],
                  ),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentListScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAE2C2C),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: Text(
                'Danh sách sinh viên lớp',
                style:
                TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Chuyển đến trang chỉnh sửa lớp học
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditClassScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAE2C2C),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: Text(
                'Chỉnh sửa lớp học',
                style:
                TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///// Trang chỉnh sửa lớp học
class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}



///// Trang danh sách sinh viên lớp
