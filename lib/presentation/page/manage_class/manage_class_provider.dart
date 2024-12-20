import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/repo/manage_class_repository.dart';
import 'package:qldt/data/repo/material_repository.dart';
import 'package:qldt/data/request/class_create_request.dart';
import 'package:qldt/data/request/material_request.dart';
import 'package:qldt/presentation/page/manage_class/open_class_list.dart';

class ManageClassProvider with ChangeNotifier {
  final ManageClassRepo _repo;
  ManageClassProvider(this._repo);


  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? res; // Tạo kiểu cho `res`

  List<ClassModel1> openClassList = [];


  Future<void> createClass(ClassCreateRequest classCreateRequest) async {
    notifyListeners();

    try {
      _isLoading = true;
      res = await _repo.createClass(classCreateRequest);
    } catch (e) {
      Logger().e("Error requesting absence: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getOpenClassList(String token, String page, String pageSize) async {
    _isLoading = true;
    notifyListeners();

    try {
      final classes = await _repo.getOpenClass(token, page, pageSize);

      openClassList = classes;

      Logger().d("Fetched open class list: ${openClassList.length} classes");

    } catch (e) {
      Logger().e("Error fetching open class list: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> registerClass(String token, List<String> classIds) async {
    _isLoading = true;
    notifyListeners();

    try {
      final classes = await _repo.registerClass(token, classIds);
    } catch (e) {
      Logger().e("Error register Class: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}

















































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































