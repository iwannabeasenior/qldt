import 'dart:io';

class MaterialRequest {
  String classID;
  String materialName;
  String description;
  String materialType;
  File file;
  MaterialRequest({required this.classID, required this.materialName, required this.description, required this.materialType, required this.file});
}
