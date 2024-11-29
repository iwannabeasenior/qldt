import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final List<String> absenceDates = [
    "2024-11-28",
    "2024-11-29",
    "2024-11-30",
  ];

  // Lấy danh sách các ngày vắng mặt duy nhất
  List<String> getUniqueDates(List<String> dates) {
    return dates.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    // Tính tổng số lần vắng mặt và các ngày duy nhất
    final totalAbsences = absenceDates.length;
    final uniqueDates = getUniqueDates(absenceDates);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Absence Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Absences: $totalAbsences',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: uniqueDates.length,
                itemBuilder: (context, index) {
                  final date = uniqueDates[index];
                  return ListTile(
                    leading: const Icon(Icons.date_range),
                    title: Text(
                      date,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
