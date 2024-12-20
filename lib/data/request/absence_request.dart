import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class AbsenceRequest {

  String? token;
  String? classId;
  String? date;
  String? reason;
  String? title;
  List<AbsenceFileRequest>? files;

  AbsenceRequest({
    required this.token,
    required this.classId,
    required this.date,
    required this.reason,
    required this.title,
    required this.files
  });
}

class AbsenceFileRequest {
  Uint8List? fileData;
  PlatformFile? file;

  AbsenceFileRequest({this.fileData, this.file});
}