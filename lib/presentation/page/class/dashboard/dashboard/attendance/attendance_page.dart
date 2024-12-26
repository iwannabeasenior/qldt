import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/repo/attendance_repository.dart';
import 'package:qldt/presentation/page/class/dashboard/dashboard/attendance/attendance_provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
//student

class AttendancePage extends StatefulWidget {
  final classId;
  const AttendancePage({super.key, required this.classId});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AttendanceProvider>();
      provider.fetchAttendanceRecord(UserPreferences.getToken() ?? "", widget.classId); // Replace with actual token and classId
    });
  }

  // Helper method to get unique dates
  List<String> getUniqueDates(List<String> dates) {
    return dates.toSet().toList(); // Ensures only unique dates are included
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absence Request'),
      ),
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final totalAbsences = provider.attendanceRecord.length;
          final uniqueDates = getUniqueDates(provider.attendanceRecord);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Absences: $totalAbsences', // Display total absences
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: uniqueDates.length, // Number of unique dates
                    itemBuilder: (context, index) {
                      final date = uniqueDates[index]; // Get date
                      return ListTile(
                        leading: const Icon(Icons.date_range), // Icon for date
                        title: Text(
                          date, // Display date
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

