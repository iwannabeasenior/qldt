import 'package:dartz/dartz.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/remote/api_service_it5023e.dart';
import 'package:qldt/data/request/get_class_list_request.dart';
import 'package:qldt/helper/failure.dart';

import '../model/class_info.dart';
import '../request/edit_class_request.dart';

abstract class ClassRepo {
  Future<Either<Failure, List<Class>>> getAllClass(GetClassListRequest request);
  Future<ClassInfo> getClassInfo(String token, String role, String accountId, String classId);
  Future<Map<String, dynamic>> editClass(EditClassRequest editClassRequest);
  Future<void> addStudent(String token, String classId, String accountId);
}


class ClassRepoImpl extends ClassRepo {
  ApiServiceIT5023E api;
  ClassRepoImpl({required this.api});
  @override
  Future<Either<Failure, List<Class>>> getAllClass(GetClassListRequest request) async {
    return await api.getAllClass(request);
  }

  @override
  Future<ClassInfo> getClassInfo(String token, String role, String accountId, String classId) {
    return api.getClassInfo(token, role, accountId, classId);
  }

  @override
  Future<Map<String, dynamic>> editClass(EditClassRequest editClassRequest) {
    return api.editClass(editClassRequest);
  }

  @override
  Future<void> addStudent(String token, String classId, String accountId) {
    return api.addStudent(token, classId, accountId);
  }
}