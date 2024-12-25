

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qldt/data/model/attendance_student_detail.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/repo/manage_class_repository.dart';
import 'package:qldt/data/repo/material_repository.dart';
import 'package:qldt/data/request/class_create_request.dart';
import 'package:qldt/data/request/material_request.dart';
import 'package:qldt/presentation/page/manage_class/custom_exception.dart';
import 'package:qldt/presentation/page/manage_class/open_class_list.dart';
import 'package:qldt/data/model/open_class_response.dart'; // Import the correct one


class ManageClassProvider with ChangeNotifier {
  final ManageClassRepo _repo;
  ManageClassProvider(this._repo);


  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? res; // Tạo kiểu cho `res`

  List<ClassModel1> openClassList = [];
  List<ClassModel1> openClassListCache = [];
  List<int> listPageCache = [];

PageInfo1 pageInfo1 = PageInfo1(
  totalRecords: '0',
  totalPage: '0',
  pageSize: '0',
  page: '0',
  nextPage: null,
  previousPage: null,
);

  bool get hasMore => pageInfo1.nextPage != null;


  Future<void> createClass(ClassCreateRequest classCreateRequest, BuildContext context) async {
    notifyListeners();

    try {
      _isLoading = true;
      res = await _repo.createClass(classCreateRequest);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo lớp thành công')),
      );
    } on Exception catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${e.getMessage}')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> getOpenClassList(String token, String page, String pageSize) async {
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   try {
  //     final classes = await _repo.getOpenClass(token, page, pageSize);
  //
  //     openClassList = classes.classes;
  //     pageInfo1 = classes.pageInfo;
  //
  //     Logger().d("Fetched open class list: ${openClassList.length} classes");
  //
  //   } catch (e) {
  //     Logger().e("Error fetching open class list: $e");
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> getOpenClassList(String token, String page, String pageSize) async {
  //   if (_isLoading) return; // Prevent multiple requests at the same time
  //
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   try {
  //     final classes = await _repo.getOpenClass(token, page, pageSize);
  //
  //     openClassList.addAll(classes.classes); // Append to the existing list
  //     pageInfo1 = classes.pageInfo;
  //
  //     Logger().d("Fetched open class list: ${openClassList.length} classes");
  //
  //   } catch (e) {
  //     Logger().e("Error fetching open class list: $e");
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> getOpenClassList(String token, String page, String pageSize, {bool replace = false}) async {
    if (_isLoading) return; // Prevent multiple requests at the same time

    _isLoading = true;
    notifyListeners();

    try {
      final classes = await _repo.getOpenClass(token, page, pageSize);

      if (replace) {
        openClassList = classes.classes; // Replace the list entirely
      } else {
        openClassList.addAll(classes.classes); // Append the new data
      }

      if (listPageCache.indexWhere((value) => value == int.parse(page)) == -1) {
        Logger().d("logger: $page");
        listPageCache.add(int.parse(page));
        openClassListCache.addAll(classes.classes);
        Logger().d("so luong trong: ${openClassListCache.length}");
      }

      pageInfo1 = classes.pageInfo;

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

















































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































