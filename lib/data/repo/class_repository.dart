import 'package:dartz/dartz.dart';
import 'package:qldt/data/model/class.dart';
import 'package:qldt/data/remote/api_service_it5023e.dart';
import 'package:qldt/data/request/get_class_list_request.dart';
import 'package:qldt/helper/failure.dart';

abstract class ClassRepo {
  Future<Either<Failure, List<Class>>> getAllClass(GetClassListRequest request);
}
class ClassRepoImpl extends ClassRepo {
  ApiServiceIT5023E api;
  ClassRepoImpl({required this.api});
  @override
  Future<Either<Failure, List<Class>>> getAllClass(GetClassListRequest request) async {
    return await api.getAllClass(request);
  }
}