import 'package:flutter/material.dart';

class AttendanceDetailScreen extends StatefulWidget {
  final String date; // Pass the selected date
  const AttendanceDetailScreen({super.key, required this.date});

  @override
  State<AttendanceDetailScreen> createState() =>
      _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen> {
  final List<Map<String, dynamic>> students = [
    {"id": "20215482", "name": "Nguyễn TT", "status": "PRESENT"},
    {"id": "20222023", "name": "Phạm Quốc Đạt", "status": "EXCUSED_ABSENCE"},

  ];

  final List<String> statuses = ["PRESENT", "EXCUSED_ABSENCE", "UNEXCUSED_ABSENCE"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          widget.date,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(3),
                },
                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: Colors.grey),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'STT',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'MSSV',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Tên',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Status',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  for (int i = 0; i < students.length; i++)
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text((i + 1).toString()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(students[i]["id"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(students[i]["name"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          value: students[i]["status"].isEmpty
                              ? null
                              : students[i]["status"],
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              students[i]["status"] = newValue!;
                            });
                          },
                          items: statuses
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: const Text("Select"),
                        ),
                      ),
                    ]),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "PRESENT, EXCUSED_ABSENCE, UNEXCUSED_ABSENCE",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding:
              const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
            ),
            onPressed: () {
              // Implement your submission logic here
              final submissionData = {
                "date": widget.date,
                "students": students,
              };
              print(submissionData); // Replace with actual submission
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Attendance submitted!")),
              );
            },
            child: const Text("Gửi"),
          ),
        ],
      ),
    );
  }
}
