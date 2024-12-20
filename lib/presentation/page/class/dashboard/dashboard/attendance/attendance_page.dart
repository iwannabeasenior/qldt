import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/repo/attendance_repository.dart';
import 'package:qldt/presentation/page/class/dashboard/dashboard/attendance/attendance_provider.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AttendanceRepo>();  // Reading the AttendanceRepo

    return ChangeNotifierProvider(
      create: (context) => AttendanceProvider(repo),
      child: const AttendancePageView(),  // Passing the AttendancePageView widget
    );
  }
}

class AttendancePageView extends StatefulWidget {
  const AttendancePageView({super.key});

  @override
  State<AttendancePageView> createState() => _AttendancePageViewState();
}

class _AttendancePageViewState extends State<AttendancePageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AttendanceProvider>();
      provider.fetchAttendanceRecord("j4HWOV", "000100"); // Replace with actual token and classId
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

