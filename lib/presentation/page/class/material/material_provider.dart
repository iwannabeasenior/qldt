import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/repo/material_repository.dart';
import 'package:qldt/data/request/material_request.dart';

class MaterialProvider with ChangeNotifier {
  final MaterialRepo _repo;

  MaterialProvider(this._repo);

  List<Materials> _materials = [];
  bool _isLoading = false;

  List<Materials> get materials => _materials;
  bool get isLoading => _isLoading;

  Future<void> fetchMaterials(String token, String classId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _materials = await _repo.getMaterialList(token, classId);
    } catch (e) {
    print(e);
    } finally { // always occured
    _isLoading = false;
    notifyListeners();
    }
  }

  Future<void> deleteMaterial(String token, String materialID) async {
    try {
      await _repo.deleteMaterial(token, materialID);
      materials.remove(materials.firstWhere((material) => material.id == materialID));
      notifyListeners();
    } catch (e) {
      Logger().d(e);
    }
  }

  Future<void> uploadMaterial(UploadMaterialRequest request) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newMaterial = await _repo.uploadMaterial(request);
      materials.add(newMaterial);
      notifyListeners();
    } catch(e) {
      Logger().d(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editMaterial(EditMaterialRequest request) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newMaterial = await _repo.editMaterial(request);
      // update to ui
      final index = materials.indexWhere((material) => material.id == request.materialId);
      if (index != -1) {
        materials[index] = newMaterial;
        notifyListeners();
      }
    } catch(e) {
      Logger().d(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Materials?> getMaterialInfo(String token, String materialId) async {
    try {
      return await _repo.getMaterialInfo(token, materialId);
    } catch(e) {
      Logger().d(e);
    }
  }


}