import 'package:flutter/material.dart';



// Đoạn này tôi đang k biết extend như nào để chạy Thành giúp tôi với

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
                border: Border.all(color: Colors.black, width: 1), // Viền đen
                borderRadius: BorderRadius.circular(8), // Bo góc
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
                    value: 'Lý thuyết-LT',
                  ),
                  SizedBox(height: 8),
                  InfoRow(
                    title: 'Giảng viên:',
                    value: 'Nguyễn Tiến Thành',
                  ),
                  SizedBox(height: 8),
                  InfoRow(
                    title: 'Số lượng sinh viên:',
                    value: '100',
                  ),
                  SizedBox(height: 8),
                  InfoRow(
                    title: 'Thời gian bắt đầu:',
                    value: '1-11-2024',
                  ),
                  SizedBox(height: 8),
                  InfoRow(
                    title: 'Thời gian kết thúc:',
                    value: '31-12-2024',
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
          ],
        ),
      ),
    );
  }
}

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

class StudentListScreen extends StatelessWidget {
  final List<Map<String, String>> students = List.generate(
    100,
        (index) => {'name': 'Phạm Quốc Đạt', 'id': '20215345'},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFAE2C2C),
        toolbarHeight: 115,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
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
                border: Border.all(color: Colors.black, width: 1), // Viền đen
                borderRadius: BorderRadius.circular(8), // Bo góc
              ),
              child: Text(
                'Giải tích III - 149732',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'Danh sách lớp (100)',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: ListView.separated(
                        itemCount: students.length,
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.black26, // Gạch mờ giữa các sinh viên
                          thickness: 1,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${index + 1}',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold)),
                                Text(students[index]['name']!),
                                Text(students[index]['id']!),
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
