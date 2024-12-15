import 'package:dartz/dartz.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/remote/api_service_it5023e.dart';
import 'package:qldt/helper/failure.dart';

abstract class MaterialRepo {
  Future<List<Materials>> getMaterialList(String token, String classID);
  Future<Either<Failure, void>> getMaterialInfo();
  Future<Either<Failure, void>> editMaterial();
  Future<String> deleteMaterial(String token, String materialID);
  Future<Either<Failure, void>> uploadMaterial();
}

class MaterialRepoImpl extends MaterialRepo {
  ApiServiceIT5023E api;

  MaterialRepoImpl({required this.api});

  @override
  Future<String> deleteMaterial(String token, String materialID) {
    return api.deleteMaterial(token, materialID);
  }

  @override
  Future<Either<Failure, void>> editMaterial() {
    // TODO: implement editMaterial
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> getMaterialInfo() {
    // TODO: implement getMaterialInfo
    throw UnimplementedError();
  }

  @override
  Future<List<Materials>> getMaterialList(String token, String classID) {
    return api.getAllMaterials(token, classID);
  }

  @override
  Future<Either<Failure, void>> uploadMaterial() {
    // TODO: implement uploadMaterial
    throw UnimplementedError();
  }

}