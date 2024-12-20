import 'package:dartz/dartz.dart';
import 'package:qldt/data/model/absence_student.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/remote/api_service_it5023e.dart';
import 'package:qldt/data/request/material_request.dart';
import 'package:qldt/helper/failure.dart';

import '../../presentation/page/manage_class/open_class_list.dart';
import '../model/absence_lecturer.dart';
import '../request/absence_request.dart';
import '../request/class_create_request.dart';
import '../request/get_student_absence.dart';

abstract class ManageClassRepo {
  Future<Map<String, dynamic>> createClass(ClassCreateRequest classCreateRequest);
  Future<List<ClassModel1>> getOpenClass(String token, String page, String pageSize);
  Future<Map<String, dynamic>> registerClass(String token, List<String> classIds);



}

class ManageClassRepoImpl extends ManageClassRepo {
  ApiServiceIT5023E api;

  ManageClassRepoImpl({required this.api});

  @override
  Future<Map<String, dynamic>> createClass(ClassCreateRequest classCreateRequest ) {
  return api.createClass(classCreateRequest);
  }

  @override
  Future<List<ClassModel1>> getOpenClass(String token, String page, String pageSize) {
    return api.getOpenClass(token, page, pageSize);
  }

  @override
  Future<Map<String, dynamic>> registerClass(String token, List<String> classIds) {
    return api.registerClass(token, classIds );
  }





}