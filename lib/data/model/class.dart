import 'package:qldt/helper/enum.dart';

class Class {

  final String id;
  final String? name;
  final String? attachedCode;
  final String? classType;
  final String? lecturerName;
  final String? studentCount;
  final String? startDate;
  final String? endDate;
  final String? status;

  factory Class.fromJson(Map<String, dynamic> response) =>
      Class(
          id: response['class_id'],
          name: response['class_name'],
          attachedCode: response['attached_code'],
          lecturerName: response['lecturer_name'],
          classType: response['class_type'],
          studentCount: response['student_count'],
          startDate: response['start_date'],
          endDate: response['end_date'],
          status: response['status']
      );

  Class({
    required this.id,
    required this.name,
    required this.attachedCode,
    required this.lecturerName,
    required this.classType,
    required this.studentCount,
    required this.startDate,
    required this.endDate,
    required this.status
  });
}