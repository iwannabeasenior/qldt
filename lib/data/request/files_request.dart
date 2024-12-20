import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class FileRequest {
  Uint8List? fileData;
  PlatformFile? file;

  FileRequest({this.fileData, this.file});
}