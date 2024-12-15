import 'package:flutter/material.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/repo/material_repository.dart';

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
      final textResponse = await _repo.deleteMaterial(token, materialID);
      materials.remove(materials.firstWhere((material) => material.id == materialID));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
