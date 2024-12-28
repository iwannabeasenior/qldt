import 'dart:io';

import 'package:qldt/data/request/files_request.dart';

class UploadMaterialRequest {
  String classID;
  String? title;
  String? description;
  String? materialType;
  FileRequest? file;
  String token;
  UploadMaterialRequest({required this.classID, required this.title, required this.description, required this.materialType, required this.file, required this.token});
}


class EditMaterialRequest {
  String materialId;
  String? title;
  String? description;
  String? materialType;
  List<File> files;
  String token;

  EditMaterialRequest({required this.materialId, required this.title, required this.description,
      required this.materialType, required this.files, required this.token});
}
