import 'package:flutter/material.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class OpenClassList extends StatefulWidget {
  const OpenClassList({super.key});

  @override
  State<OpenClassList> createState() => _OpenClassListPageState();
}

class _OpenClassListPageState extends State<OpenClassList> {
  final List<Map<String, String>> classData = [
    {"maLop": "101", "maLopKem": "201", "tenLop": "Toán Cơ Bản"},
    {"maLop": "102", "maLopKem": "202", "tenLop": "Vật Lý Cơ Bản"},
    {"maLop": "103", "maLopKem": "203", "tenLop": "Hóa Học Cơ Bản"},
    // Add more classes as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Danh sách các lớp mở",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: QLDTColor.red,
      ),
      backgroundColor: QLDTColor.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Table(
              border: TableBorder.all(color: Colors.white),
              children: [
                TableRow(
                  children: [
                    Container(
                      color: QLDTColor.red, // Header background color
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Mã Lớp',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Container(
                      color: QLDTColor.red, // Header background color
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Mã Lớp Kèm',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Container(
                      color: QLDTColor.red, // Header background color
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Tên Lớp',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                ...classData.map((data) {
                  return TableRow(
                    children: [
                      Container(
                        color: QLDTColor.red, // Row background color
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data["maLop"]!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        color: QLDTColor.red, // Row background color
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data["maLopKem"]!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        color: QLDTColor.red, // Row background color
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data["tenLop"]!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
