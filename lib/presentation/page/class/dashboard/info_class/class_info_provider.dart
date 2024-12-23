import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/class_info.dart';
import 'package:qldt/data/request/edit_class_request.dart';

import '../../../../../data/repo/class_repository.dart';

class ClassInfoProvider extends ChangeNotifier {
  ClassInfo? _classInfo;
  final ClassRepo _repo;
  ClassInfo? get classInfo => _classInfo;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ClassInfoProvider(this._repo);

  Future<void> getClassInfo(String token, String role, String accountId, String classId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _classInfo = await _repo.getClassInfo(token, role, accountId, classId);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editClass(EditClassRequest editClassRequest) async {
    notifyListeners();

    try {
      _isLoading = true;
      await _repo.editClass(editClassRequest);
    } catch(e) {
      Logger().e(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}