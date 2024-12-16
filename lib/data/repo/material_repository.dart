import 'package:dartz/dartz.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/remote/api_service_it5023e.dart';
import 'package:qldt/data/request/material_request.dart';
import 'package:qldt/helper/failure.dart';

abstract class MaterialRepo {
  Future<List<Materials>> getMaterialList(String token, String classID);
  Future<Materials> getMaterialInfo(String token, String materialId);
  Future<void> deleteMaterial(String token, String materialID);
  Future<Materials> uploadMaterial(UploadMaterialRequest request);
  Future<Materials> editMaterial(EditMaterialRequest request);
}

class MaterialRepoImpl extends MaterialRepo {
  ApiServiceIT5023E api;

  MaterialRepoImpl({required this.api});

  @override
  Future<void> deleteMaterial(String token, String materialID) {
    return api.deleteMaterial(token, materialID);
  }

  @override
  Future<Materials> editMaterial(EditMaterialRequest request) {
    return api.editMaterial(request);
  }

  @override
  Future<Materials> getMaterialInfo(String token, String materialId) {
    return api.getMaterialInfo(token, materialId);
  }

  @override
  Future<List<Materials>> getMaterialList(String token, String classID) {
    return api.getAllMaterials(token, classID);
  }

  @override
  Future<Materials> uploadMaterial(UploadMaterialRequest request) {
    return api.uploadMaterial(request);
  }

}